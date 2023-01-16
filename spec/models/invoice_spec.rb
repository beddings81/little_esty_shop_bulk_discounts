require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @bulk_discount = BulkDiscount.create!(percent_discount: 5, quantity_threshold: 9, merchant_id: @merchant1.id)
      @bulk_discount2 = BulkDiscount.create!(percent_discount: 5, quantity_threshold: 15, merchant_id: @merchant1.id)
      @bulk_discount3 = BulkDiscount.create!(percent_discount: 30, quantity_threshold: 100, merchant_id: @merchant1.id)
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Soap", description: "This washes your body", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 10, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Jeff', last_name: 'Green')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 2)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 50, unit_price: 10, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 100, unit_price: 10, status: 2)

  end
  describe "instance methods" do
    describe "#total_revenue" do
      it 'returns the total revenue for an invoice' do
        expect(@invoice_1.total_revenue).to eq(240)
        expect(@invoice_2.total_revenue).to eq(1500)
      end
    end
    
    describe "#discount" do
      it 'returns the discount total discount for an invoice' do
        expect(@invoice_1.total_discount).to eq(12)
        expect(@invoice_2.total_discount).to eq(325)
      end
    end

    describe '#discounted_total_revenue' do
      it 'returns the total revenue after all discounts' do
        expect(@invoice_1.discounted_total_revenue).to eq(228)
        expect(@invoice_2.discounted_total_revenue).to eq(1175)
      end
    end
  end
end
