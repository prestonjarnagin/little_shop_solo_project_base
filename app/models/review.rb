class Review < ApplicationRecord

  belongs_to :order_item

  validates_presence_of :title
  validates_presence_of :description
  # TODO update to validate within 1-5
  validates_presence_of :rating
  validates_numericality_of :rating

end
