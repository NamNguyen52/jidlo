require 'rails_helper'

RSpec.describe SurveysController, :type => :controller do

	describe "GET index" do
      it "returns http success" do
      	get :index      
      	expect(response).to have_http_status(:success)
      end

      it "renders the index template" do
      	get :index
      	expect(response).to render_template("index")
      end

    end

 


  # describe 'GET /survey_link/:uniqueid' do
  # 	it "should show the survey given the uniqueid" do
  # 	  get :show, uniqueid: 'jsikyxvm'
  # 	  @survey = assigns[:survey]
  # 	  expect(@survey).to be_a(Survey)	
  # 	end
  # end

end