# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Lines::Sentence do
  let(:data) { {number: 1, content: "Example content."} }
  subject { described_class.new data }

  describe "#to_s" do
    it "answers label and sentence" do
      expect(subject.to_s).to eq(%(    Line 1: "Example content."\n))
    end
  end
end
