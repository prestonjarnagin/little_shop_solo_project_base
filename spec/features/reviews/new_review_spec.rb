require 'rails_helper'

RSpec.describe 'Reviews' do

  before(:each) do
    @user = create(:user)

    @merchant = create(:merchant)
    @item_1, @item_2, @item_3, @item_4, @item_5 = create_list(:item, 5, user: @merchant)

    @order_1 = create(:order, user: @user)
    create(:order_item, order: @order_1, item: @item_1)
    create(:order_item, order: @order_1, item: @item_2)

    @order_2 = create(:completed_order, user: @user)
    create(:fulfilled_order_item, order: @order_2, item: @item_2)
    create(:fulfilled_order_item, order: @order_2, item: @item_3)

    @order_3 = create(:cancelled_order, user: @user)
    create(:order_item, order: @order_3, item: @item_3)
    create(:order_item, order: @order_3, item: @item_4)

    @order_4 = create(:disabled_order, user: @user)
    create(:order_item, order: @order_4, item: @item_1)
    create(:order_item, order: @order_4, item: @item_3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end


  it 'should allow me to navigate to leave a new review' do
    create(:order_item, order: @order_1, item: @item_1)
    visit orders_path

    click_link("Leave Review", :match => :first)
    expect(current_path).to eq(new_item_review_path(@item_1))
  end

  it 'should show me my review after leaving it' do
    o_item_1 = create(:fulfilled_order_item, order: @order_1, item: @item_1)

    visit orders_path
    within ("#order-item-#{o_item_1.id}") do
      click_link("Leave Review")
    end
    fill_in 'Title', with: "Review Title 1"
    fill_in 'Description', with: "Review Description 1"
    select "4", :from => "Rating"
    click_on 'Create Review'
    expect(current_path).to eq(item_path(@item_1))

    expect(page).to have_content("Review Title 1")
    expect(page).to have_content("Review Description 1")
    expect(page).to have_content("Rating: 4/5")
  end

  it 'should let me review for each order_item instance' do
    o_item_1 = create(:fulfilled_order_item, order: @order_1, item: @item_1)
    o_item_2 = create(:fulfilled_order_item, order: @order_1, item: @item_1)

    visit orders_path
    within ("#order-item-#{o_item_1.id}") do
      click_link("Leave Review")
    end

    fill_in 'Title', with: "Review Title 1"
    fill_in 'Description', with: "Review Description 1"
    select "4", :from => "Rating"
    click_on 'Create Review'

    visit orders_path
    within ("#order-item-#{o_item_2.id}") do
      click_link("Leave Review")
    end

    fill_in 'Title', with: "Review Title 2"
    fill_in 'Description', with: "Review Description 2"
    select "2", :from => "Rating"
    click_on 'Create Review'
    expect(current_path).to eq(item_path(@item_1))
    expect(page).to have_content("Review Title 1")
    expect(page).to have_content("Review Title 2")
  end

  it 'wont let me review if ive already reviewed that order_item instance' do
    o_item_1 = create(:fulfilled_order_item, order: @order_1, item: @item_1)
    o_item_2 = create(:fulfilled_order_item, order: @order_1, item: @item_1)

    create(:review, order_item: o_item_1)
    create(:review, order_item: o_item_2)

    visit orders_path
    within ("#order-item-#{o_item_1.id}") do
      click_link("Leave Review")
    end

    fill_in 'Title', with: "Review Title 1"
    fill_in 'Description', with: "Review Description 1"
    select "4", :from => "Rating"
    click_on 'Create Review'
    expect(current_path).to eq(item_path(@item_1))

    expect(page).to have_content("You've Already Reviewed This Item")
    expect(page).not_to have_content("Review Title 1")
  end

  it 'wont let me review an unfilfilled item' do
    merchant = create(:merchant)
    @item_1 = create(:item, user: merchant)

    @order_1 = create(:order, user: @user)

    # Order Items are unfilfilled by default
    o_item_1 = create(:order_item, order: @order_1, item: @item_1)

    visit orders_path
    within ("#order-item-#{o_item_1.id}") do
      click_link("Leave Review")
    end

    fill_in 'Title', with: "Review Title 1"
    fill_in 'Description', with: "Review Description 1"
    select "4", :from => "Rating"
    click_on 'Create Review'

    expect(current_path).to eq(item_path(@item_1))

    expect(page).to have_content("That Item Has Not Been Marked as Fulfilled")
    expect(page).not_to have_content("Review Title 1")
  end

  it 'wont let me review on a cancelled order' do
    canceled_order = create(:cancelled_order, user: @user)
    cancelled_o_item_1 = create(:fulfilled_order_item, order: canceled_order, item: @item_1)

    # Order items are somehow fulfilled but the order containing
    # them was cancelled

    visit orders_path
    within ("#order-item-#{cancelled_o_item_1.id}") do
      click_link("Leave Review")
    end

    fill_in 'Title', with: "Review Title 1"
    fill_in 'Description', with: "Review Description 1"
    select "4", :from => "Rating"
    click_on 'Create Review'

    expect(current_path).to eq(item_path(@item_1))
    expect(page).to have_content("That Order Has Been Marked as Cancelled")
    expect(page).not_to have_content("Review Title 1")
  end

  it 'shows the rating in reverse chronological order' do
    o_item_1 = create(:fulfilled_order_item, order: @order_1, item: @item_1)
    o_item_2 = create(:fulfilled_order_item, order: @order_1, item: @item_1)
    o_item_3 = create(:fulfilled_order_item, order: @order_1, item: @item_1)

    review_1 = create(:review, order_item: o_item_1, created_at: 3.days.ago)
    review_2 = create(:review, order_item: o_item_2, created_at: Time.now)
    review_3 = create(:review, order_item: o_item_3, created_at: 1.day.ago)

    visit item_path(@item_1)
    within all(".review")[0] do
      expect(page).to have_content(review_2.title)
      expect(page).to_not have_content(review_1.title)
      expect(page).to_not have_content(review_3.title)
    end
    within all(".review")[1] do
      expect(page).to have_content(review_3.title)
    end
    within all(".review")[2] do
      expect(page).to have_content(review_1.title)
    end
  end

end
