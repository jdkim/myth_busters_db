class Collection < ApplicationRecord
	belongs_to :language
	belongs_to :script
	has_many :articles, :dependent => :destroy

	def self.as_csv
		CSV.generate do |csv|
			csv << ["name", "authors", "source_language", "language", "script", "updated_at"]
			all.each do |item|
				csv << [item.label, item.authors, item.source, item.language.label, item.script.label, item.updated_at]
			end
		end
	end

	def empty!
		articles.destroy_all
	end
end
