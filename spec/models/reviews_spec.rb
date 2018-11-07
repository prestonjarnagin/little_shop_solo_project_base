require 'rails_helper'

RSpec.describe Review, type: :model do

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :rating }
    # TODO The view should only allow a 1 to 5 rating, but this should validate as well
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(0) }
  end

  describe 'Relationships' do
    it { should belong_to(:user_item) }
  end


end
