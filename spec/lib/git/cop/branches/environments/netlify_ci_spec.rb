# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Branches::Environments::NetlifyCI do
  subject(:netlify_ci) { described_class.new environment: environment, repo: repo }

  let(:environment) { {"COMMIT_REF" => "test"} }
  let(:repo) { instance_spy Git::Kit::Repo, shas: %w[abc def] }

  describe "#name" do
    it "answers Git branch name" do
      expect(netlify_ci.name).to eq("test")
    end
  end

  describe "#shas" do
    it "uses specific start and finish range" do
      netlify_ci.shas
      expect(repo).to have_received(:shas).with(start: "master", finish: "test")
    end

    it "answers Git commit SHAs" do
      expect(netlify_ci.shas).to contain_exactly("abc", "def")
    end
  end
end
