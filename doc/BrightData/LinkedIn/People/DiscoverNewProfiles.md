# Class BrightData::LinkedIn::People::DiscoverNewProfiles <a id="class-BrightData-LinkedIn-People-DiscoverNewProfiles"></a>

**Inherits:** `Object`
**Includes:** `BrightData::LinkedIn::Endpoint`

People discover-new-profiles mode.

**@example**
```ruby
query = BrightData::LinkedIn::Types::PeopleDiscoverInput.new(
  url: "https://www.linkedin.com", first_name: "Jane", last_name: "Smith"
)
profiles = client.linkedin.people.discover_new_profiles.scrape(queries: [query])
```
