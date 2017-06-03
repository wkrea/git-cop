# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Styles::CommitAuthorEmail do
  let(:email) { "test@example.com" }
  let(:commit) { object_double Git::Cop::Commit.new(sha: "1"), author_email: email }
  subject { described_class.new commit: commit }

  describe ".id" do
    it "answers class ID" do
      expect(described_class.id).to eq(:commit_author_email)
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

  describe "#error" do
    context "when valid" do
      it "answers empty string" do
        expect(subject.error).to eq("")
      end
    end

    context "when invalid" do
      let(:email) { "bogus" }

      it "answers error message" do
        expect(subject.error).to match(/Invalid\semail\:\s\"bogus\"\..+/)
      end
    end
  end
end
