# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Errors::Severity do
  describe "#message" do
    subject { described_class.new level: :bogus }

    it "answers default message" do
      expect(subject.message).to eq("Invalid severity level: bogus. Use: warn, error.")
    end
  end
end
