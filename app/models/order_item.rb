class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  has_many :reviews

  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def subtotal
    s = quantity * price
    # binding.pry
    s
  end
end
