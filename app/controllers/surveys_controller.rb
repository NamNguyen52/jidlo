class SurveysController < ApplicationController

	def index
	end

	def show
		@info = Survey.find_by(uniqueid: params[:uniqueid])
		@survey1 = true
		@survey2 = false
	end

	def create
		@people = params[:new_survey][:people]
		@name = params[:new_survey][:name]
		@location = params[:new_survey][:location]
		@uniqueid = ('a'..'z').to_a.shuffle[0,8].join
		@survey = Survey.new
		@survey.name = @name
		@survey.people = @people
		@survey.location = @location
		@survey.uniqueid = @uniqueid
		@survey.q1 = []
		@survey.q2 = []
		@survey.q3 = []
		@survey.restaurants = []
		@survey.save

		@link = "localhost:3000/survey_link/#{@uniqueid}"

		render 'index'
	end

	def crunch
		@survey1 = true
		@survey2 = false
		@info = Survey.find_by(uniqueid: params[:uniqueid])
		ques = Survey.find_by(uniqueid: params[:uniqueid])

		ques.q1 += [params[:response][:question1]]
		ques.q2 += [params[:response][:question2]]
		ques.q3 += [params[:response][:question3]]

		ques.save

		recordid = ques.id

		if ques.save
			@survey2 = true
			@survey1 = false
			check(recordid)
			render 'show'
		else
			render 'show'
		end
	end

	def check(id)
		curr_record = Survey.find(id)
		if curr_record.q1.length == curr_record.people
			mode(curr_record)
		end
	end

	def mode(curr_record)

		freq1 = curr_record.q1.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode1 = curr_record.q1.max_by { |v| freq1[v] }

		freq2 = curr_record.q2.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode2 = curr_record.q1.max_by { |v| freq2[v] }

		freq3 = curr_record.q3.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		mode3 = curr_record.q1.max_by { |v| freq3[v] }

		location = curr_record.location

		cases(mode1, mode2, mode3, location)
	end

	def cases(mode1, mode2, mode3, location)
		case mode1
		
		when "Thai"
			categoryId = "4bf58dd8d48988d149941735"  #Thai
		when "Chinese"
			categoryId = "4bf58dd8d48988d145941735"  #Chinese
		when "Mexican"
			categoryId = "4bf58dd8d48988d1c1941735"  #Mexican
		when "Sushi"
			categoryId = "4bf58dd8d48988d1d2941735"  #Sushi
		when "Burger"
			categoryId = "4bf58dd8d48988d16c941735"  #Burger Joint
		when "Korean"
			categoryId = "4bf58dd8d48988d113941735"  #Korean
		when "Indian"
			categoryId = "4bf58dd8d48988d10f941735"  #Indian
		when "FoodTruck"
			categoryId = "4bf58dd8d48988d1cb941735"  #Food Truck
		when "FastFood"
			categoryId = "4bf58dd8d48988d16e941735"  #Fast Food 
		end

		case mode2

		when "walking"
  			radius = 800
		when "short-drive"
			radius = 3200
		when "long-drive"
			radius = 70000
		end
		
		case mode3	

		when "$"
			price_tier = 1
		when "$$"
			price_tier = 2
		when "$$$"
			price_tier = 3
		when "$$$$"
			price_tier = 4
		end

		api_call1(categoryId, radius, location, price_tier)
	end

	def api_call1(m1, m2, location, m3)

		client = Foursquare2::Client.new(:client_id => 'XFYKY1CI1GK1MHXLUG43THGBTYDFUUBFPXVLGNGD441C3HWO', :client_secret => '2J4FTZRUCVVTVM4OYMO2R15UJLPUQ4XOU4GJS1BGIYOK1YWV', :api_version => '20140928')
		@resultspt1 = client.search_venues(:near => location, :radius => m2, :limit => 20, :categoryId => m1)

		arrayiterate = (0..15).to_a

		arrayiterate.each do |x|
			venueids = []
			venueids << @resultspt1.venues[x].id 
			if x == 15
				return venueids
			end
		end

		api_call2(venueids, m3)
	end

	def api_call2(arr,m3)

		client = Foursquare2::Client.new(:client_id => 'XFYKY1CI1GK1MHXLUG43THGBTYDFUUBFPXVLGNGD441C3HWO', :client_secret => '2J4FTZRUCVVTVM4OYMO2R15UJLPUQ4XOU4GJS1BGIYOK1YWV', :api_version => '20140928')

		arr.each do |x|
			search_venues = []
			search_venues << client.venue(x)
			if x == arr.last
				return search_venues 
			end
		end	
		filter(search_venues,m3)
	end

	def filter(arr,m3)

		client = Foursquare2::Client.new(:client_id => 'XFYKY1CI1GK1MHXLUG43THGBTYDFUUBFPXVLGNGD441C3HWO', :client_secret => '2J4FTZRUCVVTVM4OYMO2R15UJLPUQ4XOU4GJS1BGIYOK1YWV', :api_version => '20140928')

		arr.each do |x|
			matched_restaurants = []
			if x.price.tier == m3
				matched_restaurants << x.name
			end
			return matched_restaurants
		end
		
		@restaurant1 = matched_restaurants[0]
		@restaurant2 = matched_restaurants[1]		
		@restaurant3 = matched_restaurants[2]	

		render 'show'	
	end
end
