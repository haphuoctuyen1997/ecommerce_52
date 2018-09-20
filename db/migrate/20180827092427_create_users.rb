class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password, null: false, default: ""
      t.string :address
      t.string :phone
      t.integer :role, null: false, default: 0
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.timestamps
    end
  add_index :users, :email, unique: true
  end
end
