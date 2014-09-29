class AddMonth < ActiveRecord::Migration
  def change
    add_column :service_requests, :month, :string
  end
end
