# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subscriber, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      subscriber = Subscriber.new(
        email: "test@example.com",
        name: "John Doe",
        status: "active"
      )
      expect(subscriber).to be_valid
    end

    it "is valid without a name" do
      subscriber = Subscriber.new(
        email: "test@example.com",
        status: "active"
      )
      expect(subscriber).to be_valid
    end

    it "is not valid without an email" do
      subscriber = Subscriber.new(
        name: "John Doe",
        status: "active"
      )
      expect(subscriber).not_to be_valid
      expect(subscriber.errors[:email]).to include("can't be blank")
    end

    it "is not valid with an invalid email format" do
      subscriber = Subscriber.new(
        email: "invalid-email",
        name: "John Doe",
        status: "active"
      )
      expect(subscriber).not_to be_valid
      expect(subscriber.errors[:email]).to include("must be a valid email address")
    end

    it "is not valid with a duplicate email (case insensitive)" do
      Subscriber.create!(email: "test@example.com", name: "John Doe")
      subscriber = Subscriber.new(
        email: "TEST@EXAMPLE.COM",
        name: "Jane Doe"
      )
      expect(subscriber).not_to be_valid
      expect(subscriber.errors[:email]).to include("has already been taken")
    end

    it "is not valid with an invalid status" do
      subscriber = Subscriber.new(
        email: "test@example.com",
        name: "John Doe",
        status: "invalid_status"
      )
      expect(subscriber).not_to be_valid
      expect(subscriber.errors[:status]).to include("invalid_status is not a valid status")
    end
  end

  describe "callbacks" do
    it "normalizes email to lowercase and strips whitespace" do
      subscriber = Subscriber.create!(
        email: "  TEST@EXAMPLE.COM  ",
        name: "John Doe"
      )
      expect(subscriber.email).to eq("test@example.com")
    end

    it "sets default status to active if not provided" do
      subscriber = Subscriber.create!(
        email: "test@example.com",
        name: "John Doe"
      )
      expect(subscriber.status).to eq("active")
    end
  end

  describe "status values" do
    it "accepts 'active' status" do
      subscriber = Subscriber.new(
        email: "test@example.com",
        status: "active"
      )
      expect(subscriber).to be_valid
    end

    it "accepts 'inactive' status" do
      subscriber = Subscriber.new(
        email: "test@example.com",
        status: "inactive"
      )
      expect(subscriber).to be_valid
    end
  end
end 