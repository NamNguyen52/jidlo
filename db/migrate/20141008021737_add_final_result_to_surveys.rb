class AddFinalResultToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :final_result, :string, array: true, default: []
  end
end
