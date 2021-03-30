# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KUtil::ConsoleHelper do
  fit 'samples' do
    puts KUtil.console.hyperlink('Google', 'https://google.com')
    puts KUtil.console.file_hyperlink('My File', '/somepath/my-file.txt')
  end

  describe 'module helper' do
    subject { KUtil.console }

    it { is_expected.not_to be_nil }
  end

  describe '#file_hyperlink' do
    subject { described_class.file_hyperlink(text, file) }

    let(:text) { 'My Text' }
    let(:file) { '/somepath/my-file.txt' }

    it { is_expected.to eq("\e]8;;file:///somepath/my-file.txt\aMy Text\e]8;;\a") }
    # See it in action
    it { puts subject }
  end

  describe '#hyperlink' do
    subject { described_class.hyperlink(text, link) }

    let(:text) { 'Google' }
    let(:link) { 'https://google.com' }

    it { is_expected.to eq("\e]8;;https://google.com\aGoogle\e]8;;\a") }

    # See it in action
    it { puts subject }
  end
end
