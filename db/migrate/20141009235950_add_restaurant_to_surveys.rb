class AddRestaurantToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :restaurant, :string, array: true, default: []
  end
end
