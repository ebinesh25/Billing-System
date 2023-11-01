class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1 or /bills/1.json
  def show
  end

  # GET /bills/new
  def new
    @bill = Bill.new
    @bill.bill_products.build
    @products = Product.all.pluck(:id)
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills or /bills.json
  def create

    @products = Product.all.pluck(:id)
    @bill = Bill.new(bill_params.slice(:customer_email, :customer_amount))

    # bill_params.slice(:bill_products_attributes).each do |key, pair|
    #   byebug
    #   @bill_products = @bill.bill_products.build(product_id: [key][pair], quantity: bp[key][pair])
    # end

    bill_params[:bill_products_attributes].each do |index, attributes|
      # Create a new bill_product associated with the bill
      @bill_product = @bill.bill_products.build(
        product_id: attributes[:product_id],
        quantity: attributes[:quantity]
      )
      # Save the bill_product record
      @bill_product.save
    end


    @bill.denominations = bill_params.slice(:denominations)
    # params[:denominations] vs params.slice(:denominations) - .slice is secure and easily readable and self explanatory, Directly access may introduce permission threats
    respond_to do |format|
      if @bill.save
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully created." }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully updated." }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to bills_url, notice: "Bill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.

  def bill_params
    # Permit the main attributes and nested attributes
    params.require(:bill).permit(
      :customer_email,
      :customer_amount,
      # :bill_products,
      # :bill_products,
      bill_products_attributes: [:product_id, :quantity],
      # {denominations: %w[2000 500 200 100 50 10 5 2 1]}
      :denominations => {}

      )
  end

    # def bill_params
    #   params.require(:bill).permit(:customer_email, :customer_amount)
    # end
    #
    # def bill_product_params
    # params.require(:bill).permit( :bill_products,
    #                               bill_products_attributes: [:product_id, :quantity] )
    # end
    # #
    #   def denominations_params
    #   params.require(:bill).permit( denominations: %w[2000 500 200 100 50 10 5 2 1] )
    # end
end
