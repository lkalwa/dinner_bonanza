class Recipe < ApplicationRecord
  include PgSearch::Model
  paginates_per 5

  has_many :ingredients, dependent: :destroy

  pg_search_scope :search_among_ingredients,
                  associated_against: { ingredients: :content },
                  using: { tsearch: { dictionary: "english", prefix: true } }

  validates :title, presence: true
  validates :cook_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :prep_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }, allow_nil: true
end
