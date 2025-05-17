class RecipeData
  attr_reader :ingredients
  FIELDS = [ :title, :cook_time, :prep_time, :image_url, :rating ].freeze

  IngredientData = Data.define(:content)

  def initialize(hsh)
    @title = hsh["title"]
    @cook_time = hsh["cook_time"]
    @prep_time = hsh["prep_time"]
    @rating = hsh["ratings"]
    @ingredients = hsh["ingredients"].inject([]) { |acc, ingredient| acc << IngredientData.new(*ingredient) }
    @image_url = URI.decode_www_form_component(hsh["image"].split("url=").last)
  end

  def attrs_hash
    FIELDS.to_h { [ it, instance_variable_get(:"@#{it}") ] }
  end
end

module RecipeSeeder
  def self.create_recipes!
    recipes = JSON.load_file("#{Dir.pwd}/db/seeds/recipes-en.json")
    ActiveRecord::Base.transaction do
      i = 0
      recipes.each_slice(250) do |slice|
        puts "recipes: #{i*250} - #{i*250 + 250} "
        slice.each { create_recipe(it) }
        i += 1
      end
    end
  rescue Errno::ENOENT
    Rails.logger.error "recipes file not found"
  rescue JSON::ParserError => e
    Rails.logger.error "Unparseable file, exception: #{e.message}"
  end

  private

  def self.create_recipe(recipe_hash)
    RecipeData.new(recipe_hash).then do |recipe_data|
      recipe = Recipe.create!(recipe_data.attrs_hash)
      recipe_data.ingredients.each { Ingredient.create!(it.to_h.merge(recipe: recipe)) }
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "In #{recipe_hash} #{e.message}"
    end
  end
end
