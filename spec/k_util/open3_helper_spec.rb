# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KUtil::Open3Helper do
  let(:instance) { described_class.new }

  describe '#capture2' do
    subject { instance.capture2(command) }

    let(:output) { 'test' }
    let(:status) { instance_spy(Process::Status) }

    before do
      allow(status).to receive(:success?).and_return(success?)
      allow(Open3).to receive(:capture2).and_return([output, status])
    end

    context 'command is successfully executed' do
      let(:success?) { true }
      let(:command) { 'some valid command' }

      it { is_expected.to eq(output) }
    end

    context 'command is not executed successfully' do
      let(:success?) { false }
      let(:command) { 'some invalid command' }

      it { expect { subject }.to raise_error(KUtil::Open3Error) }
    end
  end

  describe 'module helper' do
    subject { KUtil.open3 }

    it { is_expected.not_to be_nil }
  end
end
