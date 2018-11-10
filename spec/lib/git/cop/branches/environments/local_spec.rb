# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Branches::Environments::Local do
  subject(:local) { described_class.new shell: shell }

  let(:shell) { class_spy Open3 }

  describe "#name" do
    it "answers Git branch name" do
      command = "git rev-parse --abbrev-ref HEAD | tr -d '\n'"
      allow(shell).to receive(:capture2e).with(command).and_return(["test", true])

      expect(local.name).to eq("test")
    end
  end

  describe "#shas" do
    it "answers Git commit SHAs" do
      command = %(git log --pretty=format:"%H" master..test)
      allow(local).to receive(:name).and_return("test")
      allow(shell).to receive(:capture2e).with(command).and_return(["abc\ndef", true])

      expect(local.shas).to contain_exactly("abc", "def")
    end
  end
end
