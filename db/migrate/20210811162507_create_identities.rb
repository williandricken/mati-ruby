class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.string :verification_id
      t.string :document
      t.boolean :expired
      t.text :flow
      t.string :identity
      t.text :input
      t.text :metadata, null: true
      t.text :step
      t.text :device_fingerprint
      t.boolean :has_problem
      t.timestamps
    end
  end
end
