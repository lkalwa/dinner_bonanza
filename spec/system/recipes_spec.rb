require 'rails_helper'

RSpec.describe 'Recipes', type: :system do
  let!(:recipe) { create(:recipe, :with_ingredients) }
  let!(:recipe_with_specific) { create(:recipe, :with_specific_ingredient) }

  before do
    driven_by(:selenium_chrome_headless)
  end

  describe 'index page' do
    it 'displays list of recipes' do
      visit root_path
      expect(page).to have_content('Ingredients on hand:')
      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe_with_specific.title)
    end

    it 'allows adding ingredients to search' do
      visit root_path
      fill_in 'ingredients[]', with: 'specific'
      click_button '+ Add Ingredient'
      expect(page).to have_content('specific')
    end

    it 'filters recipes by ingredients' do
      visit root_path
      fill_in 'ingredients[]', with: 'specific'
      click_button '+ Add Ingredient'
      expect(page).to have_content(recipe_with_specific.title)
      expect(page).not_to have_content(recipe.title)
    end

    it 'allows removing ingredients from search' do
      visit root_path
      fill_in 'ingredients[]', with: 'specific'
      click_button '+ Add Ingredient'
      expect(page).to have_content('specific')

      find('.chip-delete-right').click
      expect(page).not_to have_content('specific')
    end
  end

  describe 'show page' do
    it 'displays recipe details' do
      visit recipe_path(recipe)
      expect(page).to have_content(recipe.title)
      expect(page).to have_content("Preparation time: #{recipe.prep_time}")
      expect(page).to have_content("Cooking time: #{recipe.cook_time}")
      recipe.ingredients.each do |ingredient|
        expect(page).to have_content(ingredient.content)
      end
    end

    it 'has a back link to recipes list' do
      visit recipe_path(recipe)
      expect(page).to have_link('<< Recipes list')
    end
  end
end
