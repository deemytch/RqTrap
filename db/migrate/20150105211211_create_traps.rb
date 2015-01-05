class CreateTraps < ActiveRecord::Migration
  def change
    create_table :traps do |t|
      t.string :trap_name, index: true, unique: true
      t.string :comment

      t.timestamps null: false
    end
  end
end
