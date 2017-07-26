# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitAuthorNameCapitalization do
  let(:name) { "Example Tester" }
  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "1", shell: shell), author_name: name
  end

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

  describe "#issue" do
    let(:issue) { subject.issue }

    context "when valid" do
      it "answers empty hash" do
        expect(issue).to eq({})
      end
    end

    context "when invalid" do
      let(:name) { "example" }

      it "answers issue label" do
        expect(issue[:label]).to eq(%(Invalid name: "example".))
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Capitalize each part of name.")
      end
    end
  end
end
