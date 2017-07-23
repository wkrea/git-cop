# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Cop do
  let(:severity) { :error }
  let(:cop_class) { class_spy Git::Cop::Styles::CommitAuthorEmail, label: "Commit Author Email" }

  let :cop_instance do
    instance_spy Git::Cop::Styles::CommitAuthorEmail, class: cop_class,
                                                      severity: severity,
                                                      issue: issue
  end

  subject { described_class.new cop_instance }

  describe "#to_s" do
    context "with warning" do
      let(:severity) { :warn }

      let :issue do
        {
          label: "A test label.",
          hint: "A test hint."
        }
      end

      it "answers cop label, issue label, and issue hint" do
        expect(subject.to_s).to eq(
          "\e[33m  Commit Author Email Warning: A test label. A test hint.\n\e[0m"
        )
      end
    end

    context "with error" do
      let(:severity) { :error }

      let :issue do
        {
          label: "A test label.",
          hint: "A test hint."
        }
      end

      it "answers cop label, issue label, and issue hint" do
        expect(subject.to_s).to eq(
          "\e[31m  Commit Author Email Error: A test label. A test hint.\n\e[0m"
        )
      end
    end

    context "with unknown severity" do
      let(:severity) { :bogus }

      let :issue do
        {
          label: "A test label.",
          hint: "A test hint."
        }
      end

      it "answers cop label, issue label, and issue hint" do
        expect(subject.to_s).to eq(
          "\e[37m  Commit Author Email: A test label. A test hint.\n\e[0m"
        )
      end
    end

    context "with issue lines" do
      let :issue do
        {
          label: "A test label.",
          hint: "A test hint.",
          lines: [
            {number: 1, content: "Curabitur eleifend wisi iaculis ipsum."},
            {number: 3, content: "Ipsum eleifend wisi iaculis curabitur."}
          ]
        }
      end

      it "answers cop label, issue label, issue hint, and issue lines" do
        expect(subject.to_s).to eq(
          "\e[31m  Commit Author Email Error: A test label. A test hint.\n" \
          "    Line 1: \"Curabitur eleifend wisi iaculis ipsum.\"\n" \
          "    Line 3: \"Ipsum eleifend wisi iaculis curabitur.\"\n\e[0m" \
        )
      end
    end
  end
end
