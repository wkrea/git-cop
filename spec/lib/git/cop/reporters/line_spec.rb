# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Line do
  let(:line) { {number: 1, content: "Example content."} }
  subject { described_class.new line }

  describe "#to_s" do
    it "answers line number and content" do
      expect(subject.to_s).to eq("    Line 1: Example content.\n")
    end
  end
end
