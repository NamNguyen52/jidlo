class AddLatLngToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :latitude, :float
    add_column :surveys, :longitude, :float
  end
end
