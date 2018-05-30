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

      it 'increases used hints counter by 1' do
        subject.instance_variable_set(:@used_hints, 0)
        subject.hint
        expect(subject.instance_variable_get(:@used_hints)).to eq(1)
      end
    end
    context '#make_guess' do
      let(:valid_code) { '1236' }
      let(:invalid_code) { 'code' }

      it 'returns warning if user code is invalid' do
        allow(subject).to receive(:match_calculation)
        expect(subject.make_guess(invalid_code)).to eq 'Incorrect code format'
      end

      it 'reduces available attempts counter by 1' do
        allow(subject).to receive(:match_calculation)
        subject.instance_variable_set(:@available_attempts, 1)
        expect { subject.make_guess(valid_code) }.to change { subject.available_attempts }.to(0)
      end

      context 'when matched exactly' do
        it 'returns ++++' do
          allow(subject).to receive(:match_calculation)
          subject.instance_variable_set(:@secret_code, [1, 2, 3, 6])
          expect(subject.make_guess(valid_code)).to eq('++++')
        end

        it 'returns ++--' do
          subject.instance_variable_set(:@secret_code, [1, 2, 6, 3])
          expect(subject.make_guess(valid_code)).to eq('++--')
        end
      end
    end
  end
end
