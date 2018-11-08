class Review < ApplicationRecord

  belongs_to :order_item

  validates_presence_of :title
  validates_presence_of :description
  # TODO update to validate within 1-5
  validates_presence_of :rating
  validates_numericality_of :rating

  def self.reviews_for_item(item_id)
    ids = OrderItem.where(item_id: item_id).ids
    Review.where(order_item_id: ids)
  end

end
