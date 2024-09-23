require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end
  describe "association" do
    it { should have_many(:songs)}
  end
end
