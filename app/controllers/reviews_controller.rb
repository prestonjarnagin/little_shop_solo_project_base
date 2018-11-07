class ReviewsController < ApplicationController

  def new
    @item = Item.find(params[:item_id])
    @review = Review.new
  end

  def create
    Review.create(review_params)

    redirect_to item_path(params[:item_id])
  end

  private

  def review_params
    params.require(:review).permit(:title, :descriptiomn, :rating)
  end

end
