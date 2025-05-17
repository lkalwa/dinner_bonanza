RSpec.describe Recipe, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_numericality_of(:cook_time).only_integer.is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:prep_time).only_integer.is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(5).allow_nil }
  end

  describe 'associations' do
    it { should have_many(:ingredients).dependent(:destroy) }
  end

  describe 'search' do
    let!(:recipe) { create(:recipe, :with_specific_ingredient) }

    it { expect(Recipe.search_among_ingredients('specific')).to include(recipe) }
  end
end
