class ServiceRequest < ActiveRecord::Base
  validate :creation_date, presence: :true
  validate :month, presence: :true
end
