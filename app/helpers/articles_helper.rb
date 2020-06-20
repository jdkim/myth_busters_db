module ArticlesHelper

	def list_of_languages
		Article.distinct.pluck(:lcode, :scode).map{|l,s| "#{l}-#{s}"}
	end

	def lang1
		params[:lang1] || 'eng-eng'
	end

	def lang2
		params[:lang2] || 'eng-eng'
	end

	def lang2_codes
		lang2.split('-')
	end

end
