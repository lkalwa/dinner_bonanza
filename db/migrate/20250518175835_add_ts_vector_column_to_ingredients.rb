class AddTsVectorColumnToIngredients < ActiveRecord::Migration[8.0]
  def change
    add_column :recipes, :ingredients_tsv, :tsvector

    execute <<-SQL
      CREATE INDEX recipes_ingredients_tsv_idx ON recipes USING GIN (ingredients_tsv);
    SQL

    execute <<-SQL
      UPDATE recipes 
      SET ingredients_tsv = (
        SELECT to_tsvector('english', string_agg(coalesce(ingredients.content, ''), ' '))
        FROM ingredients
        WHERE ingredients.recipe_id = recipes.id
      );
    SQL

    execute <<-SQL
      CREATE FUNCTION recipes_ingredients_tsv_trigger() RETURNS trigger AS $$
      BEGIN
        UPDATE recipes
        SET ingredients_tsv = (
          SELECT to_tsvector('english', string_agg(coalesce(ingredients.content, ''), ' '))
          FROM ingredients
          WHERE ingredients.recipe_id = recipes.id
        )
        WHERE id = NEW.recipe_id;
        RETURN NEW;
      END
      $$ LANGUAGE plpgsql;
    SQL

    execute <<-SQL
      CREATE TRIGGER recipes_ingredients_tsv_trigger
      AFTER INSERT OR UPDATE OR DELETE ON ingredients
      FOR EACH ROW
      EXECUTE FUNCTION recipes_ingredients_tsv_trigger();
    SQL
  end
end
