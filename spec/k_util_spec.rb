# frozen_string_literal: true

RSpec.describe KUtil do
  it 'has a version number' do
    expect(KUtil::VERSION).not_to be nil
  end

  # it 'has a standard error' do
  #   expect { raise KUtil::Error, 'some message' }
  #     .to raise_error('some message')
  # end
end
