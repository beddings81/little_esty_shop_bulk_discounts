require 'rails_helper'

RSpec.describe 'bulk items show page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Foot Care')

    @discount1 = BulkDiscount.create!(percent_discount: 20, quantity_threshold: 30, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percent_discount: 30, quantity_threshold: 50, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percent_discount: 15, quantity_threshold: 20, merchant_id: @merchant2.id)

    visit merchant_bulk_discount_path(@merchant1, @discount1)
  end

  it 'contains a discounts quantity threshold and percent discount' do
    expect(page).to have_content(@discount1.id)
    expect(page).to have_content(@discount1.percent_discount)
    expect(page).to have_content(@discount1.quantity_threshold)
  end

  it 'contains a link to edit a bulk discount' do
    expect(page).to have_link("Edit Discount #{@discount1.id}")

    click_link("Edit Discount #{@discount1.id}")

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount1))
  end
end