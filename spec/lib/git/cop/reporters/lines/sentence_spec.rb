# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Lines::Sentence do
  subject { described_class.new data }

  let(:data) { {number: 1, content: "Example content."} }

  describe "#to_s" do
    it "answers label and sentence" do
      expect(subject.to_s).to eq(%(    Line 1: "Example content."\n))
    end
  end
end
