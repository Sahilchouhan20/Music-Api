require 'rails_helper'

RSpec.describe "Artists", type: :request do
  let(:valid_attributes) { { name: "Jane Doe"} }
  let(:invalid_attributes) { { name: ""} }

  describe "GET /artists" do
    context "when artists are present" do
      let!(:artists) { FactoryBot.create_list(:artist, 3) }

      it "returns a success response with artists" do
        get "/artists"

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /artist" do
      # let(:artists) { FactoryBot.create(:artist) }

      it "returns a success response with artists" do
        @artist = Artist.create(name: "Jhon")
        get "/artists/#{@artist.id}"

        expect(response).to have_http_status(:ok)
      end
  end

  describe "POST /artists" do
    context "with valid parameters" do
      it "creates a new Artist" do
        expect {
          post "/artists", params: { artist: valid_attributes }
        }.to change(Artist, :count).by(1)
      end

      it "renders a JSON response with the new artist" do
        post "/artists", params: { artist: valid_attributes }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Artist Created Succesfully')
        expect(json_response['status']['data']['name']).to eq('John Doe')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Artist and returns unprocessable entity status" do
        expect {
          post "/artists", params: { artist: invalid_attributes }
        }.not_to change(Artist, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Couldn't find record")
      end
    end
  end

  describe "PATCH /artists/:id" do
    let!(:artist) { Artist.create! valid_attributes }

    context "with valid parameters" do
      let(:new_attributes) { { name: "Jane Doe" } }

      it "updates the requested artist" do
        patch "/artists/#{artist.id}", params: { artist: new_attributes }
        artist.reload
        expect(artist.name).to eq("Jane Doe")
      end

      it "renders a JSON response with the artist" do
        patch "/artists/#{artist.id}", params: { artist: new_attributes }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Artists Update')
        expect(json_response['status']['data']['name']).to eq('Jane Doe')
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the artist" do
        patch "/artists/#{artist.id}", params: { artist: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Artists Not Update')
      end
    end
  end

  describe "DELETE /artists/:id" do
    let!(:artist) { Artist.create! valid_attributes }

    context "when delete is successful" do
      it "destroys the requested artist" do
        expect {
          delete "/artists/#{artist.id}"
        }.to change(Artist, :count).by(-1)
      end

      it "renders a JSON response with a success message" do
        delete "/artists/#{artist.id}"
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']['code']).to eq(200)
        expect(json_response['status']['message']).to eq('Artist Delete Succesfully')
      end
    end

    context "when delete fails" do
      before do
        allow_any_instance_of(Artist).to receive(:destroy).and_return(false)
      end

      it "renders a JSON response with an error message" do
        delete "/artists/#{artist.id}"
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Not Delete')
      end
    end
  end
end
