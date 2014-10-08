class AddThreeVenueArraysToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :venue_one, :string, array: true, default: []
    add_column :surveys, :venue_two, :string, array: true, default: []
    add_column :surveys, :venue_three, :string, array: true, default: []
  end
end
