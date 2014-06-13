class Room < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :title, :location, :description

	scope :most_recent, -> { order('created_at DESC') }

	def complete_name
		"#{title}, #{location}"
	end
end
