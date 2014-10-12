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

	 it "has none to begin with" do
      survey = Survey.new
    	expect(Survey.count).to eq 0
  	end

  	it "has one upon creation" do
    	survey = Survey.new
      survey.save
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

    it "can be saved" do
      survey = Survey.new
      expect(Survey.save).to be_true
    end

    it "can create an empty array" do
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


    describe "#create" do

      it "should have a name" do
        survey = Survey.new(people: 2, location: 'Santa Monica, CA')
        expect(survey).to be_invalid

        survey = Survey.new(name: 'Pooja', people: 2, location: 'Santa Monica, CA')
        expect(survey).to be_valid
      end

      it "should have a name less than 25 characters" do
        survey = Survey.new(name: 'abcdefghijklmnopqrstuvwxyz', people: 2, location: 'Santa Monica, CA')
        expect(survey).to be_invalid

        survey = Survey.new(name: 'Nam', people: 2, location: 'Santa Monica, CA')
        expect(survey).to be_valid
      end

      it "should have a location" do
        survey = Survey.new(name: 'Pooja', people: 2, location: 'Santa Monica, CA')
        expect(survey).to be_valid

        survey = Survey.new(name: 'Nam', people: 2)
        expect(survey).to be_invalid
      end

      it "should have a location containing only letters, #s, " do
        survey = Survey.new(name: 'Pooja', people: 2, location: 'Santa Monica, CA')
        expect(survey).to be_valid
        survey = Survey.new(name: 'Pooja', people: 2, location: '&*$Santa Monica, CA')
        expect(survey).to be_invalid
      end




    end







end


