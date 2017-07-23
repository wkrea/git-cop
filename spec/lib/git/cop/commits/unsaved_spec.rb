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
      expect(subject.raw_body).to eq(
        "Added example.\n" \
        "\n" \
        "An example paragraph.\n" \
        "\n" \
        "A bullet list:\n" \
        "  - One.\n" \
        "  - Two.\n" \
        "\n" \
        "Another paragraph.\n" \
        "\n" \
        "# A comment block.\n" \
        "# Pellentque morbi-trist sentus et netus et malesuada fames ac turpis.\n" \
      )
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
      expect(subject.subject).to eq("Added example.")
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
      expect(subject.body).to eq(
        "\n" \
        "An example paragraph.\n" \
        "\n" \
        "A bullet list:\n" \
        "  - One.\n" \
        "  - Two.\n" \
        "\n" \
        "Another paragraph.\n" \
        "\n" \
        "# A comment block.\n" \
        "# Pellentque morbi-trist sentus et netus et malesuada fames ac turpis.\n" \
      )
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
    it "answers body lines with comments ignored" do
      expect(subject.body_lines).to contain_exactly(
        "",
        "An example paragraph.",
        "",
        "A bullet list:",
        "  - One.",
        "  - Two.",
        "",
        "Another paragraph.",
        ""
      )
    end

    it "answers body line with no leading line after subject" do
      allow(subject).to receive(:raw_body).and_return("A test subject.\nA test body.\n")
      expect(subject.body_lines).to contain_exactly("A test body.")
    end

    it "answers empty array when raw body is a single line" do
      allow(subject).to receive(:raw_body).and_return("A test body.")
      expect(subject.body_lines).to eq([])
    end

    it "answers empty array when raw body is empty" do
      allow(subject).to receive(:raw_body).and_return("")
      expect(subject.body_lines).to eq([])
    end
  end

  describe "#body_paragraphs" do
    it "answers paragraphs with comments ignored" do
      expect(subject.body_paragraphs).to contain_exactly(
        "An example paragraph.",
        "A bullet list:\n  - One.\n  - Two.",
        "Another paragraph."
      )
    end

    it "answers empty array when raw body is single line" do
      allow(subject).to receive(:raw_body).and_return("A test body.")
      expect(subject.body_paragraphs).to eq([])
    end

    it "answers empty array when raw body is empty" do
      allow(subject).to receive(:raw_body).and_return("")
      expect(subject.body_paragraphs).to eq([])
    end
  end

  describe "#fixup?" do
    it_behaves_like "a fixup commit"
  end

  describe "#squash?" do
    it_behaves_like "a squash commit"
  end
end
