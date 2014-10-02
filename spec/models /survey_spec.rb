require 'rails_helper'

RSpec.describe Survey, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

describe 'Survey' do

  describe '#do_crunch' do
  	context 'when submit survey response' do
	  it 'passes to do_crunch params' do
	  	do_crunch('question1')
	  	expect(q1).to eq 'question1'
	  end	
	end
  end
end

# describe 'Survey' do
#   describe "#crunch" do
#     it "should pull data from question1 " do

#   end
# end