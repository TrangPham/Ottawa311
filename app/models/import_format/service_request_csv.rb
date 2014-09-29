module ImportFormat
  class ServiceRequestCSV
    extend Conformist

    column :creation_date do |i| 
      if i.scan(/[a-zA-Z]/).empty?
        datetime = i.split(' ')
        date = datetime[0].split('/')
        year = date[2].to_i
        month = date[0].to_i
        day = date[1].to_i

        time = datetime[1].split(':')
        hour = time[0].to_i
        minutes = time[1].to_i
        seconds = 0

        timezone = '-5' #EST
        DateTime.new(year, month, day, hour, minutes, seconds, timezone)
      else
        DateTime.parse(i + " EST")
      end
    end
    column :ward do |i| 
      (i || '').scan(/\d/).join('').to_i
    end
    column :call_description do |i| 
      (i || '').downcase
    end
    column :call_type  do |i| 
      (i || '').downcase
    end
    column :maintenance_yard  do |i| 
      (i || '').downcase
    end
  end
end