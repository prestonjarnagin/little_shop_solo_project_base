require 'rails_helper'

RSpec.describe Review, type: :model do

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :rating }
    # TODO The view should only allow a 1 to 5 rating, but this should validate as well
    it { should validate_numericality_of(:rating) }
  end

  describe 'Relationships' do
    it { should belong_to(:order_item) }
  end

  describe 'Class Methods' do
    it '.reviews_for_item(item_id)' do
      item = create(:item)

      order_item_1 = create(:order_item, item: item)
      order_item_2 = create(:order_item, item: item)
      review_1 = create(:review, order_item: order_item_1)
      review_2 = create(:review, order_item: order_item_2)

      expect(Review.reviews_for_item(item.id)[0]).to eq(review_1)
      expect(Review.reviews_for_item(item.id)[1]).to eq(review_2)
    end
  end


end
