class Collection < ApplicationRecord
	belongs_to :language
	belongs_to :script
	has_many :articles

	def self.as_csv
		CSV.generate do |csv|
			csv << column_names
			all.each do |item|
				csv << item.attributes.values_at(*column_names)
			end
		end
	end

	def empty!
		articles.destroy_all
	end
end
