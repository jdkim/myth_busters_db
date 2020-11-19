class Article < ApplicationRecord
	belongs_to :collection
	
	def self.as_csv
		CSV.generate do |csv|
			csv << ["collection_name", "number", "translation"]
			all.order(:collection_id, :number).each do |item|
				csv << [item.collection.label, item.number, item.title]
			end
		end
	end
end
