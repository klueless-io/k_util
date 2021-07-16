# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'mocks/custom'
require 'mocks/dry'
require 'mocks/hash_convertible'
require 'mocks/thunder_birds'

RSpec.describe KUtil::DataHelper do
  let(:instance) { described_class.new }

  inner = Struct.new(:name)
  outer = Struct.new(:name, :age, :more)

  let(:custom_a1) { CustomA.new(name: 'John Doe') }
  let(:virgil) { OpenStruct.new(name: 'Virgil Tracy', age: 73, thunder_bird: ThunderBirds.new(:are_grounded)) }
  let(:penny) { OpenStruct.new(name: 'Lady Penelope', age: 69, thunder_bird: ThunderBirds.new(:are_go)) }
  let(:dry1) { DryA.new(name: 'dry1.name', age: 21, more: { name: 'me' }) }
  let(:struct1) { outer.new('struct1.name', 22, inner.new('normal struct')) }

  # fit 'sample' do
  #   virgil = OpenStruct.new(name: 'Virgil Tracy', age: 73, thunder_bird: ThunderBirds.new(:are_grounded))
  #   penny = OpenStruct.new(name: 'Lady Penelope', age: 69, thunder_bird: ThunderBirds.new(:are_go))
  #   dry = DryA.new(name: 'dry_a.name', age: 21, list: ['a', 'list', 'of', 'stuff'], more: { name: 'me' })

  #   data = {
  #     key1: 'David',
  #     key2: 333,
  #     key3: ThunderBirds.new(:are_go),
  #     people: [virgil, penny],
  #     dry: dry
  #   }

  #   data_open = KUtil.data.to_open_struct(data)
  #   data_hash = KUtil.data.to_hash(data_open)

  #   puts JSON.pretty_generate(data_hash)
  # end

  describe 'module helper' do
    subject { KUtil.data }

    it { is_expected.not_to be_nil }
  end

  describe '#to_open_struct' do
    subject { instance.to_open_struct(data) }

    # it { expect { subject }.to raise_error KError }
    context 'when simple hash' do
      let(:data) { { key1: 'David', key2: 333 } }

      it { is_expected.to have_attributes(key1: 'David', key2: 333) }
    end

    context 'when array of hash' do
      let(:data) { { items: [{ id: 1, name: 'Item1' }, { id: 2, name: 'Item2' }] } }

      it do
        expect(subject).to have_attributes(
          items: array_including(
            have_attributes(id: 1, name: 'Item1'),
            have_attributes(id: 2, name: 'Item2')
          )
        )
      end
    end

    context 'when complex hash' do
      let(:data) { { key1: 'David', key2: 333, items: [{ id: 1, name: 'Item1' }, { id: 2, name: 'Item2' }] } }

      it do
        expect(subject).to have_attributes(
          key1: 'David',
          key2: 333,
          items: array_including(
            have_attributes(id: 1, name: 'Item1'),
            have_attributes(id: 2, name: 'Item2')
          )
        )
      end
    end

    context 'when mixture of Struct and Hash at depth' do
      let(:data) do
        { key1: 'David',
          key2: 333,
          key3: ThunderBirds.new(:are_go),
          items: [
            { id: 1, action: ThunderBirds.new(:are_go) },
            { id: 2, action: ThunderBirds.new(:are_grounded) }
          ] }
      end

      it do
        expect(subject).to have_attributes(
          key1: 'David',
          key2: 333,
          key3: have_attributes(action: :are_go),
          items: array_including(
            have_attributes(id: 1, action: have_attributes(action: :are_go)),
            have_attributes(id: 2, action: have_attributes(action: :are_grounded))
          )
        )
      end
    end

    context 'when mixture of Struct, Dry::Struct, OpenStruct, Custom Class and Hash at depth' do
      let(:p1) { OpenStruct.new(name: 'Virgil Tracy', age: 73, thunder_bird: ThunderBirds.new(:are_grounded)) }
      let(:p2) { OpenStruct.new(name: 'Lady Penelope', age: 69, thunder_bird: ThunderBirds.new(:are_go)) }
      let(:data) do
        { key1: 'David',
          key2: 333,
          key3: ThunderBirds.new(:are_go),
          people: [p1, p2],
          dry: dry1,
          custom: custom_a1 }
      end

      it do
        expect(subject).to have_attributes(
          key1: 'David',
          key2: 333,
          key3: have_attributes(action: :are_go),
          people: array_including(
            have_attributes(name: 'Virgil Tracy', age: 73, thunder_bird: have_attributes(action: :are_grounded)),
            have_attributes(name: 'Lady Penelope', age: 69, thunder_bird: have_attributes(action: :are_go))
          )
        )
      end
    end
  end

  describe '#to_hash' do
    subject { instance.to_hash(data) }

    context 'root is empty' do
      context 'when nil' do
        let(:data) { nil }
        it { is_expected.to eq({}) }
      end

      context 'when {}' do
        let(:data) { {} }
        it { is_expected.to eq({}) }
      end
    end

    context 'root object is array' do
      context 'when simple array' do
        let(:data) { ['a', :b, :c] }
        it { is_expected.to eq(['a', :b, :c]) }
      end

      context 'when mixed array (hash, struct, open-struct, dry-struct, custom class with to_h)' do
        let(:data) { [{ simple: :hash }, virgil, dry1, struct1, custom_a1] }
        let(:expected) do
          [
            { simple: :hash },
            { age: 73,
              name: 'Virgil Tracy',
              thunder_bird: { action: :are_grounded } },
            { age: 21,
              more: { name: 'me' },
              name: 'dry1.name' },
            { age: 22,
              more: { name: 'normal struct' },
              name: 'struct1.name' },
            { name: 'John Doe' }
          ]
        end

        it { is_expected.to eq(expected) }
      end
    end

    context 'root object is hash' do
      context 'simple key/value has nil' do
        let(:data) { { blank: nil, not_blank: 'value' } }

        it { is_expected.to eq({ blank: nil, not_blank: 'value' }) }
      end

      context 'when types are mixed at depth' do
        let(:data) do
          {
            blank: nil,
            simple: :hash,
            open: virgil,
            dry: dry1,
            struct: struct1,
            custom: custom_a1,
            deep_array: [{ simple: :hash }, virgil, dry1, struct1, custom_a1]
          }
        end
        let(:expected) do
          {
            blank: nil,
            custom: { name: 'John Doe' },
            dry: { age: 21, more: { name: 'me' }, name: 'dry1.name' },
            open: { age: 73, name: 'Virgil Tracy', thunder_bird: { action: :are_grounded } },
            simple: :hash,
            struct: { age: 22, more: { name: 'normal struct' }, name: 'struct1.name' },
            deep_array: [
              { simple: :hash },
              { age: 73,
                name: 'Virgil Tracy',
                thunder_bird: { action: :are_grounded } },
              { age: 21,
                more: { name: 'me' },
                name: 'dry1.name' },
              { age: 22,
                more: { name: 'normal struct' },
                name: 'struct1.name' },
              { name: 'John Doe' }
            ]
          }
        end

        it { is_expected.to eq(expected) }
      end
    end
  end

  describe 'hash -> #to_open_struct | #to_hash | #json_parse' do
    let(:data) do
      {
        id: '12345',
        type: 'New repository created',
        author: { id: 1, login: 'abc' },
        created_at: '2011-09-06T17:26:27Z',
        comments: [{ id: 1, comment: 'abc' }, { id: 2, comment: 'xyz' }]
      }
    end
    let(:json) { data.to_json }

    context 'check for data lost through multiple translations' do
      it 'hash -> to_open_struct -> to_hash' do
        as_ostruct = instance.to_open_struct(data)
        as_hash    = instance.to_hash(as_ostruct)
        expect(as_hash).to eq(data)
      end

      it 'json -> json_parse(as: :open_struct) -> to_hash' do
        as_ostruct = instance.json_parse(json, as: :open_struct)
        as_hash    = instance.to_hash(as_ostruct)
        expect(as_hash).to eq(data)
      end

      it 'json -> json_parse(as: :hash_symbolized)' do
        as_hash = instance.json_parse(json, as: :hash_symbolized)
        expect(as_hash).to eq(data)
      end

      it 'hash -> to_open_struct -> to_hash -> to_json' do
        as_ostruct = instance.to_open_struct(data)
        as_hash    = instance.to_hash(as_ostruct)
        as_json    = as_hash.to_json
        expect(as_json).to eq(json)
      end
    end
  end

  describe '#json_parse' do
    subject { instance.json_parse(json, as: as) }

    let(:json) { { response: { code: 200, message: 'message' } }.to_json }
    let(:as) { :hash }

    context 'as:' do
      context ':hash' do
        it { is_expected.to eq({ 'response' => { 'code' => 200, 'message' => 'message' } }) }
      end

      context ':hash_symbolized' do
        let(:as) { :hash_symbolized }
        it { is_expected.to eq({ response: { code: 200, message: 'message' } }) }
      end

      context ':open_struct' do
        let(:as) { :open_struct }
        it { is_expected.to have_attributes(response: have_attributes(code: 200, message: 'message')) }
      end
    end
  end

  describe '#clean_symbol' do
    subject { instance.clean_symbol(value) }

    let(:value) { nil }

    context 'when value is nil' do
      it { is_expected.to be_nil }
    end

    context 'when value is string' do
      let(:value) { 'a_string' }

      it { is_expected.to eq('a_string') }
    end

    context 'when value is :symbol' do
      let(:value) { :a_symbol }

      it { is_expected.to eq('a_symbol') }
    end
  end

  # Add if needed
  # describe '#basic_type?' do
  #   subject { instance.basic_type?(value) }

  #   context 'when value is string' do
  #     let(:value) { 'a_string' }

  #     it { is_expected.to eq(true) }
  #   end

  #   context 'when value is integer' do
  #     let(:value) { 123 }

  #     it { is_expected.to eq(true) }
  #   end
  # end

  describe '#hash_convertible?' do
    subject { instance.hash_convertible?(value) }

    context 'when value is array' do
      let(:value) { [] }
      it { is_expected.to eq(true) }
    end

    context 'when value is hash' do
      let(:value) { {} }
      it { is_expected.to eq(true) }
    end

    context 'when value is struct' do
      let(:value) { Struct.new(:a).new('aaa') }
      it { is_expected.to eq(true) }
    end

    context 'when value is open struct' do
      let(:value) { OpenStruct.new(a: 'aaa') }
      it { is_expected.to eq(true) }
    end

    context 'when value is convertible to hash' do
      let(:value) { HashConvertible.new('aaa', 'bbb', { ccc: :ccc }) }
      it { is_expected.to eq(true) }
    end
  end

  # TODO
  #   describe '#json mapping for custom objects' do
  #     fit {
  #       a = CustomA.new
  #       b1 = CustomB.new
  #       b2 = CustomB.new
  #       a.bs << b1
  #       a.bs << b2
  #       puts JSON.pretty_generate(a)
  # # => {"json_class":"A","one":null,"two":null,"three":null,"bs":[{"json_class":"B","x":null,"y":null,"z":null},{"json_class":"B","x":null,"y":null,"z":null}]}
  #      }
  #   end
end
