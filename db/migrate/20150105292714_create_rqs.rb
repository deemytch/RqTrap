class CreateRqs < ActiveRecord::Migration
  def change
    create_table :rqs do |t|
      t.references :trap, index: true
      t.text :raw_query
      t.json :rq
      t.string :method
      t.string :ip
      t.string :user_agent
      t.text :comment

      t.timestamps null: false
    end
    add_foreign_key :rqs, :traps
  end
end
