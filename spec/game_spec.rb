require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    context '#generate' do
      it 'returns secret code array of 4 numbers from 1 to 6' do
        expect(subject.send(:generate).join).to match(/^[1-6]{4}$/)
      end
    end

    context '#hint' do
      it 'returns one random number from the secret code' do
        subject.instance_variable_set(:@secret_code, [1, 2, 3, 6])
        expect(subject.hint.to_s).to match(/^[1-6]{1}$/)
      end

      it 'increases hints counter by 1' do
        subject.instance_variable_set(:@used_hints, 0)
        subject.hint
        expect(subject.instance_variable_get(:@used_hints)).to eq(1)
      end
    end
    context '#code_valid?' do
      let(:valid_code) { '1236' }
      let(:invalid_code) { 'invalid code, lol' }
      it 'returns true if user code is valid' do
        expect(subject.send(:code_valid?, valid_code)).to be_truthy
      end

      it 'returns false if user code is invalid' do
        expect(subject.send(:code_valid?, invalid_code)).to be_falsey
      end
    end
  end
end
