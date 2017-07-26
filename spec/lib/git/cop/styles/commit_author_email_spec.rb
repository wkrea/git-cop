# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitAuthorEmail do
  let(:email) { "test@example.com" }
  let(:status) { double "status", success?: true }
  let(:shell) { class_spy Open3, capture2e: ["", status] }

  let :commit do
    object_double Git::Cop::Commits::Saved.new(sha: "abc", shell: shell), author_email: email
  end

  subject { described_class.new commit: commit }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_author_email)
    end
  end

  describe ".label" do
    it "answers class label" do
      expect(described_class.label).to eq("Commit Author Email")
    end
  end

  describe "#valid?" do
    context "with valid email" do
      let(:email) { "a@b.c" }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with subdomain" do
      let(:email) { "test@test.example.com" }

      it "answers true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with missing '@' symbol" do
      let(:email) { "example.com" }

      it "answers false" do
        expect(subject.valid?).to eq(false)
      end
    end

    context "with missing domain" do
      let(:email) { "test@examplecom" }

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
      let(:email) { "bogus" }

      it "answers issue label" do
        expect(issue[:label]).to eq(%(Invalid email: "bogus".))
      end

      it "answers issue hint" do
        expect(issue[:hint]).to eq("Use format: <name>@<server>.<domain>.")
      end
    end
  end
end
