# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'mocks/hash_convertible'
require 'mocks/thunder_birds'

RSpec.describe KUtil::Data::InstanceVariablesToH do
  subject { data.to_h }

  context 'when complex data object' do
    context 'keys and hash' do
      let(:data) do
        key3 = {
          x1: 1,
          x2: 2,
          x3: 3
        }
        HashConvertible.new('David', 333, key3)
      end

      it do
        is_expected.to eq(
          {
            'key1' => 'David',
            'key2' => 333,
            'key3' => {
              x1: 1,
              x2: 2,
              x3: 3
            },
            'people' => []
          }
        )
      end
    end

    context 'keys, hash, array, open_struct, struct' do
      let(:data) do
        virgil = OpenStruct.new(name: 'Virgil Tracy', age: 73, thunder_bird: ThunderBirds.new(:are_grounded))
        penny = OpenStruct.new(name: 'Lady Penelope', age: 69, thunder_bird: ThunderBirds.new(:are_go))
        key3 = {
          value: ThunderBirds.new(:are_go)
        }
        HashConvertible.new('David', 333, key3, [virgil, penny])
      end

      it do
        is_expected.to eq(
          {
            'key1' => 'David',
            'key2' => 333,
            'key3' => { value: { action: :are_go } },
            'people' => [
              { age: 73, name: 'Virgil Tracy', thunder_bird: { action: :are_grounded } },
              { age: 69, name: 'Lady Penelope', thunder_bird: { action: :are_go } }
            ]
          }
        )
        # data_open = KUtil.data.to_open_struct(data)
        # data_hash = KUtil.data.to_hash(data_open)

        # puts JSON.pretty_generate(data_hash)
      end
    end
  end
end
