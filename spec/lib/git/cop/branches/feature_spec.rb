# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Branches::Feature do
  describe ".environment" do
    it "answers local environment" do
      ClimateControl.modify CIRCLECI: "false", TRAVIS: "false" do
        expect(described_class.environment).to be_a(Git::Cop::Branches::Environments::Local)
      end
    end

    it "answers Circle CI environment" do
      ClimateControl.modify CIRCLECI: "true", TRAVIS: "false" do
        expect(described_class.environment).to be_a(Git::Cop::Branches::Environments::CircleCI)
      end
    end

    it "answers Travis CI environment" do
      ClimateControl.modify CIRCLECI: "false", TRAVIS: "true" do
        expect(described_class.environment).to be_a(Git::Cop::Branches::Environments::TravisCI)
      end
    end
  end

  describe ".initialize", :temp_dir do
    let(:git_repo) { class_spy Git::Kit::Repo, exist?: exist }

    context "when Git repository exists" do
      let(:exist) { true }

      it "does not fail with error" do
        result = -> { described_class.new git_repo: git_repo }
        expect(&result).to_not raise_error
      end
    end

    context "when Git repository doesn't exist" do
      let(:exist) { false }

      it "fails with base error" do
        result = -> { described_class.new git_repo: git_repo }
        expect(&result).to raise_error(
          Git::Cop::Errors::Base,
          "Invalid repository. Are you within a Git-enabled project?"
        )
      end
    end
  end

  describe "#name" do
    context "with local environment", :git_repo do
      before do
        Dir.chdir git_repo_dir do
          `git checkout -b test`
        end
      end

      it "answers name" do
        Dir.chdir git_repo_dir do
          expect(subject.name).to eq("test")
        end
      end
    end
  end

  describe "#shas" do
    context "with local environment", :git_repo do
      before do
        Dir.chdir git_repo_dir do
          `git checkout -b test`
          `touch test.txt`
          `git add --all .`
          `git commit --message "Added test file."`
        end
      end

      it "answers SHA strings" do
        Dir.chdir git_repo_dir do
          expect(subject.shas).to all(match(/[0-9a-f]{40}/))
        end
      end

      it "answers SHA count" do
        Dir.chdir git_repo_dir do
          expect(subject.shas.count).to eq(1)
        end
      end
    end
  end

  describe "#commits" do
    context "with local environment", :git_repo do
      before do
        Dir.chdir git_repo_dir do
          `git checkout -b test`
          `touch test.txt`
          `git add --all .`
          `git commit --message "Added test file."`
        end
      end

      it "answers saved commits" do
        Dir.chdir git_repo_dir do
          expect(subject.commits).to all(be_a(Git::Cop::Commits::Saved))
        end
      end

      it "answers commit count" do
        Dir.chdir git_repo_dir do
          expect(subject.commits.count).to eq(1)
        end
      end
    end
  end
end
