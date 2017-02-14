require 'sinatra'
require 'date'
require 'json'

DATASOURCE = JSON.load(File.read('datasource.json'))

def find_events date
	DATASOURCE.select do |d|
		Date.parse(d['date']) == date
	end
end

get '/' do
	today = Date.today
	today_events = find_events(today)

	ret = "<h1>Hoje é #{today}</h1>"

	if today_events.empty?
		ret += "<h3>Não tem jogo da NBA na TV</h3>"
	else
		ret += "<h3>Tem \n"
		ret += today_events.map do |event| 
			"#{event['name']} ás #{event['hour']} na #{event['channel']}"
		end.reduce do |a, b|
			a + b
		end
		ret += '</h3>'
	end

	ret
end