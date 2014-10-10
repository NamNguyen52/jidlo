class AddNumbersToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :numbers, :string
  end
end
