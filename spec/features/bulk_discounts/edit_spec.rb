require 'rails_helper' 

RSpec.describe 'bulk discounts edit page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Foot Care')

    @discount1 = BulkDiscount.create!(percent_discount: 20, quantity_threshold: 30, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percent_discount: 30, quantity_threshold: 50, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percent_discount: 15, quantity_threshold: 20, merchant_id: @merchant2.id)

    visit edit_merchant_bulk_discount_path(@merchant1, @discount1)
  end

  it 'contains a prepopulated from to edit a bulk discount' do
    expect(page).to have_field("bulk_discount_percent_discount", with: 20)
    expect(page).to have_field("bulk_discount_quantity_threshold", with: 30)
    
    fill_in("bulk_discount_percent_discount", with: 100)
    fill_in("bulk_discount_quantity_threshold", with: 100)

    click_button("Update Bulk discount")

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
    
    expect(page).to have_content("Percent: 100%")
    expect(page).to have_content("Quantity: 100 Items")
  end
end