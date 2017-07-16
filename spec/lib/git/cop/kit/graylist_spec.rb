# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Kit::Graylist do
  subject { described_class.new %w[one two three] }

  describe "#to_quote" do
    it "answers array of quoted strings" do
      expect(subject.to_quote).to contain_exactly(%("one"), %("two"), %("three"))
    end
  end

  describe "#to_regex" do
    it "answers array of regular expressions" do
      expect(subject.to_regex).to contain_exactly(/one/, /two/, /three/)
    end
  end

  describe "#to_hint" do
    it "answers graylist as a string" do
      subject = described_class.new ["one", "\\.", "three"]
      expect(subject.to_hint).to eq(%("one", ".", "three"))
    end
  end

  describe "#empty?" do
    it "answers true when empty" do
      expect(described_class.new.empty?).to eq(true)
    end

    it "answers false when not empty" do
      expect(subject.empty?).to eq(false)
    end
  end
end
