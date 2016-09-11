class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :urls
      t.string :schedule
      t.string :location
      t.datetime :startdate
      
      t.timestamps
    end
  end
end
