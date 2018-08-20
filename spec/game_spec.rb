require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    describe '#generate_secret_code' do
      it 'returns secret code array of 4 numbers from 1 to 6' do
        expect(subject.send(:generate_secret_code).join).to match(/^[1-6]{4}$/)
      end
    end

    describe '#hint' do
      it 'returns one last number from the hints array and delete it' do
        subject.instance_variable_set(:@shuffled_secret_code, [1, 2, 3, 6])
        expect(subject.hint.to_s).to eq('6')
        expect(subject.instance_variable_get(:@shuffled_secret_code).length).to eq(3)
      end

      it 'increases used hints counter by 1' do
        expect{ subject.hint }.to change{ subject.instance_variable_get(:@used_hints) }.from(0).to(1)
      end
    end

    describe '#make_guess' do
      context 'user code is invalid' do
        it 'returns nil' do
          expect(subject.make_guess('invalid_code')).to be_nil
        end
      end

      context 'user code is valid' do
        it 'increases used attempts counter by 1' do
          expect { subject.make_guess('1236') }.to change { subject.used_attempts }.from(0).to(1)
        end
      end

      context 'returns matches result' do
        before { subject.instance_variable_set(:@secret_code, [1, 2, 3, 6]) }

        context 'only exactly matches' do
          it do
            results = {
              '1236': '++++',
              '1235': '+++',
              '1535': '++',
              '5255': '+'
            }
            results.each_pair do |guess, response|
              expect(subject.make_guess(guess.to_s)).to eq(response)
            end
          end
        end

        context 'exactly and number matches' do
          it do
            results = {
              '1632': '++--',
              '1634': '++-',
              '5265': '+-',
              '5261': '+--',
              '3261': '+---'
            }
            results.each_pair do |guess, response|
              expect(subject.make_guess(guess.to_s)).to eq(response)
            end
          end
        end

        context 'only number matches' do
          it do
            results = {
              '4464': '-',
              '4462': '--',
              '4362': '---',
              '6321': '----'
            }
            results.each_pair do |guess, response|
              expect(subject.make_guess(guess.to_s)).to eq(response)
            end
          end
        end

        context 'no matches' do
          it do
            expect(subject.make_guess('5555')).to eq('')
          end
        end
      end
    end

    describe '#save_result' do
      let(:file_name) { 'test.txt' }

      it "creates 'file_name' and put reult in it" do
        subject.instance_variable_set(:@used_attempts, 5)
        subject.instance_variable_set(:@used_hints, 2)
        file = double('file')
        expect(File).to receive(:open).with(file_name, 'a').and_yield(file)
        expect(file).to receive(:puts).with('Name: test_user')
        expect(file).to receive(:puts).with('Game status: won')
        expect(file).to receive(:puts).with('Attempts used: 5')
        expect(file).to receive(:puts).with('Hints used: 2')
        expect(file).to receive(:puts).with('*' * 40)
        subject.save_result(username: 'test_user', game_status: 'won', file_name: file_name)
      end
    end
  end
end
