RSpec.describe RecipeSeeder do
  let(:seeder) { described_class }
  let(:valid_recipe_hash) do
    {
      "title" => "Test Recipe",
      "cook_time" => 30,
      "prep_time" => 15,
      "ratings" => 4.5,
      "ingredients" => [ [ "Test Ingredient" ] ],
      "image" => "url=test.jpg"
    }
  end

  describe '.create_recipes!' do
    before do
      allow(File).to receive(:exist?).and_return(true)
      allow(JSON).to receive(:load_file).and_return([ valid_recipe_hash ])
    end

    it 'creates recipes and ingredients from JSON data' do
      expect { seeder.create_recipes! }.to change(Recipe, :count).by(1).and change(Ingredient, :count).by(1)

      recipe = Recipe.last
      expect(recipe.title).to eq("Test Recipe")
      expect(recipe.cook_time).to eq(30)
      expect(recipe.prep_time).to eq(15)
      expect(recipe.rating).to eq(4.5)
      expect(recipe.image_url).to eq("test.jpg")
      expect(recipe.ingredients.first.content).to eq("Test Ingredient")
    end

    context 'when file does not exist' do
      before { allow(JSON).to receive(:load_file).and_raise(Errno::ENOENT) }

      it 'logs error and does not raise exception' do
        expect(Rails.logger).to receive(:error).with("recipes file not found")
        expect { seeder.create_recipes! }.not_to raise_error
      end
    end

    context 'when JSON is invalid' do
      before { allow(JSON).to receive(:load_file).and_raise(JSON::ParserError.new("Invalid JSON")) }

      it 'logs error and does not raise exception' do
        expect(Rails.logger).to receive(:error).with(/Unparseable file/)
        expect { seeder.create_recipes! }.not_to raise_error
      end
    end

    context 'when recipe data is invalid' do
      let(:invalid_recipe_hash) do
        {
          "title" => "",
          "cook_time" => 10,
          "prep_time" => 15,
          "ratings" => 4.5,
          "ingredients" => [ [ "Test Ingredient" ] ],
          "image" => "url=test.jpg"
        }
      end

      before { allow(JSON).to receive(:load_file).and_return([ invalid_recipe_hash ]) }

      it 'logs error and continues processing' do
        expect(Rails.logger).to receive(:error).with(/Title can't be blank/)
        expect { seeder.create_recipes! }.not_to raise_error
      end
    end
  end

  describe 'RecipeData' do
    let(:attrs_hash) { RecipeData.new(valid_recipe_hash).attrs_hash }

    it 'generates correct attributes hash' do
      expect(attrs_hash[:title]).to eq("Test Recipe")
      expect(attrs_hash[:cook_time]).to eq(30)
      expect(attrs_hash[:prep_time]).to eq(15)
      expect(attrs_hash[:rating]).to eq(4.5)
      expect(attrs_hash[:image_url]).to eq("test.jpg")
    end
  end
end
