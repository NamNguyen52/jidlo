require 'rubygems'
require 'twilio-ruby' 

class SurveysController < ApplicationController

	def index
	end

	def show
		@info = Survey.find_by(uniqueid: params[:uniqueid])
	end

	def create
		@people = params[:new_survey][:people]
		@name = params[:new_survey][:name]
		@location = params[:new_survey][:location]
		@latitude = params[:new_survey][:latitude]
		@longitude = params[:new_survey][:longitude]
		@uniqueid = ('a'..'z').to_a.shuffle[0,8].join
		@survey = Survey.new
		@survey.name = @name
		@survey.people = @people
		@survey.location = @location
		@survey.latitude = @latitude
		@survey.longitude = @longitude
		@survey.uniqueid = @uniqueid
		@survey.q1 = []
		@survey.q2 = []
		@survey.q3 = []
		@survey.restaurants = []
		@survey.save

		@link = "localhost:3000/survey_link/#{@uniqueid}"


 
account_sid = 'ACc81c5abf7e87ff004ebaa870388e0620' 
auth_token = '473558defcc16dc759b89bb55c664be6' 
 
@client = Twilio::REST::Client.new account_sid, auth_token 
 
@client.account.messages.create({
	:from => '+14244887319', 
	:to => '3104067401', 
	:body => @link,  
	})

	render 'index'
	
	end

	def crunch

		ques = Survey.find_by(uniqueid: params[:uniqueid])

		ques.q1 += [params[:response][:question1]]
		ques.q2 += [params[:response][:question2]]
		ques.q3 += [params[:response][:question3]]

		ques.save


client = Foursquare2::Client.new(:client_id => 'XFYKY1CI1GK1MHXLUG43THGBTYDFUUBFPXVLGNGD441C3HWO', :client_secret => '2J4FTZRUCVVTVM4OYMO2R15UJLPUQ4XOU4GJS1BGIYOK1YWV', :api_version => '20140928')
#search = params[:search_entry]
#search1 = params[:search1_entry]
#search2 = params[:search2_entry]

# @results = client.search_venues(:query => "thai food", :near => "Santa Monica, CA", :ll => "39.03, -118.89", :limit => 20, :radius => 8000, :categoryId => "")

@resultspt1 = client.search_venues(:near => "90401", :radius => "70000", :limit => 20, :categoryId => "4bf58dd8d48988d1d2941735")
# @results = client.search_venues(:query => search, :near => search1, :categoryId => search2)
# @results = client.search_venues(:query => search, :ll => search1, :near => search2, :radius => search3, :limit => search4, :categoryId => search5)

@resultspt2 = client.venue("52ef8a44498e6cc9798d1a20")

@resultspt3 = client.venue("4b2d5d05f964a5201bd524e3")

@resultspt4 = client.venue("4b32efe1f964a520271625e3")



render 'testingredir'
end


=begin
	def do_crunch
		apiCrunch = Survey.find_by(uniqueid: params[:uniqueid])
		
		allArray = [apiCrunch.q1,apiCrunch.q2,apiCrunch.q3]

		freq1 = apiCrunch.q1.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode1 = apiCrunch.q1.max_by { |v| freq1[v] }

		freq2 = apiCrunch.q2.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode2 = apiCrunch.q1.max_by { |v| freq2[v] }

		freq3 = apiCrunch.q3.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode3 = apiCrunch.q1.max_by { |v| freq3[v] }



		freq1 = allArray[0].inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode1 = allArray[0].max_by { |v| freq1[v] }

		freq2 = allArray[1].inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode2 = allArray[1].max_by { |v| freq2[v] }

		freq3 = allArray[2].inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode3 = allArray[2].max_by { |v| freq3[v] }

		case a
		
		when mode1 == Thai
			categoryId = 4bf58dd8d48988d149941735  #Thai
		when mode1 == Chinese
			categoryId = 4bf58dd8d48988d145941735  #Chinese
		when mode1 == Mexican
			categoryId = 4bf58dd8d48988d1c1941735  #Mexican
		when mode1 == Sushi
			categoryId = 4bf58dd8d48988d1d2941735  #Sushi
		when mode1 == Burger
			categoryId = 4bf58dd8d48988d16c941735  #Burger Joint
		when mode1 == Korean
			categoryId = 4bf58dd8d48988d113941735  #Korean
		when mode1 == Indian
			categoryId = 4bf58dd8d48988d10f941735  #Indian
		when mode1 == FoodTruck
			categoryId = 4bf58dd8d48988d1cb941735  #Food Truck
		when mode1 == FastFood
			categoryId = 4bf58dd8d48988d16e941735  #Fast Food 
		when mode2 == walking
  			radius = 800
		when mode2 == short-drive
			radius = 3200
		when mode2 == long-drive
			radius = 8000
		when mode3 == $
			results.price.tier = 1
		when mode3 == $$
			results.price.tier = 2
		when mode3 == $$$
			results.price.tier = 3
		when mode3 == $$$$
			results.price.tier = 4
		else
			nil
		end
	end
=end



=begin
		allArray.each do |x|

			counter = 1
			'mode' + counter.to_s = x.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
			x.max_by { |v| ('mode' + counter.to_s)[v] }
			counter ++
		end

		@mode = arr.max_by { |v| freq[v] }
=end


	
end
