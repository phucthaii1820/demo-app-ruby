class CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: {
      status: 200,
      message: "Categories retrieved successfully.",
      data: categories.as_json(only: [ :id, :name ])
    }, status: :ok
  end
end
