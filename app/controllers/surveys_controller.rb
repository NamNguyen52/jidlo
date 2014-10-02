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

	def prep_crunch
		q1 = params[:response][:question1]
		q2 = params[:response][:question2]
		q3 = params[:response][:question3]
		uniqueid = params[:uniqueid]
		
		do_crunch(q1,q2,q3,uniqueid)

		render 'show'
	end
end
