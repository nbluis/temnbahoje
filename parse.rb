require 'date'
require 'json'
require 'yaml'

events = []

File.readlines('datasource.txt').each do |line|

	date_matcher = line.match(/^(\d{2})\/(\d{2}).*/)

	if date_matcher
		day,month = date_matcher.captures
		year = month.to_i > 9 ? 2016 : 2017
		@current_date = Date.new(year, month.to_i, day.to_i)
	else
		data = line.split('–')

		if data.length == 3
			obj = {
				date: @current_date,
				hour: data[0].strip,
				name: data[1].strip,
				channel: data[2].strip
			}
			events << obj
		else
			event_name,event_hour = data[0].match(/([\w\s]+)\(([\w\d]+)\)\s+/).captures
			events << {
				date: @current_date,
				hour: event_hour.strip,
				name: event_name.strip,
				channel: data[1].strip
			}
		end
	end
end

File.write('datasource.json', events.to_json)
File.write('datasource.yaml', events.to_yaml)
