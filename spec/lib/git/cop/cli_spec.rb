# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::CLI do
  let(:options) { [] }
  let(:command_line) { Array(command).concat options }
  let :cli do
    lambda do
      load "git/cop/cli.rb" # Ensures clean Thor `.method_option` evaluation per spec.
      described_class.start command_line
    end
  end

  shared_examples_for "a config command", :temp_dir do
    let(:configuration_path) { described_class.configuration.path }

    context "with info option" do
      let(:options) { %w[-i] }

      it "prints configuration path" do
        Dir.chdir(temp_dir) do
          expect(&cli).to output("#{configuration_path}\n").to_stdout
        end
      end
    end

    context "with no options" do
      it "prints help text" do
        expect(&cli).to output(/Manage gem configuration./).to_stdout
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
          expect(&cli).to raise_error(SystemExit, "2 issues detected.")
        end
      end
    end

    context "with no issues" do
      it "prints no issues detected" do
        Dir.chdir git_repo_dir do
          expect(&cli).to output("Running Git Cop...\n\nNo issues detected.\n").to_stdout
        end
      end
    end
  end

  shared_examples_for "a version command" do
    it "prints version" do
      expect(&cli).to output(/Git\sCop\s#{Git::Cop::Identity.version}\n/).to_stdout
    end
  end

  shared_examples_for "a help command" do
    it "prints usage" do
      expect(&cli).to output(/Git\sCop\s#{Git::Cop::Identity.version}\scommands:\n/).to_stdout
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
