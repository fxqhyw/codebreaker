require 'spec_helper'

module Codebreaker
  RSpec.describe UserInterface do
    before { allow(subject).to receive(:puts) }

    describe '#main_menu' do
      context "when input is 'exit'" do
        it "calls 'bye'" do
          allow(subject).to receive_message_chain(:gets, :chomp).and_return('exit')
          expect(subject).to receive(:bye)
          subject.main_menu
        end
      end

      context 'when input is something else' do
        it "calls 'play'" do
          allow(subject).to receive_message_chain(:gets, :chomp).and_return('any input') 
          expect(subject).to receive(:play)
          subject.main_menu
        end
      end
    end

    describe '#save_or_again' do
      let(:game) { subject.instance_variable_set(:@game, Game.new) }
      before { allow(game).to receive(:save_result) }

      context "when input is 'y'" do
        it "calls 'play'" do
          allow(subject).to receive_message_chain(:gets, :chomp).and_return('y')
          allow(subject).to receive(:main_menu)
          expect(subject).to receive(:play)
          subject.send(:save_or_again)
        end
      end

      context "when input is 'n'" do
        it "calls 'bye'" do
          allow(subject).to receive_message_chain(:gets, :chomp).and_return('n')
          allow(subject).to receive(:main_menu)
          expect(subject).to receive(:bye)
          subject.send(:save_or_again)
        end
      end

      context "when input is 's'" do
        before { allow(subject).to receive_message_chain(:gets, :chomp).and_return('s') }

        it "calls 'ask_name'" do
          allow(subject).to receive(:main_menu)
          expect(subject).to receive(:ask_name)
          subject.send(:save_or_again)
        end

        it "calls 'save_result'" do
          allow(subject).to receive(:ask_name)
          allow(subject).to receive(:main_menu)
          expect(game).to receive(:save_result)
          subject.send(:save_or_again)
        end

        it "calls 'main_menu'" do
          allow(subject).to receive(:ask_name)
          expect(subject).to receive(:main_menu)
          subject.send(:save_or_again)
        end
      end

      context 'when input is something else' do
        before { allow(subject).to receive_message_chain(:gets, :chomp).and_return('some input') }

        it "calls 'save_result'" do
          allow(subject).to receive(:ask_name)
          allow(subject).to receive(:main_menu)
          expect(game).to receive(:save_result)
          subject.send(:save_or_again)
        end

        it "calls 'main_menu'" do
          allow(subject).to receive(:ask_name)
          expect(subject).to receive(:main_menu)
          subject.send(:save_or_again)
        end
      end
    end
  end
end
