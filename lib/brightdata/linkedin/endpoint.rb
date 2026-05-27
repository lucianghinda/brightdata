# frozen_string_literal: true

module BrightData
  # Namespace for Bright Data LinkedIn scraper endpoints.
  module LinkedIn
    # Shared trigger/scrape helpers for LinkedIn endpoint classes.
    #
    # Including this module gives a class the {ClassMethods#endpoint} macro,
    # which declares a whole endpoint mode (its `#initialize`, `#trigger`,
    # `#scrape`, input validation, and result parsing) from a few keywords.
    #
    # @api private
    module Endpoint
      # @return [String] Bright Data trigger path
      TRIGGER_PATH = "/datasets/v3/trigger"

      # @return [String] Bright Data synchronous scrape path
      SCRAPE_PATH = "/datasets/v3/scrape"

      # @param base [Class] including class
      def self.included(base)
        base.extend(ClassMethods)
      end

      # Declarative endpoint builder mixed into classes that include {Endpoint}.
      module ClassMethods
        # Declare an endpoint mode.
        #
        # Generates `#initialize(http:)`, `#trigger`/`#scrape` (with a real
        # keyword argument named after `param`), input validation, and result
        # parsing. Pass either `input` (each value is a URL string wrapped in
        # that input class) or `input_type` (each value must already be an
        # instance of that type).
        #
        # @param dataset_key [Symbol] key in {BrightData::Datasets::LINKEDIN}
        # @param result [#from_api] typed result class for parsing responses
        # @param param [Symbol] public keyword argument name, e.g. `:urls`
        # @param input [Class, nil] URL-input class wrapping each string value
        # @param input_type [Class, nil] required type for each pre-built value
        # @param extra_query [Hash] extra Bright Data query params
        # @return [void]
        def endpoint(dataset_key:, result:, param:, input: nil, input_type: nil, extra_query: {}) # rubocop:disable Metrics/ParameterLists -- each keyword names one facet of the endpoint DSL
          const_set(:DATASET_KEY, dataset_key)
          const_set(:EXTRA_QUERY, extra_query.freeze)
          define_initialize
          define_result_parser(result)
          input ? define_url_inputs(param, input) : define_object_inputs(param, input_type)
          define_actions(param)
        end

        private

        def define_initialize
          define_method(:initialize) { |http:| @http = http }
        end

        def define_result_parser(result)
          define_method(:result_parser) do
            ->(raw) { result_items(raw).map { |hash| result.from_api(hash) } }
          end
          private :result_parser
        end

        def define_url_inputs(param, input)
          label = param.to_s
          define_method(:build_inputs) do |values|
            raise ArgumentError, "#{label}: must be an Array, got #{values.class}" unless values.is_a?(Array)

            values.map { |url| input.new(url:) }
          end
          private :build_inputs
        end

        def define_object_inputs(param, input_type)
          label = param.to_s
          type_name = input_type.name.split("::").last
          define_method(:build_inputs) do |values|
            raise ArgumentError, "#{label}: must be an Array, got #{values.class}" unless values.is_a?(Array)

            values.each do |item|
              raise ArgumentError, "#{label}[] must be #{type_name}, got #{item.class}" unless item.is_a?(input_type)
            end
            values
          end
          private :build_inputs
        end

        # `trigger`/`scrape` need a real keyword named after `param` so a wrong
        # keyword raises Ruby's native ArgumentError; that requires class_eval.
        def define_actions(param)
          # For `param: :urls` this defines, e.g.:
          #   def trigger(urls:)
          #     trigger_with(dataset_key: DATASET_KEY, inputs: build_inputs(urls), extra_query: EXTRA_QUERY)
          #   end
          #
          #   def scrape(urls:)
          #     inputs = build_inputs(urls)
          #     return [] if inputs.empty?
          #
          #     scrape_with(dataset_key: DATASET_KEY, inputs:, extra_query: EXTRA_QUERY)
          #   end
          class_eval(<<~RUBY, __FILE__, __LINE__ + 1) # rubocop:disable Style/DocumentDynamicEvalDefinition -- the generated methods are spelled out in the comment above
            def trigger(#{param}:)
              trigger_with(dataset_key: DATASET_KEY, inputs: build_inputs(#{param}), extra_query: EXTRA_QUERY)
            end

            def scrape(#{param}:)
              inputs = build_inputs(#{param})
              return [] if inputs.empty?

              scrape_with(dataset_key: DATASET_KEY, inputs:, extra_query: EXTRA_QUERY)
            end
          RUBY
        end
      end

      private

      # Trigger an asynchronous Bright Data collection.
      #
      # @param dataset_key [Symbol] key in {BrightData::Datasets::LINKEDIN}
      # @param inputs [Array<Data>] input objects
      # @param extra_query [Hash] additional query params
      # @return [BrightData::Snapshot]
      def trigger_with(dataset_key:, inputs:, extra_query: {})
        payload = @http.post(
          path: TRIGGER_PATH,
          query: query_for(dataset_key:, extra: extra_query),
          body: { input: serialize_inputs(inputs) }
        )
        Snapshot.new(
          id: payload.fetch(Snapshot::TRIGGER_RESPONSE_KEY),
          http: @http,
          result_parser: result_parser
        )
      end

      # Run a synchronous Bright Data scrape.
      #
      # @param dataset_key [Symbol] key in {BrightData::Datasets::LINKEDIN}
      # @param inputs [Array<Data>] input objects
      # @param extra_query [Hash] additional query params
      # @return [Array] parsed results
      # @raise [BrightData::ScrapeTimeoutError] if Bright Data returns snapshot fallback
      def scrape_with(dataset_key:, inputs:, extra_query: {}) # rubocop:disable Metrics/MethodLength -- the snapshot-fallback branch belongs with the scrape it recovers from
        payload = @http.post(
          path: SCRAPE_PATH,
          query: query_for(dataset_key:, extra: extra_query),
          body: { input: serialize_inputs(inputs) }
        )
        if payload.is_a?(Hash) && payload[:snapshot_id]
          snapshot = Snapshot.new(
            id: payload.fetch(Snapshot::TRIGGER_RESPONSE_KEY),
            http: @http,
            result_parser: result_parser
          )
          raise ScrapeTimeoutError.new(
            "Bright Data /scrape exceeded its 60s cap. Use .trigger + Snapshot#wait, " \
            "or recover via e.snapshot.wait",
            snapshot_id: payload[:snapshot_id],
            snapshot:
          )
        end

        result_parser.call(payload)
      end

      # @return [#call] parser mapping raw API arrays to endpoint-specific values
      def result_parser
        ->(raw) { raw }
      end

      def query_for(dataset_key:, extra:)
        { dataset_id: Datasets.id_for(dataset_key) }.merge(extra)
      end

      def serialize_inputs(inputs)
        inputs.map do |input|
          input.respond_to?(:to_api_hash) ? input.to_api_hash : input.to_h
        end
      end

      def result_items(raw)
        case raw
        when Array
          raw.flat_map { |item| item.is_a?(Array) ? item : [item] }
        when Hash
          [raw]
        else
          []
        end
      end
    end
  end
end
