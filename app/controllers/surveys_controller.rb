class SurveysController < ApplicationController

	skip_before_filter :verify_authenticity_token            
	respond_to :json

	def index
		@home = true
		@linkgen = false
	end

	def show
		@info = Survey.find_by(uniqueid: params[:uniqueid])
		@survey1 = true
		@survey2 = false
		@survey3 = false
		@uniqueid = params[:uniqueid]
		gon.uniqueid = @uniqueid
	end

	def create
		@home = false
		@linkgen = true
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
		survey.restaurant = []
		survey.final_result = []
		survey.venue_one = []
		survey.venue_two = []
		survey.venue_three = []
		survey.save
		survey.numbers
		
		#@link = "www.jidlo.us/survey_link/#{uniqueid}"
		# @link = "localhost:3000/survey_link/#{uniqueid}"
		@link = "https://mysterious-lake-6059.herokuapp.com/survey_link/#{uniqueid}"


		account_sid = 'ACc81c5abf7e87ff004ebaa870388e0620' 
		auth_token = '473558defcc16dc759b89bb55c664be6' 
		@client = Twilio::REST::Client.new account_sid, auth_token 
			@client.account.messages.create({
			:from => '+14244887319', 
			:to => '9094771831', 
			:body => @link,  
		})

		render 'index'
	end

	def crunch
		@uniqueid = params[:uniqueid]
		gon.uniqueid = @uniqueid
		@survey1 = true
		@survey2 = false
		@survey3 = false
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
  			radius = 8000
  			api_params_arr << radius
		when "short-drive"
			radius = 10000
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

		client = Foursquare2::Client.new(:client_id => 'IPL2WQAYGQNSAPLZ1R5E2BQBROUJWI03HN1ENN0POFRBFGT4', :client_secret => 'ISH4RDJU5PP4AJ01DONNLBE3AMA43IOMVDWE3IZBFT2N2A4R', :api_version => '20140928')
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

		client = Foursquare2::Client.new(:client_id => 'IPL2WQAYGQNSAPLZ1R5E2BQBROUJWI03HN1ENN0POFRBFGT4', :client_secret => 'ISH4RDJU5PP4AJ01DONNLBE3AMA43IOMVDWE3IZBFT2N2A4R', :api_version => '20140928')
		search_venues = []

		arr.each do |x|
			search_venues << client.venue(x)
		end	

		filter(search_venues,api_params_arr)
	end

	def filter(arr,api_params_arr)

		client = Foursquare2::Client.new(:client_id => 'IPL2WQAYGQNSAPLZ1R5E2BQBROUJWI03HN1ENN0POFRBFGT4', :client_secret => 'ISH4RDJU5PP4AJ01DONNLBE3AMA43IOMVDWE3IZBFT2N2A4R', :api_version => '20140928')

		final = Survey.find_by(uniqueid: params[:uniqueid])

		arr.each do |x|

			if x.price && x.price.tier == api_params_arr[2]
				if final.venue_one.length == 0 && final.venue_two.length == 0 && final.venue_three.length == 0
					final.venue_one += [x.name]
					final.venue_one += [x.location.formattedAddress[0] + ", " + x.location.formattedAddress[1]]
					final.venue_one += [x.price.tier]
					final.venue_one += [x.rating]
					final.venue_one += [x.tips.groups[0].items[1].text]
					final.venue_one += [x.tips.groups[0].items[2].text]
					final.venue_one += [x.tips.groups[0].items[3].text]
					final.venue_one += [x.photos.groups[0].items[0].prefix + "300x300" + x.photos.groups[0].items[0].suffix]
					final.venue_one += [x.photos.groups[0].items[1].prefix + "300x300" + x.photos.groups[0].items[1].suffix]
					final.venue_one += [x.photos.groups[0].items[2].prefix + "300x300" + x.photos.groups[0].items[2].suffix]
					final.venue_one += [x.photos.groups[0].items[3].prefix + "300x300" + x.photos.groups[0].items[3].suffix]
					final.venue_one += [x.photos.groups[0].items[4].prefix + "300x300" + x.photos.groups[0].items[4].suffix]
					final.venue_one += [x.photos.groups[0].items[5].prefix + "300x300" + x.photos.groups[0].items[5].suffix]
					final.save
				elsif final.venue_one.length == 13 && final.venue_two.length == 0
					final.venue_two += [x.name]
					final.venue_two += [x.location.formattedAddress[0] + ", " + x.location.formattedAddress[1]]
					final.venue_two += [x.price.tier]
					final.venue_two += [x.rating]
					final.venue_two += [x.tips.groups[0].items[1].text]
					final.venue_two += [x.tips.groups[0].items[2].text]
					final.venue_two += [x.tips.groups[0].items[3].text]
					final.venue_two += [x.photos.groups[0].items[0].prefix + "400x400" + x.photos.groups[0].items[0].suffix]
					final.venue_two += [x.photos.groups[0].items[1].prefix + "400x400" + x.photos.groups[0].items[1].suffix]
					final.venue_two += [x.photos.groups[0].items[2].prefix + "400x400" + x.photos.groups[0].items[2].suffix]
					final.venue_two += [x.photos.groups[0].items[3].prefix + "400x400" + x.photos.groups[0].items[3].suffix]
					final.venue_two += [x.photos.groups[0].items[4].prefix + "400x400" + x.photos.groups[0].items[4].suffix]
					final.venue_two += [x.photos.groups[0].items[5].prefix + "400x400" + x.photos.groups[0].items[5].suffix]
					final.save
				elsif final.venue_two.length == 13
					final.venue_three += [x.name]
					final.venue_three += [x.location.formattedAddress[0] + ", " + x.location.formattedAddress[1]]
					final.venue_three += [x.price.tier]
					final.venue_three += [x.rating]
					final.venue_three += [x.tips.groups[0].items[1].text]
					final.venue_three += [x.tips.groups[0].items[2].text]
					final.venue_three += [x.tips.groups[0].items[3].text]
					final.venue_three += [x.photos.groups[0].items[0].prefix + "400x400" + x.photos.groups[0].items[0].suffix]
					final.venue_three += [x.photos.groups[0].items[1].prefix + "400x400" + x.photos.groups[0].items[1].suffix]
					final.venue_three += [x.photos.groups[0].items[2].prefix + "400x400" + x.photos.groups[0].items[2].suffix]
					final.venue_three += [x.photos.groups[0].items[3].prefix + "400x400" + x.photos.groups[0].items[3].suffix]
					final.venue_three += [x.photos.groups[0].items[4].prefix + "400x400" + x.photos.groups[0].items[4].suffix]
					final.venue_three += [x.photos.groups[0].items[5].prefix + "400x400" + x.photos.groups[0].items[5].suffix]
					final.save
				end
			end
		end 

		final.final_result += final.venue_one
		final.final_result += final.venue_two
		final.final_result += final.venue_three

		final.save

		# matched_restaurants = arr.select {|restaurant| restaurant.price && restaurant.price.tier == api_params_arr[2] }
		
		render 'show'	

	end

	def top_rest
		survey = Survey.find_by(uniqueid: params[:uniqueid])
		
		render json:
		{
			:venueOne => survey.final_result[0],
			:venueOnePrice => survey.final_result[1],
			:venueOneRating => survey.final_result[2],
			:venueOneAddress => survey.final_result[3],
			:venueOneTip1 => survey.final_result[4],
			:venueOneTip2 => survey.final_result[5],
			:venueOneTip3 => survey.final_result[6],
			:venueOnePhoto1 => survey.final_result[7],
			:venueOnePhoto2 => survey.final_result[8],
			:venueOnePhoto3 => survey.final_result[9],
			:venueOnePhoto4 => survey.final_result[10],
			:venueOnePhoto5 => survey.final_result[11],
			:venueOnePhoto6 => survey.final_result[12],

			:venueTwo => survey.final_result[13],
			:venueTwoPrice => survey.final_result[14],
			:venueTwoRating => survey.final_result[15],
			:venueTwoAddress => survey.final_result[16],
			:venueTwoTip1 => survey.final_result[17],
			:venueTwoTip2 => survey.final_result[18],
			:venueTwoTip3 => survey.final_result[19],
			:venueTwoPhoto1 => survey.final_result[20],
			:venueTwoPhoto2 => survey.final_result[21],
			:venueTwoPhoto3 => survey.final_result[22],
			:venueTwoPhoto4 => survey.final_result[23],
			:venueTwoPhoto5 => survey.final_result[24],
			:venueTwoPhoto6 => survey.final_result[25],


			:venueThree => survey.final_result[26],
			:venueThreePrice => survey.final_result[27],
			:venueThreeRating => survey.final_result[28],
			:venueThreeAddress => survey.final_result[29],
			:venueThreeTip1 => survey.final_result[30],
			:venueThreeTip2 => survey.final_result[31],
			:venueThreeTip3 => survey.final_result[32],
			:venueThreePhoto1 => survey.final_result[33],
			:venueThreePhoto2 => survey.final_result[34],
			:venueThreePhoto3 => survey.final_result[35],
			:venueThreePhoto4 => survey.final_result[36],
			:venueThreePhoto5 => survey.final_result[37],
			:venueThreePhoto6 => survey.final_result[38],
		}
		
	end

	def crunchtwo
		@uniqueid = params[:uniqueid]
		gon.uniqueid = @uniqueid
		@survey1 = false
		@survey2 = true
		@survey3 = false
		@info = Survey.find_by(uniqueid: params[:uniqueid])
		final_venue = Survey.find_by(uniqueid: params[:uniqueid])
		
		final_venue.restaurant += [params[:responsetwo][:restaurant]]

		final_venue.save

		if final_venue.save
			@survey3 = true
			@survey2 = false
			@survey1 = false
		else
			render 'show'
		end

		render 'show'
	
	end


	def top_rest_two

		final_venue = Survey.find_by(uniqueid: params[:uniqueid])

		if final_venue.restaurant && final_venue.restaurant.length == final_venue.people

		freq1 = final_venue.restaurant.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
		group = freq1.group_by{ |k,v| v }.each_with_object({}) { |(k,v), h| h[v.map(&:first).join(',')] = k }
		pick = group.max_by { |k,v| v }
		pick_first = pick.first.split(",")
		mode11 = pick_first.sample


			if mode11 == "venueone"
				render json:
				{
					:venue => final_venue.venue_one[0],
					:venuePrice => final_venue.venue_one[1],
					:venueRating => final_venue.venue_one[2],
					:venueAddress => final_venue.venue_one[3],
					:venueTip1 => final_venue.venue_one[4],
					:venueTip2 => final_venue.venue_one[5],
					:venueTip3 => final_venue.venue_one[6],
					:venuePhoto1 => final_venue.venue_one[7],
					:venuePhoto2 => final_venue.venue_one[8],
					:venuePhoto3 => final_venue.venue_one[9],
					:venuePhoto4 => final_venue.venue_one[10],
					:venuePhoto5 => final_venue.venue_one[11],
					:venuePhoto6 => final_venue.venue_one[12],	
				}
			elsif mode11 == "venuetwo"
				render json:
				{
					:venue => final_venue.venue_two[0],
					:venuePrice => final_venue.venue_two[1],
					:venueRating => final_venue.venue_two[2],
					:venueAddress => final_venue.venue_two[3],
					:venueTip1 => final_venue.venue_two[4],
					:venueTip2 => final_venue.venue_two[5],
					:venueTip3 => final_venue.venue_two[6],
					:venuePhoto1 => final_venue.venue_two[7],
					:venuePhoto2 => final_venue.venue_two[8],
					:venuePhoto3 => final_venue.venue_two[9],
					:venuePhoto4 => final_venue.venue_two[10],
					:venuePhoto5 => final_venue.venue_two[11],
					:venuePhoto6 => final_venue.venue_two[12],	
				}
			elsif mode11 == "venuethree"
				render json:
				{
					:venue => final_venue.venue_three[0],
					:venuePrice => final_venue.venue_three[1],
					:venueRating => final_venue.venue_three[2],
					:venueAddress => final_venue.venue_three[3],
					:venueTip1 => final_venue.venue_three[4],
					:venueTip2 => final_venue.venue_three[5],
					:venueTip3 => final_venue.venue_three[6],
					:venuePhoto1 => final_venue.venue_three[7],
					:venuePhoto2 => final_venue.venue_three[8],
					:venuePhoto3 => final_venue.venue_three[9],
					:venuePhoto4 => final_venue.venue_three[10],
					:venuePhoto5 => final_venue.venue_three[11],
					:venuePhoto6 => final_venue.venue_three[12],	
				}
			end

		end


	end


end