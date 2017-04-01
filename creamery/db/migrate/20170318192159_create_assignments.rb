class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.integer :store_id
      t.integer :employee_id
      t.date :start_date
      t.date :end_date
      t.integer :pay_level

      t.timestamps
    end
  end
end
