class CreateBalances < ActiveRecord::Migration[5.2]
  def change
    create_table :balances do |t|
      t.references :movement, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer    :balance, null: false

      t.datetime :created_at, null: false
    end
  end
end
