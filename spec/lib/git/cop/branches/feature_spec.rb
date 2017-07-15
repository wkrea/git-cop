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
    it "fails with base error without valid Git repository" do
      Dir.chdir temp_dir do
        result = -> { described_class.new }
        expect(&result).to raise_error(Git::Cop::Errors::Base, "Invalid Git repository.")
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
