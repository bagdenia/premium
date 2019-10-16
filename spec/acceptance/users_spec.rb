require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  get "/users" do
    example "Listing users" do
      do_request

      expect(status).to eq 200
    end
  end

  get "/users/:id" do
    parameter :id, "User ID"

    let(:user) { create(:user) }
    let(:id) { user.id }

    example "Get a user" do
      do_request

      expect(status).to eq 200
    end
  end
end
