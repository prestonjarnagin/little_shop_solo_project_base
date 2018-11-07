FactoryBot.define do
  factory :review do
    order_item
    sequence(:title) { |n| "Title #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:rating) { |n| rand(1..5) }
  end
end
