class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.text :har
      t.float :loadtime
      t.float :startrender
      t.integer :requests
      t.float :fullyloaded
      t.string :status
      t.string :webpagetestid
      t.integer :page_id
      t.belongs_to :pages
      t.timestamps
    end
  end
end
