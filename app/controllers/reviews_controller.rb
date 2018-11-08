class ReviewsController < ApplicationController

  def new
    @item = Item.find(params[:item_id])
    @review = Review.new
    @order_item = OrderItem.find(params[:order_item])
  end

  def create
    @item = Item.find(params[:item_id])
    @order_item = OrderItem.find(params[:order_item_id])

    notice = "You've Already Reviewed This Item" unless Review.where(order_item_id: @order_item.id).empty?
    notice = "That Item Has Not Been Marked as Fulfilled" unless @order_item.fulfilled
    notice = "That Order Has Been Marked as Disabled" if @order_item.order.status == "disabled"
    notice = "That Order Has Been Marked as Cancelled" if @order_item.order.status == "cancelled"

    unless notice
        r = Review.new(review_params)
        r.order_item_id = @order_item.id
        r.save
        notice = "Review Saved"
    end
    redirect_to item_path(params[:item_id]), notice: notice
  end

  private

  def review_params
    params.require(:review).permit(:title, :description, :rating)
  end

end
