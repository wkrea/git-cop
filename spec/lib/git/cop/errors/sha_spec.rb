# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Errors::SHA do
  describe "#message" do
    subject { described_class.new "bogus" }

    it "answers default message" do
      expect(subject.message).to eq(
        %(Invalid commit SHA: "bogus". Unable to obtain commit details.)
      )
    end
  end
end
