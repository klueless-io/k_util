# frozen_string_literal: true

# require 'spec_helper'

# RSpec.describe KUtil::DataHelper do
#   describe 'module helper' do
#     subject { KUtil.data }

#     it { is_expected.not_to be_nil }

#     # it { expect(subject.build_unique_key('key', 'type', 'namespace')).to eq('namespace_key_type') }
#   end

#   describe '#to_struct' do
#     subject { described_class.to_struct(data) }

#     # it { expect { subject }.to raise_error KError }
#     context 'when simple hash' do
#       let(:data) { { key1: 'David', key2: 333 } }

#       it { is_expected.to have_attributes(key1: 'David', key2: 333) }
#     end
#     context 'when array of hash' do
#       let(:data) { { items: [{id: 1, name: 'Item1'}, {id: 2, name: 'Item2'}] } }

#       it do
#         expect(subject).to have_attributes(
#           items: array_including(
#             have_attributes(id: 1, name: 'Item1'),
#             have_attributes(id: 2, name: 'Item2')
#             )
#         )
#       end
#     end
#     context 'when complex hash' do
#       let(:data) { { key1: 'David', key2: 333, items: [{id: 1, name: 'Item1'}, {id: 2, name: 'Item2'}] } }

#       it do
#         expect(subject).to have_attributes(
#           key1: 'David',
#           key2: 333,
#           items: array_including(
#             have_attributes(id: 1, name: 'Item1'),
#             have_attributes(id: 2, name: 'Item2')
#             )
#         )
#       end
#     end
#   end

#   describe '#clean_symbol' do
#     subject { described_class.clean_symbol(value) }

#     let(:value) { nil }

#     context 'when value is nil' do
#       it { is_expected.to be_nil }
#     end

#     context 'when value is string' do
#       let(:value) { 'a_string' }

#       it { is_expected.to eq('a_string') }
#     end

#     context 'when value is :symbol' do
#       let(:value) { :a_symbol }

#       it { is_expected.to eq('a_symbol') }
#     end
#   end

#   describe '#console_file_hyperlink' do
#     subject { described_class.console_file_hyperlink(text, file) }

#     let(:text) { 'My Text' }
#     let(:file) { '/somepath/myfile.txt' }

#     it { is_expected.to eq("\e]8;;file:///somepath/myfile.txt\aMy Text\e]8;;\a") }
#     # See it in action
#     # it { puts subject }
#   end
# end
