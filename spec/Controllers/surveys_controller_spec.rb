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





describe "GET show" do

      it "returns http success" do
        get :show      
        expect(response).to be_success
      end

end








describe 'create' do
    it 'should add name to Survey' do
      survey = Survey.new(name: "Pooja", location: 'Santa Monica, CA', people: 2)
      expect(survey.name).to eq("Pooja")
    end
end


    







  describe 'GET /survey_link' do
      it "should show the survey given the uniqueid" do
      get :show, uniqueid: 'kupdwfav'
      @survey = assigns[:survey]
      expect(@survey).to be_a(Survey) 
      end
  end



  describe 'GET /api/:uniqueid/restaurants/top' do

    it 'creates a resource' do
    expect(response).to assign_to(:venueOne)
    end
  end





end
