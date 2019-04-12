# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Branches::Environments::TravisCI do
  subject(:travis_ci) { described_class.new environment: environment, shell: shell }

  let(:environment) { {} }
  let(:shell) { class_spy Open3 }

  describe "#name" do
    context "with pull request branch" do
      let :environment do
        {
          "TRAVIS_PULL_REQUEST_BRANCH" => "pr_test",
          "TRAVIS_BRANCH" => "ci_test"
        }
      end

      it "answers pull request branch name" do
        expect(travis_ci.name).to eq("pr_test")
      end
    end

    context "without pull request branch and CI branch" do
      let :environment do
        {
          "TRAVIS_PULL_REQUEST_BRANCH" => "",
          "TRAVIS_BRANCH" => "ci_test"
        }
      end

      it "answers CI branch name" do
        expect(travis_ci.name).to eq("ci_test")
      end
    end
  end

  describe "#shas" do
    let(:commits_command) { %(git log --pretty=format:"%H" origin/master..test_name) }

    before do
      allow(shell).to receive(:capture2e).with("git remote set-branches --add origin master")
      allow(shell).to receive(:capture2e).with("git fetch")
      allow(shell).to receive(:capture2e).with(commits_command).and_return(["abc\ndef", true])
    end

    context "with pull request branch and without slug" do
      let :environment do
        {
          "TRAVIS_PULL_REQUEST_BRANCH" => "test_name",
          "TRAVIS_PULL_REQUEST_SLUG" => ""
        }
      end

      it "answers Git commit SHAs" do
        expect(travis_ci.shas).to contain_exactly("abc", "def")
      end
    end

    context "with pull request branch and slug" do
      let :environment do
        {
          "TRAVIS_PULL_REQUEST_BRANCH" => "test_name",
          "TRAVIS_PULL_REQUEST_SLUG" => "test_slug"
        }
      end

      it "answers Git commit SHAs" do
        remote_add_command = "git remote add -f original_branch https://github.com/test_slug.git"
        remote_fetch_command = "git fetch original_branch test_name:test_name"
        allow(shell).to receive(:capture2e).with(remote_add_command)
        allow(shell).to receive(:capture2e).with(remote_fetch_command)

        expect(travis_ci.shas).to contain_exactly("abc", "def")
      end
    end
  end
end
