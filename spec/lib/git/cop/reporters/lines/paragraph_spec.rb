# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Lines::Paragraph do
  let(:data) { {number: 1, content: "One.\nTwo.\nThree."} }
  subject { described_class.new data }

  describe "#to_s" do
    it "answers label and paragraph" do
      expect(subject.to_s).to eq(
        %(    Line 1: "One.\n) +
        %(             Two.\n) +
        %(             Three."\n)
      )
    end
  end
end
