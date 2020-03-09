require 'csv'

class State < ApplicationRecord
	def self.to_csv
		attributes = %w{name tested positive deaths}
		CSV.generate(headers: true) do |csv|
			csv << attributes
			all.find_each do |st|
				csv << attributes.map{ |attr| st.send(attr) }
			end
		end
	end
end
