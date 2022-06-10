class CreateNggovchecks < ActiveRecord::Migration[6.1]
  def change
    create_table :nggovchecks do |t|
      t.string :user
      t.string :phone
      t.string :bvn
      t.string :bvn_name
      t.string :bvn_phone
      t.string :bvn_dob

      t.timestamps
    end
  end
end

# rails generate model Nggovcheck user:string phone:string bvn:string bvn_phone:string bvn_dob:string
