require "HTTParty"
require "json"

username = ENV['SCRAPE_UN']
pass = ENV['SCRAPE_PW']
url = ENV['SCRAPE_URL']

auth = {:username => username, :password => pass}
r = HTTParty.get(url, :basic_auth => auth)


open('testOutput.txt', 'w') { |f|
  f.puts r
}

starting_line = 0
end_line = 0
app_ids = []

array_of_file = File.readlines("testOutput.txt") 

array_of_file.each_with_index do |item, index|
  
  if item.include?('dataSource')
		starting_line = index 
	elsif item.include?('.render')
		end_line = index 
	end
end

File.open("reduced.txt", "w+") do |f|
	i = starting_line
	until i == end_line -1
  		f.puts(array_of_file[i])
  		i += 1
	end
end

replace_line =File.readlines('reduced.txt')
replace_line[0] = '{'

open('data.json', 'w') { |f|
	f.puts replace_line
	}

json_data = File.read('data.json')

data_hash = JSON.parse(json_data)

deeper = data_hash['dataset']
for x in deeper
	current_id = x['seriesname'].chomp
	clean_app_id = current_id.split(' ')
	app_ids.push(clean_app_id.first)
end

puts app_ids
