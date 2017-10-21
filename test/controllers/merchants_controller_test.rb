require "test_helper"

describe MerchantsController do
  describe "for logged in merchant" do
    before do
      @merchant = merchants(:anders)
      login(@merchant)
    end

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
      it "succeeds for a logged in merchant's own page" do
        get merchant_path(@merchant)
        must_respond_with :success
      end

      # commented below test out, because everyone should be able to see all merchant show pages
      # it "only shows merchant their own page" do
      #   get merchant_path(merchants(:lauren))
      #   must_redirect_to merchants_path
      #   flash[:message].must_equal "You can only see your own details"
      # end

      it "renders 404 not_found for a invalid merchant ID" do
        invalid_merchant_id = Merchant.last.id + 1
        get merchant_path(invalid_merchant_id)
        must_respond_with :not_found
      end

      it "returns a success status for a different merchant's page" do
        merchant = merchants(:bennett)
        get merchant_path(merchant)
        must_respond_with :success
      end
    end

    describe "edit" do
      it "succeeds if the merchant is logged in" do
        get edit_merchant_path(@merchant)
        must_respond_with :success
      end

      it "renders 404 not_found for an invalid merchant ID" do
        invalid_merchant_id = Merchant.last.id + 1
        get edit_merchant_path(invalid_merchant_id)
        must_respond_with :not_found
      end

      it "sets flash[:status] to failure and redirects to products_path when logged in merchant tries to edit a different merchant's information" do
        merchant = merchants(:bennett)
        get edit_merchant_path(merchant.id)
        flash[:status].must_equal :failure
        must_redirect_to root_path
      end
    end

    describe "update" do
      it "succeeds for valid data and if merchant is logged in" do
        merchant_data = {
          merchant: {
            username: "new name",
            email: @merchant.email
          }
        }

        patch merchant_path(@merchant.id), params: merchant_data
        must_redirect_to merchant_path(@merchant.id)

        # Verify the DB was really modified
        Merchant.find(@merchant.id).username.must_equal merchant_data[:merchant][:username]
      end

      it "renders bad_request for invalid data" do
        merchant_data = {
          merchant: {
            username: "",
            email: @merchant.email
          }
        }

        patch merchant_path(@merchant.id), params: merchant_data
        must_respond_with :not_found

        # Verify the DB was not modified
        Merchant.find(@merchant.id).username.must_equal @merchant.username
      end

      it "renders 404 not_found for a invalid merchant ID" do
        invalid_merchant_id = Merchant.last.id + 1
        get merchant_path(invalid_merchant_id)
        must_respond_with :not_found
      end

      it "sets flash[:status] to failure, and redirects to root_path if logged in merchants tries to update information of another merchant" do
        merchant = merchants(:bennett)
        merchant_username = merchant.username
        merchant_data = {
          merchant: {
            username: "new name",
            email: merchant.email
          }
        }

        patch merchant_path(merchant.id), params: merchant_data
        flash[:status].must_equal :failure
        must_redirect_to root_path

        # Verify the DB was not changed
        Merchant.find(merchant.id).username.must_equal merchant_username
      end
    end

    describe "destroy" do
      it "succeeds for a logged in merchant who is deleting their own account" do
        delete merchant_path(@merchant.id)
        must_redirect_to merchants_path

        # The work should really be gone
        Merchant.find_by(id: @merchant.id).must_be_nil
      end

      it "renders 404 not_found and does not update the DB for a bogus work ID" do
        start_count = Merchant.count

        bogus_work_id = Merchant.last.id + 1
        delete merchant_path(bogus_work_id)
        must_respond_with :not_found

        Merchant.count.must_equal start_count
      end

      it "sets flash[:status] to failiure and redirects to root_path if a logged in merchant is trying to delete another merchant's account" do
        other_merchant = merchants(:bennett)

        delete merchant_path(other_merchant.id)
        flash[:status].must_equal :failure
        must_redirect_to root_path
      end
    end
  end

  describe "non logged in user" do
    describe "index" do
      it "returns success for a non-logged in user" do
        get merchants_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "returns success for a non-logged in user" do
        get merchant_path(merchants(:anders))
        must_respond_with :success
      end
    end

    #this test is failing -- how to pass session[:merchant_id] as nil?
    describe "edit" do
      it "edit fails for a non-logged in user" do
        get edit_merchant_path(merchants(:bennett))
        flash[:status].must_equal :failure
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end

    describe "update" do
      it "update fails for a non-logged in user and redirects to products path" do
        merchant = merchants(:bennett)
        # merchant_username = merchant.username
        merchant_data = {
          merchant: {
            username: "new name",
            email: merchant.email
          }
        }
        patch merchant_path(merchant.id), params: merchant_data
        flash[:status].must_equal :failure
        must_redirect_to products_path
      end
    end

    describe "destroy" do
      it "destroy fails for a non-logged in user" do
        merchant = merchants(:bennett)
        delete merchant_path(merchant.id)
        must_redirect_to products_path
        flash[:status].must_equal :failure
      end
    end
  end

  describe "create and login with auth_callback" do
    it "logs in an existing user and redirects to the products route" do
      # Count the merchants, to make sure we're not (for example) creating
      # a new merchant every time we get a login request
      start_count = Merchant.count

      # Get a merchant from the fixtures
      merchant = merchants(:anders)

      # Tell OmniAuth to use this merchant's info when it sees
      # an auth callback from github
      login(merchant)
      # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))

      # Send a login request for that merchant
      # Note that we're using the named path for the callback, as defined
      # in the `as:` clause in `config/routes.rb`
      # get auth_callback_path(:github)

      must_redirect_to products_path

      # Since we can read the session, check that the user ID was set as expected
      session[:merchant_id].must_equal merchant.id

      # Should *not* have created a new user
      Merchant.count.must_equal start_count
    end

    it "creates an account for a new merchant and redirects to the products route" do
      start_count = Merchant.count

      merchant = Merchant.new(provider: "github", uid: 123124564, username: "test_merchant", email: "test@merchant.com", name: "trio")

      login(merchant)

      must_redirect_to products_path
      flash[:status].must_equal :success

      # Should have created a new user
      Merchant.count.must_equal start_count + 1

      # The new user's ID should be set in the session
      merchant_id = Merchant.find_by(username: merchant[:username]).id
      session[:merchant_id].must_equal merchant_id
    end

    it "redirects to the products route if given invalid user data" do
      invalid_merchant = Merchant.first
      invalid_merchant.uid = ""

      login(invalid_merchant)

      must_redirect_to products_path
      flash[:status].must_equal :success
    end
  end

  describe "logout" do
    it "succeeds, redirects to products_path, sets flash[:status] to success and session[:merchant_id], [:cart] to nil" do
      get logout_path
      must_respond_with :redirect
      must_redirect_to products_path
      flash[:status].must_equal :success
      session[:merchant_id].must_equal nil
      session[:cart].must_equal nil
    end
  end

  describe "new" do
    it "works" do
      get new_merchant_path
      must_respond_with :success
    end
  end
end



  # describe "create" do
  #   it "creates a merchant with valid data" do
  #     merchant_data = {
  #       merchant: {
  #         username: "test test",
  #         email: "test@test.com"
  #       }
  #     }
  #
  #     start_count = Merchant.count
  #
  #     post merchants_path, params: merchant_data
  #     must_redirect_to merchant_path(Merchant.last)
  #
  #     Merchant.count.must_equal start_count + 1
  #   end
  #
  #   it "renders bad_request and does not update the DB for invalid merchant data" do
  #     invalid_merchant_data = {
  #       merchant: {
  #         username: "",
  #         email: ""
  #       }
  #     }
  #
  #     start_count = Merchant.count
  #
  #     post merchants_path, params: invalid_merchant_data
  #     must_respond_with :bad_request
  #
  #     Merchant.count.must_equal start_count
  #   end
  #
  #
  #   it "renders 400 bad_request for invalid email entries" do
  #     invalid_email = {
  #       merchant: {
  #         username: "namename",
  #         email: "name"
  #       }
  #     }
  #
  #     invalid_email_2 = {
  #       merchant: {
  #         username: "namename",
  #         email: "name@"
  #       }
  #     }
  #
  #     invalid_email_3 = {
  #       merchant: {
  #         username: "namename",
  #         email: "name@name."
  #       }
  #     }
  #
  #     start_count = Merchant.count
  #
  #     post merchants_path, params: invalid_email
  #     must_respond_with :bad_request
  #
  #     post merchants_path, params: invalid_email_2
  #     must_respond_with :bad_request
  #
  #     post merchants_path, params: invalid_email_3
  #     must_respond_with :bad_request
  #
  #     Merchant.count.must_equal start_count
  #   end
