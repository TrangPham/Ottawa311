json.set! :title, @results[:title]
json.set! :total, @results[:total]

json.set! :select do
  @results[:select].each do |k, v|
    json.set! k, v
  end
end

json.set! :results do 
  json.array! @results[:results] do |r|
    json.group r[:group]
    json.columns r[:columns] do |kv|
      json.array! kv
    end
  end
end