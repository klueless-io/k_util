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
    subject { instance.expand_path(file, '/klue-less/xyz') }

    context 'when relative filename' do
      let(:file) { 'somefile.rb' }

      it { is_expected.to eq('/klue-less/xyz/somefile.rb') }
    end

    context 'when relative path/filename' do
      let(:file) { 'somepath/somefile.rb' }

      it { is_expected.to eq('/klue-less/xyz/somepath/somefile.rb') }
    end

    context 'when absolute filename' do
      let(:file) { '/somefile.rb' }

      it { is_expected.to eq('/somefile.rb') }
    end

    context 'when tilda ~/filename' do
      let(:file) { '~/somefile.rb' }

      it { is_expected.to start_with('/Users') & end_with('/somefile.rb') }
      it { is_expected.not_to include('klue-less') }
    end
  end
end
