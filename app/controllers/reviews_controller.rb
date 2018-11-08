class ReviewsController < ApplicationController

  def new
    @item = Item.find(params[:item_id])
    @review = Review.new
  end

  def create
    @item = Item.find(params[:item_id])
    ids = Order.where(user_id: current_user.id).pluck(:id)

    # Find every time I've ordered this item
    order_item_ids = OrderItem.
                      where(order_id: ids).
                      where(item_id: params[:item_id]).
                      pluck(:id)

    # Find any reviews I've left for this item
    my_reviews = Review.where(order_item_id: order_item_ids)

    if my_reviews.length >= order_item_ids.length
      notice = "You've Already Reviewed This Item"
    else
      # Find the order items that dont have reviews associated with them
      # Take the first element of the array. We don't neccesarily care
      # about the association between a review and the individual order-item

      r = Review.new(review_params)
      if my_reviews.empty?
        r.order_item_id = order_item_ids.first
      else
        r.order_item_id = (order_item_ids - my_reviews.pluck(:order_item_id)).first
      end
      r.save
      notice = "Review Added"
    end
    redirect_to item_path(params[:item_id]), notice: notice
  end

  private

  def review_params
    params.require(:review).permit(:title, :description, :rating)
  end

end
