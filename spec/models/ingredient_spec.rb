RSpec.describe Ingredient, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'associations' do
    it { should belong_to(:recipe) }
  end

  describe 'factory' do
    it { expect(build(:ingredient)).to be_valid }
  end
end
