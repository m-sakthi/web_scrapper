FactoryBot.define do
  factory :product do
    title { "Some product" }
    url { "http://some-domain.com/some/path" }
    description { "It is a quality product made by quality raw materials" }
    scrapped_at { Time.now }
  end
end