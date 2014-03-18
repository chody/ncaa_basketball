require 'nokogiri'
require 'open-uri'

# establish database connection
load "#{File.dirname(__FILE__)}/database.rb"
Database.connect_to ARGV[0]

class Team < ActiveRecord::Base
	self.table_name = "teams"
end

class Conference < ActiveRecord::Base
	self.table_name = "conferences"
end

url = 'http://espn.go.com/ncb/standings'
doc = Nokogiri::HTML(open(url))
title = doc.at_css('title').text

doc.css("table.tablehead").each do |html|
	index = 0
	team = nil
	overall_record = nil
	conference_teams = []
	html.css("td").each do |data|
		if  !data.text.include?("TEAM") && !data.text.include?("CONF") && !data.text.include?("OVERALL") && !data.text.include?("WEST") && !data.text.include?("EAST") && !data.text.include?("NORTH") && !data.text.include?("SOUTH")
			if index == 0
				team = data.text
				if team != "Expanded Standings"
					conference_teams << team
				end
			end

			if index == 2
				overall_record = data.text
			end

			index += 1

			if index == 3 || data.text.include?("Expanded Standings")
				wins = nil
				losses = nil

				record_array = overall_record.split("-")
					wins = record_array.first
					losses = record_array.last


				if team != "Expanded Standings"
					current_team = Team.find_by_name(team)

					if !current_team
						Team.create(:name => team,
									:last_year_wins => wins,
									:last_year_losses => losses)
					end
				end
				index = 0
			end

			if data.text.include?("Expanded Standings")
				conference_url = data.css("a")
				conference_match = /\/\d{4,}\/([^"]*)/.match(conference_url.to_s)
				conference_string = conference_match[0][6..-1]
				conference = ""
				conference_array = conference_string.split("-")
				conference_array.each_with_index  do |val, x|
					if x !=  conference_array.index(conference_array.last)
						conference += "#{val.upcase} "
					end
				end

				conference = conference[0..-2]

				current_conference = Conference.find_by_name(conference)

				if !current_conference
					current_conference = Conference.create(:name => conference)
				end

				conference_teams.each do |conf_team|
					current_team = Team.find_by_name(conf_team)
					current_team.update_attributes(:conference_id => current_conference.id)
				end
			end

		end
	end
end

