# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Branches::Environments::NetlifyCI do
  subject(:netlify_ci) { described_class.new environment: environment, shell: shell }

  let(:environment) { {"COMMIT_REF" => "abc"} }
  let(:shell) { class_spy Open3 }

  describe "#name" do
    it "answers Git branch name" do
      expect(netlify_ci.name).to eq("abc")
    end
  end

  describe "#shas" do
    it "answers Git commit SHAs" do
      allow(shell).to receive(:capture2e).with(%(git log --pretty=format:"%H" master..abc))
                                         .and_return(["abc\ndef", true])

      expect(netlify_ci.shas).to contain_exactly("abc", "def")
    end
  end
end
