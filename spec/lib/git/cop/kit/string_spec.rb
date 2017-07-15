# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Kit::String do
  describe ".pluralize" do
    context "with default suffix" do
      it "pluralizes zero count" do
        expect(described_class.pluralize("issue", count: 0)).to eq("0 issues")
      end

      it "pluralizes count greater than one" do
        expect(described_class.pluralize("issue", count: 2)).to eq("2 issues")
      end

      it "does not pluralize count of one" do
        expect(described_class.pluralize("issue", count: 1)).to eq("1 issue")
      end
    end

    context "with custom suffix" do
      it "pluralizes zero count" do
        expect(described_class.pluralize("branch", count: 0, suffix: "es")).to eq("0 branches")
      end

      it "pluralizes count greater than one" do
        expect(described_class.pluralize("branch", count: 2, suffix: "es")).to eq("2 branches")
      end

      it "does not pluralize one count" do
        expect(described_class.pluralize("branch", count: 1)).to eq("1 branch")
      end
    end
  end

  describe "#fixup?" do
    it "answers true when fixup! prefix is included" do
      expect(described_class.fixup?("fixup! Added test file.")).to eq(true)
    end

    it "answers false when fixup! prefix is excluded" do
      expect(described_class.fixup?("Added test file.")).to eq(false)
    end

    it "answers false when fixup! prefix is missing trailing space" do
      expect(described_class.fixup?("fixup!Added test file.")).to eq(false)
    end

    it "answers false when fixup! is not a prefix" do
      expect(described_class.fixup?(" fixup! Added test file.")).to eq(false)
    end
  end

  describe "#squash?" do
    it "answers true when squash! prefix is included" do
      expect(described_class.squash?("squash! Added test file.")).to eq(true)
    end

    it "answers false when squash! prefix is excluded" do
      expect(described_class.squash?("Added test file.")).to eq(false)
    end

    it "answers false when squash! prefix is missing trailing space" do
      expect(described_class.squash?("squash!Added test file.")).to eq(false)
    end

    it "answers false when squash! is not a prefix" do
      expect(described_class.squash?(" squash! Added test file.")).to eq(false)
    end
  end
end
