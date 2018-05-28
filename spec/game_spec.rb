require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    describe '#start' do
      it 'saves secret code array of 4 numbers from 1 to 6' do
        subject.start
        expect(subject.instance_variable_get(:@secret_code).join).to match(/^[1-6]{4}$/)
      end
    end
  end
end
