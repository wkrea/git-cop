# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Kit::Repo do
  describe ".exist?" do
    it "answers true when Git repository exists", :git_repo do
      Dir.chdir git_repo_dir do
        expect(described_class.exist?).to eq(true)
      end
    end

    it "answers true when nested within a Git repository", :temp_dir do
      nested_root = Pathname "#{temp_dir}/a/deeply/nested/path"
      FileUtils.mkdir_p nested_root

      Dir.chdir nested_root do
        expect(described_class.exist?).to eq(true)
      end
    end

    it "answer false when Git repository doesn't exist" do
      Dir.mktmpdir "git-cop" do |dir|
        Dir.chdir dir do
          expect(described_class.exist?).to eq(false)
        end
      end
    end
  end
end
