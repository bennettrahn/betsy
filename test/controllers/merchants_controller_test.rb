require "test_helper"

describe MerchantsController do
  describe "index" do
    it "succeeds when there are merchants" do
      Merchant.count.must_be :>, 0, "No merchants in the test fixtures"
      get merchants_path
      must_respond_with :success
    end

    it "succeeds when there are no merchants" do
      Merchant.destroy_all
      get merchants_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "succeeds for an extant merchant ID" do
      get merchant_path(Merchant.first)
      must_respond_with :success
    end

    it "renders 404 not_found for a invalid merchant ID" do
      invalid_merchant_id = Merchant.last.id + 1
      get merchant_path(invalid_merchant_id)
      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "succeeds for an extant merchant ID" do
      get edit_merchant_path(Merchant.first)
      must_respond_with :success
    end

    it "renders 404 not_found for an invalid merchant ID" do
      invalid_merchant_id = Merchant.last.id + 1
      get edit_merchant_path(invalid_merchant_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "succeeds for valid data and an extant merchant ID" do
      merchant = Merchant.first
      merchant_data = {
        merchant: {
          username: merchant.username + "new",
          email: merchant.email
        }
      }

      patch merchant_path(merchant.id), params: merchant_data
      must_redirect_to merchant_path(merchant.id)

      # Verify the DB was really modified
      Merchant.find(merchant.id).username.must_equal merchant_data[:merchant][:username]
    end

    it "renders bad_request for invalid data" do
      merchant = Merchant.first
      merchant_data = {
        merchant: {
          username: "",
          email: merchant.email
        }
      }

      patch merchant_path(merchant), params: merchant_data
      must_respond_with :not_found

      # Verify the DB was not modified
      Merchant.find(merchant.id).username.must_equal merchant.username
    end

    it "renders 404 not_found for a invalid merchant ID" do
      invalid_merchant_id = Merchant.last.id + 1
      get merchant_path(invalid_merchant_id)
      must_respond_with :not_found
    end
  end
end
