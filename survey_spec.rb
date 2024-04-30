require_relative 'questionnaire' # Adjust the path accordingly
STORE_NAME = "tendable.pstore"

RSpec.describe 'Questionnaire' do
require 'pstore'
require_relative './questionnaire'

describe 'Survey' do
  before(:all) do
    @store = PStore.new(STORE_NAME)
    @store.transaction do
      @store[:runs] = []
      @store[:answers] = []
    end
  end

  describe '#normalize_answer' do
    it 'returns true for "yes" or "y"' do
      expect(normalize_answer('yes')).to eq(true)
      expect(normalize_answer('y')).to eq(true)
    end

    it 'returns false for other inputs' do
      expect(normalize_answer('no')).to eq(false)
      expect(normalize_answer('n')).to eq(false)
      expect(normalize_answer('')).to eq(false)
    end
  end

  describe '#do_prompt' do
    it 'prompts for answers and calculates score correctly' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('yes', 'yes', 'no', 'no', 'yes')

      score = do_prompt(@store)

      expect(score).to eq(60.0)
      expect(@store.transaction { @store[:runs] }).to eq([60.0])
      expect(@store.transaction { @store[:answers].length }).to eq(1)
    end
  end
end
 
end
