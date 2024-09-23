require 'rails_helper'

RSpec.describe Song, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end
  describe "association" do
    it { should have_many(:wishlists)}
  end
end
