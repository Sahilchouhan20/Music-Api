require 'rails_helper'

RSpec.describe ArtistsController, type: :controller do
  debugger

  let(:artist) {FactoryBot.create(:artist)}

  describe "GET #index" do
    it "returns a success response" do
      debugger
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
