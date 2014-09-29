json.array!(@service_requests) do |service_request|
  json.extract! service_request, :id, :creation_date, :ward, :call_description, :call_type, :maintenance_yard, :source
  json.url service_request_url(service_request, format: :json)
end
