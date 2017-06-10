# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitAuthorNameCapitalization do
  let(:name) { "Example Tester" }
  let(:commit) { object_double Git::Cop::Commit.new(sha: "1"), author_name: name }
  let(:minimum) { 2 }
  let(:settings) { {enabled: true, minimum: minimum} }
  subject { described_class.new commit: commit, settings: settings }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_author_name_capitalization)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Author Name Capitalization")
    end
  end

  describe "#valid?" do
    context "with single name, capitalized" do
      let(:name) { "Example" }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with single name, uncapitalized" do
      let(:name) { "example" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with single letter, capitalized" do
      let(:name) { "E" }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with single letter, uncapitalized" do
      let(:name) { "e" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with multiple parts, all capitalized" do
      let(:name) { "Example Tester" }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with multiple parts, mixed capitalized" do
      let(:name) { "Example tester" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe "#error" do
    context "when valid" do
      it "answers empty string" do
        expect(subject.error).to eq("")
      end
    end

    context "when invalid" do
      let(:name) { "example" }

      it "answers error message" do
        message = %(Invalid name: "example". Capitalize each part of name.)
        expect(subject.error).to eq(message)
      end
    end
  end
end
