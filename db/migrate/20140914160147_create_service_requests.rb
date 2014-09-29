class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.timestamp :creation_date
      t.integer :ward
      t.string :call_description
      t.string :call_type
      t.string :maintenance_yard
      t.string :priority_name

      t.timestamps
    end
  end
end
