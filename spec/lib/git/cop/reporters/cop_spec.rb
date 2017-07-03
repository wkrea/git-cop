# frozen_string_literal: true

require "spec_helper"

RSpec.describe Git::Cop::Reporters::Cop do
  let(:cop_class) { class_spy Git::Cop::Styles::CommitAuthorEmail, label: "Commit Author Email" }

  let :cop_instance do
    instance_spy Git::Cop::Styles::CommitAuthorEmail, class: cop_class,
                                                      severity: :error,
                                                      issue: issue
  end

  subject { described_class.new cop_instance }

  describe "#to_s" do
    context "without issue lines" do
      let :issue do
        {
          label: "A test label.",
          hint: "A test hint."
        }
      end

      it "answers cop label, issue label, and issue hint" do
        expect(subject.to_s).to eq("  ERROR: Commit Author Email. A test label. A test hint.\n")
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
          "  ERROR: Commit Author Email. A test label. A test hint.\n" \
          "    Line 1: Curabitur eleifend wisi iaculis ipsum.\n" \
          "    Line 3: Ipsum eleifend wisi iaculis curabitur.\n" \
        )
      end
    end
  end
end
