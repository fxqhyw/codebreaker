require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    context '#generate' do
      it 'returns secret code array of 4 numbers from 1 to 6' do
        expect(subject.generate.join).to match(/^[1-6]{4}$/)
      end
    end
    
    context '#hint' do
      it 'returns one random number from the secret code' do
        subject.instance_variable_set(:@secret_code, '1236')
        expect(subject.hint).to match(/^[1-6]{1}$/)
      end
    end
  end
end
