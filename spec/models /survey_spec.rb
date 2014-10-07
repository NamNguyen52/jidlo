require 'rails_helper'

describe Survey do

	it "should have more than 0 people taking the survey" do
		survey = Survey.new(people: 0)
		expect(survey).not_to be_valid
	end

	it "should have fewer than 11 people taking the survey" do
		survey = Survey.new(people: 11)
		expect(survey).not_to be_valid
	end

#	it "should have a location on which to base the search off of" do
#		survey = Survey.new(location: "Rosewood")
#		expect(survey).to be_valid
#	end

	it "has none to begin with" do
      @survey = Survey.new
    	expect(Survey.count).to eq 0
  	end

  	it "has one upon creation" do
    	@survey = Survey.new
      @survey.save
    	expect(Survey.count).to eq 1
  	end

  	it "creates an instance of survey upon survey creation" do
  		@survey = Survey.new
  		expect(@survey).to be_instance_of(Survey)
  	end

  	it "creates an instance of survey.name upon survey creation" do
  		@survey = Survey.new
  		@survey.name = @name
  		#expect(@survey.name).to be_instance_of(@name)
  		expect(@survey.name).to eql(@name)
  	end

  	it "should begin with a letter, number, or period" do
  		survey = Survey.new
  		survey.name = name
  		expect(@survey.name).to start_with /[a-zA-Z]/
  	end

    it "can be saved" do
      survey = Survey.new
      expect(Survey.save).to be_true
    end

    it "can creates an empty array" do
      survey = Survey.new
      survey.q1 = []
      blah = survey.q1.length
      expect(blah).to eql(0)
    end

    it "create a unique id with exactly 8 characters" do
      uniqueid = ('a'..'z').to_a.shuffle[0,8].join
      arrchars = uniqueid.split("")
      expect(arrchars.length).to eq(8)
    end


end


# ^[A-Za-z0-9_.]+$


#RSpec.describe Survey, :type => :model do
#  pending "add some examples to (or delete) #{__FILE__}"
#end

#describe Survey do

#end