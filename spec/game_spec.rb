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
        expect(subject.make_guess(invalid_code)).to eq 'Incorrect code format'
      end

      it 'reduces available attempts counter by 1' do
        subject.instance_variable_set(:@available_attempts, 1)
        expect { subject.make_guess(valid_code) }.to change { subject.available_attempts }.to(0)
      end

      context 'making guesses' do
        it 'guesses exactly rigth' do
          subject.instance_variable_set(:@secret_code, [1, 2, 3, 6])
          expect(subject.make_guess(valid_code)).to eq('++++')
        end

        it 'guesses 3 numbers exactly' do
          subject.instance_variable_set(:@secret_code, [1, 2, 3, 5])
          expect(subject.make_guess(valid_code)).to eq('+++')
        end

        it 'guesses 2 numbers exactly' do
          subject.instance_variable_set(:@secret_code, [1, 5, 3, 5])
          expect(subject.make_guess(valid_code)).to eq('++')
        end

        it 'guesses 2 numbers exactly and 2 numbers match' do
          subject.instance_variable_set(:@secret_code, [1, 6, 3, 2])
          expect(subject.make_guess(valid_code)).to eq('++--')
        end

        it 'guesses 2 numbers exactly and 1 numbers match' do
          subject.instance_variable_set(:@secret_code, [1, 6, 3, 4])
          expect(subject.make_guess(valid_code)).to eq('++-')
        end

        it 'guesses 1 number exactly' do
          subject.instance_variable_set(:@secret_code, [5, 2, 5, 5])
          expect(subject.make_guess(valid_code)).to eq('+')
        end

        it 'guesses 1 number exactly and 1 number match' do
          subject.instance_variable_set(:@secret_code, [5, 2, 6, 5])
          expect(subject.make_guess(valid_code)).to eq('+-')
        end

        it 'guesses 1 number exactly and 2 numbers match' do
          subject.instance_variable_set(:@secret_code, [5, 2, 6, 1])
          expect(subject.make_guess(valid_code)).to eq('+--')
        end

        it 'guesses 1 number exactly and 3 numbers match' do
          subject.instance_variable_set(:@secret_code, [3, 2, 6, 1])
          expect(subject.make_guess(valid_code)).to eq('+---')
        end

        it 'guesses 1 number match' do
          subject.instance_variable_set(:@secret_code, [4, 4, 6, 4])
          expect(subject.make_guess(valid_code)).to eq('-')
        end

        it 'guesses 2 numbers match' do
          subject.instance_variable_set(:@secret_code, [4, 4, 6, 2])
          expect(subject.make_guess(valid_code)).to eq('--')
        end

        it 'guesses 3 numbers match' do
          subject.instance_variable_set(:@secret_code, [4, 3, 6, 2])
          expect(subject.make_guess(valid_code)).to eq('---')
        end

        it 'guesses 4 numbers match' do
          subject.instance_variable_set(:@secret_code, [6, 3, 2, 1])
          expect(subject.make_guess(valid_code)).to eq('----')
        end

        it 'guesses no matched' do
          subject.instance_variable_set(:@secret_code, [5, 5, 5, 5])
          expect(subject.make_guess(valid_code)).to eq('')
        end
      end
    end
  end
end
