require "test_helper"

describe OrderProductsController do
  describe "create" do
    it "creates an OrderProduct with a product and an order, creates a new order if no session[:cart] exists" do
      product_params = {
        product_id: products(:tricycle).id,
        quantity: 1
      }

      start_count = OrderProduct.count

      post create_order_product_path, params: product_params
      must_redirect_to order_path(session[:cart])

      OrderProduct.count.must_equal start_count + 1
    end

    # it "renders bad_request and does not update the DB for invalid merchant data" do
    #   invalid_merchant_data = {
    #     merchant: {
    #       username: "",
    #       email: ""
    #     }
    #   }
    #
    #   start_count = Merchant.count
    #
    #   post merchants_path, params: invalid_merchant_data
    #   must_respond_with :bad_request
    #
    #   Merchant.count.must_equal start_count
    # end
    #
    #
    # it "renders 400 bad_request for invalid email entries" do
    #   invalid_email = {
    #     merchant: {
    #       username: "namename",
    #       email: "name"
    #     }
    #   }
    #
    #   invalid_email_2 = {
    #     merchant: {
    #       username: "namename",
    #       email: "name@"
    #     }
    #   }
    #
    #   invalid_email_3 = {
    #     merchant: {
    #       username: "namename",
    #       email: "name@name."
    #     }
    #   }
    #
    #   start_count = Merchant.count
    #
    #   post merchants_path, params: invalid_email
    #   must_respond_with :bad_request
    #
    #   post merchants_path, params: invalid_email_2
    #   must_respond_with :bad_request
    #
    #   post merchants_path, params: invalid_email_3
    #   must_respond_with :bad_request
    #
    #   Merchant.count.must_equal start_count
    # end
  end
end
