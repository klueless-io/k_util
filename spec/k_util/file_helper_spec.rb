# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KUtil::FileHelper do
  let(:instance) { described_class.new }

  describe 'module helper' do
    subject { KUtil.file }

    it { is_expected.not_to be_nil }
    it { expect(subject.expand_path('file.rb', '/klue-less/xyz')).to eq('/klue-less/xyz/file.rb') }
    it { expect(subject.pathname_absolute?('somepath/somefile.rb')).to eq(false) }
    it { expect(subject.pathname_absolute?('/somepath/somefile.rb')).to eq(true) }
  end

  describe '#expand_path' do
    subject { instance.expand_path(file, base_path) }

    let(:base_path) { nil }

    context 'when filename only' do
      let(:file) { 'somefile.rb' }

      it { is_expected.to eq(File.join(Dir.pwd, file)) }
    end

    context 'when relative path / filename' do
      let(:file) { 'somepath/somefile.rb' }

      it { is_expected.to eq(File.join(Dir.pwd, file)) }
    end

    context 'when filename and base path' do
      let(:file) { 'somefile.rb' }
      let(:base_path) { '/abc/xyz' }

      it { is_expected.to eq(File.join(base_path, file)) }
    end

    context 'when absolute file' do
      let(:file) { '/somefile.rb' }

      it { is_expected.to eq(file) }
    end

    context 'when file in home directory (~ tilda)' do
      let(:file) { '~/somefile.rb' }

      it { is_expected.to eq(File.expand_path(file)) }
    end
  end

  describe '#pathname_absolute?' do
    subject { instance.pathname_absolute?(file) }

    context 'when relative filename' do
      let(:file) { 'somefile.rb' }

      it { is_expected.to be_falsey }
    end

    context 'when relative path/filename' do
      let(:file) { 'somepath/somefile.rb' }

      it { is_expected.to be_falsey }
    end

    context 'when absolute filename' do
      let(:file) { '/somefile.rb' }

      it { is_expected.to be_truthy }
    end

    context 'when tilda ~/filename' do
      let(:file) { '~/somefile.rb' }

      it { is_expected.to be_falsey }
    end
  end

  describe '#home?' do
    subject { instance.home?(file) }

    context 'when filename' do
      let(:file) { 'somefile.rb' }

      it { is_expected.to be_falsey }
    end

    context 'when relative path/filename' do
      let(:file) { 'somepath/somefile.rb' }

      it { is_expected.to be_falsey }
    end

    context 'when absolute filename' do
      let(:file) { '/somefile.rb' }

      it { is_expected.to be_falsey }
    end

    context 'when tilda + filename ~filename' do
      let(:file) { '~somefile.rb' }

      it { is_expected.to be_falsey }
    end

    context 'when tilda ~/filename' do
      let(:file) { '~/somefile.rb' }

      it { is_expected.to be_truthy }
    end
  end

  describe '#parse_uri' do
    subject { instance.parse_uri(uri) }

    context 'when http path' do
      let(:uri) { 'http://my.com/insecure' }

      it do
        is_expected
          .to  have_attributes(scheme: 'http', path: '/insecure')
          .and be_a(URI::HTTP)
      end
    end

    context 'when https path' do
      let(:uri) { 'https://my.com/secure' }

      it do
        is_expected
          .to  have_attributes(scheme: 'https', path: '/secure')
          .and be_a(URI::HTTPS)
      end
    end

    context 'when file path' do
      let(:uri) { 'somefile.rb' }

      it do
        is_expected
          .to  have_attributes(scheme: 'file', path: '/somefile.rb')
          .and be_a(URI::File)
      end
    end
  end
end
