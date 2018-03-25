# frozen_string_literal: true

require 'prompt'
require 'minitest/autorun'

describe Prompt do
  it 'starts and takes user input' do
    prompt = Prompt.new(-> { 4 }, -> {})
    assert_output(/Welcome/) do
      prompt.start
    end
  end
end
