# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::CLI do
  let(:options) { [] }
  let(:command_line) { Array(command).concat options }
  let(:cli) { described_class.start command_line }

  shared_examples_for "a config command", :temp_dir do
    context "with no options" do
      it "prints help text" do
        result = -> { cli }
        expect(&result).to output(/Manage gem configuration./).to_stdout
      end
    end
  end

  shared_examples_for "a police command", :git_repo do
    context "with issues" do
      before do
        Dir.chdir git_repo_dir do
          `git checkout -b test`
          `printf "%s\n" "Test content." > one.txt`
          `git add --all .`
          `git commit --no-verify --message "Made a test commit"`
        end
      end

      it "aborts with total number of issues" do
        Dir.chdir git_repo_dir do
          result = -> { cli }
          expect(&result).to raise_error(SystemExit, "2 issues detected.")
        end
      end
    end

    context "with no issues" do
      it "prints no issues detected" do
        Dir.chdir git_repo_dir do
          result = -> { cli }
          expect(&result).to output("Running Git Cop...\n\nNo issues detected.\n").to_stdout
        end
      end
    end
  end

  shared_examples_for "a version command" do
    it "prints version" do
      result = -> { cli }
      expect(&result).to output(/#{Git::Cop::Identity.version_label}\n/).to_stdout
    end
  end

  shared_examples_for "a help command" do
    it "prints usage" do
      result = -> { cli }
      expect(&result).to output(/#{Git::Cop::Identity.version_label}\scommands:\n/).to_stdout
    end
  end

  describe "--config" do
    let(:command) { "--config" }
    it_behaves_like "a config command"
  end

  describe "-c" do
    let(:command) { "-c" }
    it_behaves_like "a config command"
  end

  describe "--police" do
    let(:command) { "--police" }
    it_behaves_like "a police command"
  end

  describe "-p" do
    let(:command) { "-p" }
    it_behaves_like "a police command"
  end

  describe "--version" do
    let(:command) { "--version" }
    it_behaves_like "a version command"
  end

  describe "-v" do
    let(:command) { "-v" }
    it_behaves_like "a version command"
  end

  describe "--help" do
    let(:command) { "--help" }
    it_behaves_like "a help command"
  end

  describe "-h" do
    let(:command) { "-h" }
    it_behaves_like "a help command"
  end

  context "with no command" do
    let(:command) { nil }
    it_behaves_like "a help command"
  end
end
