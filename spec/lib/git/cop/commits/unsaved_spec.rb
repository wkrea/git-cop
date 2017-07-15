# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Commits::Unsaved, :git_repo do
  let(:path) { "#{Bundler.root}/spec/support/fixtures/commit-valid.txt" }
  subject { described_class.new path: path }

  describe "#initialize" do
    it "raises base error for invalid path" do
      result = -> { described_class.new path: "/bogus/path" }

      expect(&result).to raise_error(
        Git::Cop::Errors::Base,
        %(Invalid commit message path: "/bogus/path".)
      )
    end
  end

  describe "#raw_body" do
    it "answers file contents" do
      contents = "Added test file.\n\n- This is a test file.\n- This is a valid commit example.\n"
      expect(subject.raw_body).to eq(contents)
    end
  end

  describe "#sha" do
    it "answers random SHA" do
      expect(subject.sha).to match(/[0-9a-f]{40}/)
    end
  end

  describe "#author_name" do
    it "answers name" do
      Dir.chdir git_repo_dir do
        expect(subject.author_name).to eq("Testy Tester")
      end
    end
  end

  describe "#author_email" do
    it "answers email address" do
      Dir.chdir git_repo_dir do
        expect(subject.author_email).to eq("tester@example.com")
      end
    end
  end

  describe "#author_date_relative" do
    it "answers zero seconds" do
      expect(subject.author_date_relative).to eq("0 seconds ago")
    end
  end

  describe "#subject" do
    it "answers subject from file" do
      expect(subject.subject).to eq("Added test file.")
    end

    it "answers raw body when raw body is a single line" do
      allow(subject).to receive(:raw_body).and_return("A test body.")
      expect(subject.subject).to eq("A test body.")
    end

    it "answers empty string when raw body is empty" do
      allow(subject).to receive(:raw_body).and_return("")
      expect(subject.subject).to eq("")
    end
  end

  describe "#body" do
    it "answers body from file" do
      expect(subject.body).to eq("\n- This is a test file.\n- This is a valid commit example.\n")
    end

    it "answers empty string when raw body is a single line" do
      allow(subject).to receive(:raw_body).and_return("A test body.")
      expect(subject.body).to eq("")
    end

    it "answers body when raw body has multiple lines" do
      allow(subject).to receive(:raw_body).and_return("A test subject.\nA test body.\n")
      expect(subject.body).to eq("A test body.\n")
    end

    it "answers empty string when raw body is empty" do
      allow(subject).to receive(:raw_body).and_return("")
      expect(subject.body).to eq("")
    end
  end

  describe "#body_lines" do
    it "answers lines" do
      expect(subject.body_lines).to contain_exactly(
        "",
        "- This is a test file.",
        "- This is a valid commit example."
      )
    end

    it "ignores commented lines" do
      allow(subject).to receive(:body).and_return("Line A.\n# Comment line.\nLine B.\n")

      expect(subject.body_lines).to contain_exactly(
        "Line A.",
        "Line B."
      )
    end

    it "answers empty array when raw body is a single line" do
      allow(subject).to receive(:raw_body).and_return("A test body.")
      expect(subject.body_lines).to eq([])
    end

    it "answers line when raw body has multiple lines" do
      allow(subject).to receive(:raw_body).and_return("A test subject.\nA test body.\n")
      expect(subject.body_lines).to contain_exactly("A test body.")
    end

    it "answers empty array when raw body is empty" do
      allow(subject).to receive(:raw_body).and_return("")
      expect(subject.body_lines).to eq([])
    end
  end

  describe "#fixup?" do
    it_behaves_like "a fixup commit"
  end

  describe "#squash?" do
    it_behaves_like "a squash commit"
  end
end
