class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :schedule
      t.datetime :runtime
      t.string :url
      t.belongs_to :jobs
      t.integer :project_id
      t.string :status
      t.timestamps
    end
  end
end
