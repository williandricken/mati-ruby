class CreateWebhooks < ActiveRecord::Migration[6.1]
  def change
    create_table :webhooks do |t|
      t.text :data

      t.integer :identity_id, index: true, foreign_key: true
      t.timestamps
    end
  end
end
