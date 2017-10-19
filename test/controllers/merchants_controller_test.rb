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

  describe "new" do
    it "works" do
      get new_merchant_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "creates a merchant with valid data" do
      merchant_data = {
        merchant: {
          username: "test test",
          email: "test@test.com"
        }
      }

      start_count = Merchant.count

      post merchants_path, params: merchant_data
      must_redirect_to merchant_path(Merchant.last)

      Merchant.count.must_equal start_count + 1
    end

    it "renders bad_request and does not update the DB for invalid merchant data" do
      invalid_merchant_data = {
        merchant: {
          username: "",
          email: ""
        }
      }

      start_count = Merchant.count

      post merchants_path, params: invalid_merchant_data
      must_respond_with :bad_request

      Merchant.count.must_equal start_count
    end


    it "renders 400 bad_request for invalid email entries" do
      invalid_email = {
        merchant: {
          username: "namename",
          email: "name"
        }
      }

      invalid_email_2 = {
        merchant: {
          username: "namename",
          email: "name@"
        }
      }

      invalid_email_3 = {
        merchant: {
          username: "namename",
          email: "name@name."
        }
      }

      start_count = Merchant.count

      post merchants_path, params: invalid_email
      must_respond_with :bad_request

      post merchants_path, params: invalid_email_2
      must_respond_with :bad_request

      post merchants_path, params: invalid_email_3
      must_respond_with :bad_request

      Merchant.count.must_equal start_count
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

  describe "destroy" do
    it "succeeds for an extant work ID" do
      merchant_id = Merchant.first.id

      delete merchant_path(merchant_id)
      must_redirect_to merchants_path

      # The work should really be gone
      Merchant.find_by(id: merchant_id).must_be_nil
    end

    it "renders 404 not_found and does not update the DB for a bogus work ID" do
      start_count = Merchant.count

      bogus_work_id = Merchant.last.id + 1
      delete merchant_path(bogus_work_id)
      must_respond_with :not_found

      Merchant.count.must_equal start_count
    end
  end
end