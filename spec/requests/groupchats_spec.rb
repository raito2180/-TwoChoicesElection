require 'rails_helper'

RSpec.describe "Groupchats", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/groupchats/index"
      expect(response).to have_http_status(:success)
    end
  end

end
