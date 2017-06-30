# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Errors::Base do
  describe "#message" do
    it "answers default message" do
      expect(subject.message).to eq("Invalid Git Cop action.")
    end
  end
end
