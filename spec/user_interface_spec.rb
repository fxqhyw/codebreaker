require 'spec_helper'

module Codebreaker
  RSpec.describe UserInterface do
    let(:game) { subject.instance_variable_set(:@game, Game.new) }

    describe '#main_menu' do
      it 'outputs greeting message' do
        allow(subject).to receive_message_chain(:gets, :chomp)
        allow(subject).to receive(:play)
        expect { subject.main_menu }.to output("***Welcome to the Codebreaker game!***\n"\
                                               "Enter any characters to start playing or 'exit' for exit\n").to_stdout
      end

      context 'when input something' do
        before { allow(subject).to receive(:greeting_message) }

        context "when input is an 'exit'" do
          it "outputs 'Bye!' and quit" do
            allow(subject).to receive_message_chain(:gets, :chomp).and_return('exit')
            allow(subject).to receive(:exit)
            expect { subject.main_menu }.to output("Bye!\n").to_stdout
          end
        end

        context "when input is a 'play'" do
          it "calls 'play'" do
            allow(subject).to receive_message_chain(:gets, :chomp).and_return('play')
            expect(subject).to receive(:play)
            subject.main_menu
          end
        end
      end
    end

    describe '#play' do
      context 'before playing' do
        before(:each) do
          allow(subject).to receive(:playing)
          allow(subject).to receive(:lost)
          allow(subject).to receive(:score)
          allow(subject).to receive(:after_game_menu)
        end

        it 'sets instance @game to object of Game class' do
          allow(subject).to receive(:start_game_message)
          subject.play
          expect(subject.instance_variable_get(:@game).instance_of?(Game)).to be true
        end

        it 'outputs start game message' do
          stub_const('Codebreaker::Game::ATTEMPTS', 10)
          stub_const('Codebreaker::Game::HINTS', 4)
          expect { subject.play }.to output("Please, enter your code to make guess or 'h' to get a hint\n"\
                                            "You have #{Game::ATTEMPTS} attempts and #{Game::HINTS} hints\n").to_stdout
        end
      end

      context 'playing' do
        before(:each) do
          allow(subject).to receive(:start_game_message)
          allow(subject).to receive(:score)
          allow(subject).to receive(:after_game_menu)
        end

        context 'input' do
          before(:each) do
            allow(subject).to receive(:create_new_game)
            allow(subject).to receive(:won?).and_return(true)
            allow(subject).to receive(:won)
          end

          context "when input is 'h'" do
            it 'outputs hint' do
              allow(subject).to receive_message_chain(:gets, :chomp).and_return('h')
              allow(game).to receive(:hint).and_return(3)
              expect { subject.play }.to output("3\n").to_stdout
            end

            it 'outputs no hints message' do
              allow(subject).to receive(:create_new_game).and_call_original
              allow(subject).to receive_message_chain(:gets, :chomp).and_return('h')
              allow(subject).to receive(:hints?).and_return(false)
              expect { subject.play }.to output("You used all of hints!\n").to_stdout
            end
          end

          context 'when input is a valid code' do
            it 'outputs result' do
              allow(subject).to receive_message_chain(:gets, :chomp).and_return('1234')
              allow(game).to receive(:make_guess).and_return('++--')
              expect { subject.play }.to output("++--\n").to_stdout
            end
          end
        end

        context 'when won' do
          before(:each) do
            allow(subject).to receive(:create_new_game)
            allow(subject).to receive_message_chain(:gets, :chomp).and_return('1234')
            allow(game).to receive(:make_guess).and_return('++++')
            allow(subject).to receive(:show_result)
          end

          it "sets an instance @game_status to 'won'" do
            allow(subject).to receive(:won_message)
            subject.play
            expect(subject.instance_variable_get(:@game_status)).to eq('won')
          end

          it 'outputs congratulations message' do
            expect { subject.play }.to output("***Congratulations, you won!***\n").to_stdout
          end
        end

        context 'when lost' do
          before(:each) do
            allow(subject).to receive(:create_new_game)
            allow(subject).to receive(:start_game_message)
            allow(subject).to receive(:attempts?).and_return(false)
          end

          it "sets an instance @game_status to 'lost'" do
            allow(subject).to receive(:lost_message)
            subject.play
            expect(subject.instance_variable_get(:@game_status)).to eq('lost')
          end

          it 'outputs lost message' do
            expect { subject.play }.to output("You used all of attempts. You lost :(\n").to_stdout
          end
        end
      end
      context 'after playing' do
        before(:each) do
          allow(subject).to receive(:create_new_game)
          allow(subject).to receive(:start_game_message)
          allow(subject).to receive(:attempts?).and_return(false)
          allow(subject).to receive(:lost)
        end

        it 'outputs score' do
          allow(subject).to receive(:after_game_menu)
          game.instance_variable_set(:@used_attempts, 5)
          game.instance_variable_set(:@used_hints, 2)
          expect { subject.play }.to output("Attempts used: 5\nHints used: 2\n").to_stdout
        end

        context 'after game menu' do
          before(:each) do
            allow(subject).to receive(:score)
            allow(subject).to receive(:main_menu)
          end

          it 'ouputs after game question' do
            allow(subject).to receive_message_chain(:gets, :chomp, :[])
            expect { subject.play }.to output("Do you want to play again(y/n) or save score(s)?\n").to_stdout
          end

          context 'when input' do
            before(:each) do
              allow(subject).to receive(:after_game_question)
            end

            context "when input is 'y'" do
              it "calls 'play'" do
                allow(subject).to receive_message_chain(:gets, :chomp).and_return('y')
                expect(subject).to receive(:play)
                subject.play
              end
            end

            context "when input is 'n'" do
              it "calls 'bye'" do
                allow(subject).to receive_message_chain(:gets, :chomp).and_return('n')
                expect(subject).to receive(:bye)
                subject.play
              end
            end

            context "when input is 's'" do
              before(:each) do
                allow(subject).to receive(:ask_name)
                allow(subject).to receive_message_chain(:gets, :chomp).and_return('s')
              end

              it "calls 'save_result'" do
                allow(subject).to receive(:saved_result_message)
                expect(game).to receive(:save_result)
                subject.play
              end

              it 'ouputs saved result message' do
                allow(game).to receive(:save_result)
                expect { subject.play }.to output("Your result has been saved\n").to_stdout
              end
            end
          end
        end
      end
    end
  end
end
