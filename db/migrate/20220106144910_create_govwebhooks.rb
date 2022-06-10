class CreateGovwebhooks < ActiveRecord::Migration[6.1]
  def change
    create_table :govwebhooks do |t|
      t.text :data
      
      t.integer :nggovcheck_id, index: true, foreign_key: true
      t.timestamps
    end
  end
end
