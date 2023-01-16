require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:bulk_discounts).through(:item) }
  end

  before(:each) do
    @merchant1 = Merchant.create!(name: 'Merchant 1')

    @bulk_discount = BulkDiscount.create!(percent_discount: 0.05, quantity_threshold: 9, merchant_id: @merchant1.id)
    @bulk_discount2 = BulkDiscount.create!(percent_discount: 0.05, quantity_threshold: 5, merchant_id: @merchant1.id)


    @customer1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
    @customer2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
    @customer3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
    @customer4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
    @customer5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
    @customer6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')

    @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @merchant1.id)

    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2)
    @invoice2 = Invoice.create!(customer_id: @customer1.id, status: 2)
    @invoice3 = Invoice.create!(customer_id: @customer2.id, status: 2)
    @invoice4 = Invoice.create!(customer_id: @customer3.id, status: 2)
    @invoice5 = Invoice.create!(customer_id: @customer4.id, status: 2)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item_2.id, quantity: 5, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item_3.id, quantity: 9, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
  end
  
  describe "class methods" do
    describe '#incomplete_invoices' do
      it 'returns incomplete invoices' do
        expect(InvoiceItem.incomplete_invoices).to eq([@invoice1, @invoice3])
      end
    end
  end

  describe "instance methods" do
    describe '#applied_discount' do
      it 'returns the applied discount' do
        expect(@ii_1.applied_discount).to eq(nil)
        expect(@ii_2.applied_discount).to eq(@bulk_discount2)
        expect(@ii_3.applied_discount).to eq(@bulk_discount)
      end
    end
  end
end
