class AddSurveyTwoToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :survey2, :string, array: true, default: []
  end
end
