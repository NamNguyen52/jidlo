require 'rails_helper'


RSpec.describe SurveysController, :type => :controller do

  let :valid_attributes do
      {
        :name => "pooja",
        :location => "Santa Monica, CA",
        :people => 1,
        :uniqueid => 'uishdjis'
      }
  end


	describe "GET index" do
    it "returns http success" do
    	get :index      
    	expect(response).to be_success
    end
    it "renders the index template" do
    	get :index
    	expect(response).to render_template :index
    end
  end

  describe "POST create" do
    it "returns http success" do
      post :index      
      expect(response).to be_success
    end
  end

  describe "GET show" do
    it "routes to the show page" do
      expect(:get => '/survey_link/:uniqueid').
      to route_to(:controller => "surveys", :action => "show", "uniqueid"=>":uniqueid")
    end
  end

  describe "GET top_rest" do
    it "routes to the venue option page" do
      expect(:get => '/api/:uniqueid/restaurants/top').
      to route_to(:controller => "surveys", :action => "top_rest", "uniqueid"=>":uniqueid")
    end
  end

   describe "GET top_rest_two" do
    it "routes to the final venue page" do
      expect(:get => '/api/:uniqueid/restaurants/toptwo').
      to route_to(:controller => "surveys", :action => "top_rest_two", "uniqueid"=>":uniqueid")
    end
  end

  describe 'create' do
    it 'should add name to Survey' do
      survey = Survey.new(name: "Pooja", location: 'Santa Monica, CA', people: 2)
      expect(survey.name).to eq("Pooja")
    end
  end


    

end
