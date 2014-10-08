class SurveysController < ApplicationController

	skip_before_filter :verify_authenticity_token            
	respond_to :json

	def index
	end

	def show
		@info = Survey.find_by(uniqueid: params[:uniqueid])
		@survey1 = true
		@survey2 = false
		@uniqueid = params[:uniqueid]
		gon.uniqueid = @uniqueid
	end

	def create
		people = params[:new_survey][:people]
		name = params[:new_survey][:name]
		location = params[:new_survey][:location]
		uniqueid = ('a'..'z').to_a.shuffle[0,8].join
		survey = Survey.new
		survey.name = name
		survey.people = people
		survey.location = location
		survey.uniqueid = uniqueid
		survey.q1 = []
		survey.q2 = []
		survey.q3 = []
		survey.restaurants = []
		survey.final_result = []
		survey.venue_one = []
		survey.venue_two = []
		survey.venue_three = []
		survey.save

		@link = "localhost:3000/survey_link/#{uniqueid}"

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
		else
			render 'show'
		end
	end

	def check(id)
		curr_record = Survey.find(id)
		if curr_record.q1.length == curr_record.people
			mode(curr_record)
		else
			render 'show'
		end
	end

	def mode(curr_record)

		freq1 = curr_record.q1.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		group = freq1.group_by{ |k,v| v }.each_with_object({}) { |(k,v), h| h[v.map(&:first).join(',')] = k }
		pick = group.max_by { |k,v| v }
		pick_first = pick.first.split(",")
		mode1 = pick_first.sample

		freq2 = curr_record.q2.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		group = freq2.group_by{ |k,v| v }.each_with_object({}) { |(k,v), h| h[v.map(&:first).join(',')] = k }
		pick = group.max_by { |k,v| v }
		pick_first = pick.first.split(",")
		mode2 = pick_first.sample

		freq3 = curr_record.q3.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		group = freq3.group_by{ |k,v| v }.each_with_object({}) { |(k,v), h| h[v.map(&:first).join(',')] = k }
		pick = group.max_by { |k,v| v }
		pick_first = pick.first.split(",")
		mode3 = pick_first.sample

		location = curr_record.location

		case_mode1(mode1,mode2, mode3, location)
	end

	def case_mode1(mode1, mode2, mode3, location)
		
		api_params_arr = []

		case mode1

		when "Thai"
			categoryId = "4bf58dd8d48988d149941735"
			api_params_arr << categoryId 
		when "Chinese"
			categoryId = "4bf58dd8d48988d145941735"
			api_params_arr << categoryId 
		when "Mexican"
			categoryId = "4bf58dd8d48988d1c1941735"
			api_params_arr << categoryId 
		when "Sushi"
			categoryId = "4bf58dd8d48988d1d2941735"
			api_params_arr << categoryId 
		when "Burgers"
			categoryId = "4bf58dd8d48988d16c941735"
			api_params_arr << categoryId 
		when "Korean"
			categoryId = "4bf58dd8d48988d113941735"
			api_params_arr << categoryId 
		when "Indian"
			categoryId = "4bf58dd8d48988d10f941735"
			api_params_arr << categoryId 
		when "FoodTruck"
			categoryId = "4bf58dd8d48988d1cb941735"
			api_params_arr << categoryId 
		when "FastFood"
			categoryId = "4bf58dd8d48988d16e941735"
			api_params_arr << categoryId 
		end

		if api_params_arr.length == 1
			case_mode2(mode2, mode3, location, api_params_arr)
		else
			wrong.com
		end
	end

	def case_mode2(mode2, mode3, location, api_params_arr)
		
		api_params_arr

		case mode2

		when "walking"
  			radius = 2000
  			api_params_arr << radius
		when "short-drive"
			radius = 8000
			api_params_arr << radius
		when "long-drive"
			radius = 20000
			api_params_arr << radius
		end

		if api_params_arr.length == 2
			case_mode3(mode3, location, api_params_arr)
		else
			wrong.com
		end
	end
	
	def case_mode3(mode3, location, api_params_arr)
		
		api_params_arr

		case mode3	

		when "$"
			price_tier = 1
			api_params_arr << price_tier
		when "$$"
			price_tier = 2
			api_params_arr << price_tier
		when "$$$"
			price_tier = 3
			api_params_arr << price_tier
		when "$$$$"
			price_tier = 4
			api_params_arr << price_tier
		end

		if api_params_arr.length == 3
			api_call1(api_params_arr, location)
		else
			wrong.com
		end
	end

	def api_call1(api_params_arr, location)

		client = Foursquare2::Client.new(:client_id => 'XFYKY1CI1GK1MHXLUG43THGBTYDFUUBFPXVLGNGD441C3HWO', :client_secret => '2J4FTZRUCVVTVM4OYMO2R15UJLPUQ4XOU4GJS1BGIYOK1YWV', :api_version => '20140928')
		search = client.search_venues(:near => location, :radius => api_params_arr[1], :limit => 20, :categoryId => api_params_arr[0])
		arrayiterate = (0..10).to_a
		venueids = []

		arrayiterate.each do |x|
			venue = search.venues[x]
			venueid = venue.id
			venueids << venueid
		end
	
		api_call2(venueids, api_params_arr)
	end

	def api_call2(arr,api_params_arr)

		client = Foursquare2::Client.new(:client_id => 'XFYKY1CI1GK1MHXLUG43THGBTYDFUUBFPXVLGNGD441C3HWO', :client_secret => '2J4FTZRUCVVTVM4OYMO2R15UJLPUQ4XOU4GJS1BGIYOK1YWV', :api_version => '20140928')
		search_venues = []

		arr.each do |x|
			search_venues << client.venue(x)
		end	

		filter(search_venues,api_params_arr)
	end

	def filter(arr,api_params_arr)

		client = Foursquare2::Client.new(:client_id => 'XFYKY1CI1GK1MHXLUG43THGBTYDFUUBFPXVLGNGD441C3HWO', :client_secret => '2J4FTZRUCVVTVM4OYMO2R15UJLPUQ4XOU4GJS1BGIYOK1YWV', :api_version => '20140928')

		#venue_one = []
		#venue_two = []
		#venue_three = []
		
		#matched_restaurants = []
		#matched_address = []
		#matched_rating = []
		#matched_tip1 = []
		#matched_tip2 = []
		#matched_tip3 = []
		#matched_photos = []


		final = Survey.find_by(uniqueid: params[:uniqueid])

		arr.each do |x|

			if x.price && x.price.tier == api_params_arr[2]
				if final.venue_one.length == 0 && final.venue_two.length == 0 && final.venue_three.length == 0
					final.venue_one << x.name
					final.venue_one << x.location.formattedAddress[0] + ", " + x.location.formattedAddress[1]
					final.venue_one << x.rating
					final.venue_one << x.tips.groups[0].items[0].text
					final.venue_one << x.tips.groups[0].items[1].text
					final.venue_one << x.tips.groups[0].items[2].text
				elsif final.venue_one.length == 6 && final.venue_two.length == 0
					final.venue_two << x.name
					final.venue_two << x.location.formattedAddress[0] + ", " + x.location.formattedAddress[1]
					final.venue_two << x.rating
					final.venue_two << x.tips.groups[0].items[0].text
					final.venue_two << x.tips.groups[0].items[1].text
					final.venue_two << x.tips.groups[0].items[2].text
				elsif final.venue_two.length == 6
					final.venue_three << x.name
					final.venue_three << x.location.formattedAddress[0] + ", " + x.location.formattedAddress[1]
					final.venue_three << x.rating
					final.venue_three << x.tips.groups[0].items[0].text
					final.venue_three << x.tips.groups[0].items[1].text
					final.venue_three << x.tips.groups[0].items[2].text
				end
			end
		end 


		#final_result = [venue_one, venue_two, venue_three]

		final.final_result += final.venue_one
		final.final_result += final.venue_two
		final.final_result += final.venue_three
		#final.final_result.save

		final.save



		# matched_restaurants = arr.select {|restaurant| restaurant.price && restaurant.price.tier == api_params_arr[2] }
		
		#if matched_restaurants.length == 0
		#@restaurant1 = "Nada returned!"
		#elsif matched_restaurants.length == 1
		#@restaurant1 = matched_restaurants[0]
		#elsif matched_restaurants.length >= 2 && matched_restaurants.length < 3
		#@restaurant1 = matched_restaurants[0]
		#@restaurant2 = matched_restaurants[1]		
		#elsif matched_restaurants.length >= 3

		@restaurant1 = final.final_result[0] + " " + final.final_result[1] + " " + final.final_result[2].to_s + " " + final.final_result[3] + " " + final.final_result[4] + " " + final.final_result[5]

		@restaurant2 = final.final_result[6] + " " + final.final_result[7] + " " + final.final_result[8].to_s + " " + final.final_result[9] + " " + final.final_result[10] + " " + final.final_result[11]

		@restaurant3 = final.final_result[12] + " " + final.final_result[13] + " " + final.final_result[14].to_s + " " + final.final_result[15] + " " + final.final_result[16] + " " + final.final_result[17] 

		#render 'show'	

		top_rest
	end


	def ttop_rest
    	@survey = Survey.last
    	respond_to do |format|
    	format.json { render :json => @survey }
		end
    end

    # window.setTimeout(function(){ document.location.reload(true); }, 7000);

	def top_rest
		survey = Survey.find_by(uniqueid: params[:uniqueid])
		render json: {
			"venueOne" => survey.final_result[0],
			"venueOneAddress" => survey.final_result[1],
			"venueTwo" => survey.final_result[6],
			"venueTwoAddress" => survey.final_result[7],
			"venueThree" => survey.final_result[12],
			"venueThreeAddress" => survey.final_result[13]
		}
	end

#def top_rest
#		@survey = Survey.last
#		render json: {
#			'restaurant1' => 'Shop House',
#			'restaurant2' => 'Subway',
#			'restaurant3' => 'Chipotle'
#		}
#	end



end