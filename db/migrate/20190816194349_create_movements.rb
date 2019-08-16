class CreateMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :movements do |t|
      t.integer :amount
      t.datetime :datetime
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
