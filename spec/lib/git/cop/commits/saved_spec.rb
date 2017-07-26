# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Commits::Saved, :git_repo do
  let(:sha) { Dir.chdir(git_repo_dir) { `git log --pretty=format:%H -1` } }
  subject { Dir.chdir(git_repo_dir) { described_class.new sha: sha } }

  before do
    Dir.chdir git_repo_dir do
      `touch test.md`
      `git add --all .`
      `git commit -m "Added test documentation." -m "- Necessary for testing purposes."`
    end
  end

  describe ".pattern" do
    it "answers pretty format pattern for all known formats" do
      expect(described_class.pattern).to eq(
        "<sha>%H</sha>%n" \
        "<author_name>%an</author_name>%n" \
        "<author_email>%ae</author_email>%n" \
        "<author_date_relative>%ar</author_date_relative>%n" \
        "<subject>%s</subject>%n" \
        "<body>%b</body>%n" \
        "<raw_body>%B</raw_body>%n"
      )
    end
  end

  describe "#initialize" do
    it "fails with SHA error for invalid SHA" do
      result = -> { described_class.new sha: "bogus" }

      expect(&result).to raise_error(
        Git::Cop::Errors::SHA,
        %(Invalid commit SHA: "bogus". Unable to obtain commit details.)
      )
    end

    it "fails with SHA error for unknown SHA" do
      result = -> { described_class.new sha: "abcdef123" }

      expect(&result).to raise_error(
        Git::Cop::Errors::SHA,
        %(Invalid commit SHA: "abcdef123". Unable to obtain commit details.)
      )
    end
  end

  describe "#==" do
    let(:sha_1) { `git log --pretty=format:%H -1` }
    let(:sha_2) { `git log --pretty=format:%H -1 @~` }
    let(:similar) { Dir.chdir(git_repo_dir) { described_class.new sha: sha_1 } }
    let(:different) { Dir.chdir(git_repo_dir) { described_class.new sha: sha_2 } }

    context "with same instances" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          expect(subject).to eq(subject)
        end
      end
    end

    context "with same values" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          expect(subject).to eq(similar)
        end
      end
    end

    context "with different values" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(subject).to_not eq(different)
        end
      end
    end

    context "with different type" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(subject).to_not eq("A string.")
        end
      end
    end
  end

  describe "#eql?" do
    let(:sha_1) { `git log --pretty=format:%H -1` }
    let(:sha_2) { `git log --pretty=format:%H -1 @~` }
    let(:similar) { Dir.chdir(git_repo_dir) { described_class.new sha: sha_1 } }
    let(:different) { Dir.chdir(git_repo_dir) { described_class.new sha: sha_2 } }

    context "with same instances" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          expect(subject).to eql(subject)
        end
      end
    end

    context "with same values" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          expect(subject).to eql(similar)
        end
      end
    end

    context "with different values" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(subject).to_not eql(different)
        end
      end
    end

    context "with different type" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(subject).to_not eql("A string.")
        end
      end
    end
  end

  describe "#equal?" do
    let(:sha_1) { `git log --pretty=format:%H -1` }
    let(:sha_2) { `git log --pretty=format:%H -1 @~` }
    let(:similar) { Dir.chdir(git_repo_dir) { described_class.new sha: sha_1 } }
    let(:different) { Dir.chdir(git_repo_dir) { described_class.new sha: sha_2 } }

    context "with same instances" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          expect(subject).to equal(subject)
        end
      end
    end

    context "with same values" do
      it "answers true" do
        Dir.chdir git_repo_dir do
          expect(subject).to_not equal(similar)
        end
      end
    end

    context "with different values" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(subject).to_not equal(different)
        end
      end
    end

    context "with different type" do
      it "answers false" do
        Dir.chdir git_repo_dir do
          expect(subject).to_not equal("A string.")
        end
      end
    end
  end

  describe "#hash" do
    let(:sha_1) { `git log --pretty=format:%H -1` }
    let(:sha_2) { `git log --pretty=format:%H -1 @~` }
    let(:similar) { Dir.chdir(git_repo_dir) { described_class.new sha: sha_1 } }
    let(:different) { Dir.chdir(git_repo_dir) { described_class.new sha: sha_2 } }

    context "with same instances" do
      it "is identical" do
        expect(subject.hash).to eq(subject.hash)
      end
    end

    context "with same values" do
      it "is identical" do
        expect(subject.hash).to eq(similar.hash)
      end
    end

    context "with different values" do
      it "is different" do
        expect(subject.hash).to_not eq(different.hash)
      end
    end

    context "with different type" do
      it "is different" do
        expect(subject.hash).to_not eq("not the same".hash)
      end
    end
  end

  describe "#sha" do
    it "answers SHA" do
      expect(subject.sha).to match(/[0-9a-f]{40}/)
    end
  end

  describe "#author_name" do
    it "answers author name" do
      expect(subject.author_name).to eq("Testy Tester")
    end
  end

  describe "#author_email" do
    it "answers author email" do
      expect(subject.author_email).to eq("tester@example.com")
    end
  end

  describe "#author_date_relative" do
    it "answers author date" do
      expect(subject.author_date_relative).to match(/\A\d{1}\ssecond.+ago\Z/)
    end
  end

  describe "#subject" do
    it "answers subject" do
      expect(subject.subject).to eq("Added test documentation.")
    end
  end

  describe "#body" do
    it "answers body with single line" do
      expect(subject.body).to eq("- Necessary for testing purposes.\n")
    end

    context "with multiple lines" do
      let :commit_message do
        "Added multi text file.\n\n" \
        "- Necessary for multi-line test.\n" \
        "- An extra bullet point.\n"
      end

      before do
        Dir.chdir git_repo_dir do
          `touch multi.txt`
          `git add --all .`
          `git commit --message $'#{commit_message}'`
        end
      end

      it "answers body with multiple lines" do
        body = "- Necessary for multi-line test.\n- An extra bullet point.\n"
        expect(subject.body).to eq(body)
      end
    end
  end

  describe "#body_lines" do
    before do
      Dir.chdir git_repo_dir do
        `touch test.txt`
        `git add --all .`
        `git commit --message $'#{commit_message}'`
      end
    end

    context "with body" do
      let :commit_message do
        "Added test file.\n\n" \
        "- First bullet.\n" \
        "- Second bullet.\n" \
        "- Third bullet.\n"
      end

      it "answers body lines" do
        Dir.chdir git_repo_dir do
          expect(subject.body_lines).to contain_exactly(
            "- First bullet.",
            "- Second bullet.",
            "- Third bullet."
          )
        end
      end
    end

    context "with commented lines" do
      let :commit_message do
        "Added test file.\n\n" \
        "- A bullet.\n" \
        "# A comment.\n" \
        "A body line.\n"
      end

      it "ignores commented lines" do
        Dir.chdir git_repo_dir do
          expect(subject.body_lines).to contain_exactly(
            "- A bullet.",
            "A body line."
          )
        end
      end
    end

    context "without body" do
      let(:commit_message) { "Added test file." }

      it "answers empty array" do
        Dir.chdir git_repo_dir do
          expect(subject.body_lines).to be_empty
        end
      end
    end
  end

  describe "#body_paragraphs" do
    before do
      Dir.chdir git_repo_dir do
        `touch test.txt`
        `git add --all .`
        `git commit --message $'#{commit_message}'`
      end
    end

    context "with body" do
      let :commit_message do
        "Added test.\n\n" \
        "The opening paragraph.\n" \
        "A bunch of words.\n\n" \
        "A bullet list:\n" \
        "- First bullet.\n" \
        "- Second bullet.\n\n"
      end

      it "answers body paragraphs" do
        Dir.chdir git_repo_dir do
          expect(subject.body_paragraphs).to contain_exactly(
            "The opening paragraph.\nA bunch of words.",
            "A bullet list:\n- First bullet.\n- Second bullet."
          )
        end
      end
    end

    context "with commented lines" do
      let :commit_message do
        "Added test.\n\n" \
        "A standard paragraph.\n\n" \
        "# A commented paragraph.\n\n" \
        "Another paragraph.\n\n"
      end

      it "ignores commented lines" do
        Dir.chdir git_repo_dir do
          expect(subject.body_paragraphs).to contain_exactly(
            "A standard paragraph.",
            "Another paragraph."
          )
        end
      end
    end

    context "without body" do
      let(:commit_message) { "Added test file." }

      it "answers empty array" do
        Dir.chdir git_repo_dir do
          expect(subject.body_paragraphs).to be_empty
        end
      end
    end
  end

  describe "#fixup?" do
    it_behaves_like "a fixup commit"
  end

  describe "#squash?" do
    it_behaves_like "a squash commit"
  end

  describe "#raw_body" do
    it "answers raw body" do
      content = "Added test documentation.\n\n- Necessary for testing purposes.\n"
      expect(subject.raw_body).to eq(content)
    end
  end

  describe "#respond_to?" do
    it "answers true for data methods" do
      described_class::FORMATS.keys.each do |key|
        expect(subject.respond_to?(key)).to eq(true)
      end
    end

    it "answers false for invalid methods" do
      expect(subject.respond_to?(:bogus)).to eq(false)
    end
  end
end
