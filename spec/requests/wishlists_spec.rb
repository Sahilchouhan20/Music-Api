require 'rails_helper'

RSpec.describe "Wishlists", type: :request do
  let(:user) { create(:user) }
  let!(:song) { create(:song) }  # This will now create a song with an artist
  let!(:wishlist) { create(:wishlist, user: user, song: song) }

  describe "GET /wishlists" do
    it "returns all wishlists" do
      get "/wishlists"
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['data'].length).to eq(1)
    end
  end

  describe "GET /wishlists/:id" do
    it "returns a specific wishlist" do
      get "/wishlists/#{wishlist.id}"
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['data']['id']).to eq(wishlist.id)
    end
  end

  describe "POST /wishlists" do
    let(:valid_attributes) { { song_id: song.id } }

    context "with valid parameters" do
      it "creates a new Wishlist" do
        expect {
          post "/wishlists", params: valid_attributes
        }.to change(Wishlist, :count).by(1)
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['message']).to eq('wishlist created')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Wishlist" do
        expect {
          post "/wishlists", params: { song_id: nil }
        }.to change(Wishlist, :count).by(0)
        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('wishlist not created')
      end
    end
  end

  describe "PATCH /wishlists/:id" do
    let(:new_song) { create(:song) }
    let(:new_attributes) { { song_id: new_song.id } }

    context "with valid parameters" do
      it "updates the requested wishlist" do
        patch "/wishlists/#{wishlist.id}", params: new_attributes
        wishlist.reload
        expect(wishlist.song_id).to eq(new_song.id)
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['message']).to eq('wishlist Update')
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the wishlist" do
        patch "/wishlists/#{wishlist.id}", params: { song_id: nil }
        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Wishlist Not Update')
      end
    end
  end

  describe "DELETE /wishlists/:id" do
    it "destroys the requested wishlist" do
      expect {
        delete "/wishlists/#{wishlist.id}"
      }.to change(Wishlist, :count).by(-1)
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['status']['message']).to eq('Wishlist Delete')
    end

    context "when wishlist can't be destroyed" do
      before do
        allow_any_instance_of(Wishlist).to receive(:destroy).and_return(false)
      end

      it "renders a JSON response with errors for the wishlist" do
        delete "/wishlists/#{wishlist.id}"
        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Wishlist Not Delete')
      end
    end
  end
end
