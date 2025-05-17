class RecipesController < ApplicationController
  before_action :assign_ingredients
  def index
    scope = ingredients? ? Recipe.search_among_ingredients(format_to_fulltext_search) : Recipe.order(rating: :desc)
    @recipes = scope.page(params[:page])
  end

  def show
    @recipe = Recipe.includes(:ingredients).find(params[:id])
    @back_url = request.referrer
  end

  private
  def ingredients?
    params[:ingredients].present?
  end

  def format_to_fulltext_search
    @ingredients.join(" & ")
  end

  def assign_ingredients
    @ingredients = ingredients? ? params[:ingredients].map(&:presence).compact : []
  end
end
