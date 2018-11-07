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

  describe 'Instance Methods' do
    it '.reviews_for_item(item_id)' do
      
    end
  end


end
