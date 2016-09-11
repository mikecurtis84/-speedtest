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
      t.belongs_to :pages, index: true
      t.timestamps
    end
  end
end
