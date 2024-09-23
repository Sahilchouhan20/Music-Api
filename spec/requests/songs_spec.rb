require 'rails_helper'

RSpec.describe "Songs", type: :request do
  let(:artist) { create(:artist) }
  let!(:song) { FactoryBot.create(:song, artist: artist) }

  describe "GET /songs" do
    it "returns all songs" do
      get "/songs"
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['data'].length).to eq(1)
    end
  end

  describe "GET /songs/:id" do
    it "returns a specific song" do
      get "/songs/#{song.id}"
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['data']['id']).to eq(song.id)
    end
  end

  describe "POST /songs" do
    let(:valid_attributes) { { name: "New Song", artist_id: artist.id } }
    let(:invalid_attributes) { { name: nil, artist_id: artist.id } }

    context "with valid parameters" do
      it "creates a new Song" do
        expect {
          post "/songs", params: valid_attributes
        }.to change(Song, :count).by(1)
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['message']).to eq('Song created successfully')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Song" do
        expect {
          post "/songs", params: invalid_attributes
        }.to change(Song, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Song not created')
      end
    end
  end

  describe "PATCH /songs/:id" do
    let(:new_attributes) { { name: "Updated Song" } }

    context "with valid parameters" do
      it "updates the requested song" do
        patch "/songs/#{song.id}", params: new_attributes
        song.reload
        expect(song.name).to eq("Updated Song")
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['message']).to eq('Song Changed')
      end
    end

    context "with invalid parameters" do
      it "does not update the song" do
        patch "/songs/#{song.id}", params: { name: nil }
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Song Not Update')
      end
    end
  end

  describe "DELETE /songs/:id" do
    it "destroys the requested song" do
      expect {
        delete "/songs/#{song.id}"
      }.to change(Song, :count).by(-1)
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['status']['message']).to eq('Song Delete')
    end

    context "when song can't be destroyed" do
      it "returns an error message" do
        allow_any_instance_of(Song).to receive(:destroy).and_return(false)
        delete "/songs/#{song.id}"
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Song Not Delete')
      end
    end
  end
end
