# frozen_string_literal: true

require "rails_helper"

RSpec.describe SubscribersController, type: :controller do
  describe "GET /subscribers" do
    before do
      create_list(:subscriber, 3)
    end

    it "returns 200 and a list of subscribers and pagination object" do
      get :index, params: {}, format: :json

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:subscribers]).not_to be_nil
      expect(json[:pagination]).not_to be_nil
      expect(json[:subscribers].length).to eq(3)
    end

    it "supports pagination" do
      get :index, params: { page: 1, per_page: 2 }, format: :json

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:subscribers].length).to eq(2)
      expect(json[:pagination][:page]).to eq(1)
      expect(json[:pagination][:per_page]).to eq(2)
    end
  end

  describe "POST /subscribers" do
    it "returns 201 if it successfully creates a subscriber" do
      post :create, params: {
        email: "test@test.com", 
        name: "John Smith"
      }, format: :json

      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq "Subscriber created successfully"
      expect(json[:subscriber]).not_to be_nil
      expect(json[:subscriber][:email]).to eq("test@test.com")
    end

    it "returns 422 if email is invalid" do
      post :create, params: {
        email: "invalid-email", 
        name: "John Smith"
      }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq "Failed to create subscriber"
      expect(json[:errors]).to include("Email must be a valid email address")
    end

    it "returns 422 if email is missing" do
      post :create, params: {
        name: "John Smith"
      }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq "Failed to create subscriber"
      expect(json[:errors]).to include("Email can't be blank")
    end

    it "returns 422 if email is duplicate" do
      Subscriber.create!(email: "test@test.com", name: "John Smith")
      
      post :create, params: {
        email: "test@test.com", 
        name: "Jane Smith"
      }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq "Failed to create subscriber"
      expect(json[:errors]).to include("Email has already been taken")
    end
  end

  describe "PATCH /subscribers/:id" do
    let!(:subscriber) { Subscriber.create!(email: "test@test.com", name: "John Smith", status: "active") }

    it "returns 200 if it successfully updates a subscriber" do
      patch :update, params: {
        id: subscriber.id, 
        status: "inactive"
      }, format: :json

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq "Subscriber updated successfully"
      expect(json[:subscriber][:status]).to eq("inactive")
    end

    it "returns 404 if subscriber not found" do
      patch :update, params: {
        id: 999, 
        status: "inactive"
      }, format: :json

      expect(response).to have_http_status(:not_found)
      
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq "Subscriber not found"
    end

    it "returns 422 if status is invalid" do
      patch :update, params: {
        id: subscriber.id, 
        status: "invalid_status"
      }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq "Failed to update subscriber"
      expect(json[:errors]).to include("Status invalid_status is not a valid status")
    end
  end
end
