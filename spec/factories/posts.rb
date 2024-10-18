FactoryBot.define do
  factory :post do
    title { "Sample Post Title" }
    content { "Sample post content." }
    association :user
  end
end
