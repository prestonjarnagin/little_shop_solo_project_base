class ReviewsController < ApplicationController

  def new
    @item = Item.find(params[:item_id])
    @review = Review.new
  end

  def create
    order = Order.
      joins(:order_items).
      where(user_id: current_user.id).
      where('order_items.item_id = ?', params[:item_id]).
      first
    # TODO
    # Find the first order item in which this user has ordered
    # this particular item. I'm not sure how to rework it so
    # a user can leave a review for each oder item. We don't know
    # which order item this review is for.
    r = Review.new(review_params)
    r.order_item_id = order.order_items.first.id
    r.save
    redirect_to item_path(params[:item_id])
  end

  private

  def review_params
    params.require(:review).permit(:title, :description, :rating)
  end

end
