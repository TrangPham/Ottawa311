class AddSource < ActiveRecord::Migration
  def change
    remove_column :service_requests, :priority_name
    add_column :service_requests, :source, :string
  end
end
