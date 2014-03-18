class DraftsController < ApplicationController
	def show
		@available_teams = Team.where(:owner_id => nil)
	end
end
