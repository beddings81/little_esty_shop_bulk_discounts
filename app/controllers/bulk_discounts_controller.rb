class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.create!(percent_discount: params[:percent], quantity_threshold: params[:quantity], merchant_id: merchant.id)
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    merchant = Merchant.find(params[:merchant_id])

    redirect_to merchant_bulk_discounts_path(merchant)
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.update(bulk_discount_params)

    redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
  end


  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percent_discount, :quantity_threshold)
  end
end