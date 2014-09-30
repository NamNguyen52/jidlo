class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.string :location
      t.string :q1, array: true, default: []
      t.string :q2, array: true, default: []
      t.string :q3, array: true, default: []
      t.string :q4, array: true, default: []
      t.integer :people
      t.string :uniqueid
      t.string :restaurants, array: true, default: []

      t.timestamps
    end
  end
end
