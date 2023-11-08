require 'json_web_token'
class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1 or /bills/1.json
  def show
    if params[:token]
      # @remaining_denominations = JsonWebToken.decode(params[:token])
      token_as_array = JWT.decode params[:token], nil, false
      @added_denominations = JSON.parse( token_as_array[0].gsub("=>", ":") )
      @remaining_denominations = remaining_denominations(@added_denominations, :sub)
      @bill_products = @bill.bill_products
      @calculate_price_for_user = @bill.calculate_balance_to_customer
    end
    # Decode token without raising JWT::ExpiredSignature error
  end

  # GET /bills/new
  def new
    @bill = Bill.new
    @bill.bill_products.build
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills or /bills.json
  def create

    @bill = Bill.new(bill_params.slice(:customer_email, :customer_amount))

    # bill_params.slice(:bill_products_attributes).each do |key, pair|
    #   @bill_products = @bill.bill_products.build(product_id: [key][pair], quantity: bp[key][pair])
    # end
    @remaining_denominations = remaining_denominations(bill_params.slice(:denominations))
    # params[:denominations] vs params.slice(:denominations) - .slice is secure and easily readable and self explanatory, Directly access may introduce permission threats
    @token = JWT.encode @remaining_denominations, nil, 'none'

    respond_to do |format|
      if @bill.save
        build_bill_products #=> is called to save the fields of nested attributes in DB once bill is save successfully
        unless @not_saved_attributes.present?
          format.html { redirect_to bill_url(@bill, token: @token), notice: "Bill was successfully created." }
          format.json { render :show, status: :created, location: @bill }
        else
          format.html {redirect_to request.referer, notice: "You can chose a Product ID only once" }
          format.json { render json: @bill.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params.slice(:customer_email, :customer_amount))
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
      # bill_products_attributes: %i[:id :product_id :quantity :_destroy], #=> :_destroy is permitted to destroy the field
      :bill_products_attributes => {}, #=> :_destroy is permitted to destroy the field
      # denominations: %w[2000 500 200 100 50 10 5 2 1]
      denominations: {}
      )
  end
  def build_bill_products
    bill_params[:bill_products_attributes].each do |index, attributes|
      # Create a new bill_product associated with the bill
      @not_saved_attributes = {}
      @bill_product = @bill.bill_products.build(
        product_id: attributes[:product_id],
        quantity: attributes[:quantity]
      )
      # Save the bill_product record
      if @bill_product.save
        @all_saved = true
      else
        @not_saved_attributes[attributes[:product_id]] = attributes[:quantity]
      end
    end
  end
  def remaining_denominations(denominations, operation)
    customer_amount = params[:bill][:customer_amount].to_i
    denominations = denominations["denominations"].transform_keys(&:to_i)
    denominations.each do |denom, count|
      needed_count = customer_amount / denom
      if count.to_i > 0
        given_count = [count.to_i, needed_count].min
        customer_amount -= given_count * denom
        denominations[denom] = operation == :add ?
                                 denominations[denom].to_i + given_count
                                 :
                                 denominations[denom].to_i - given_count
      end
    end
    denominations.transform_keys(&:to_s).merge("customer_amount": customer_amount)
  end
end
