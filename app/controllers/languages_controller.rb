class LanguagesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :edit, :create, :update]
	before_action :set_language, only: [:show, :edit, :update, :destroy]

	def index
		@languages = Language.all

		respond_to do |format|
			format.html
			format.json { render json: @languages.as_json }
			format.csv  { send_data @languages.as_csv, filename: 'Myth_busters_languages.csv'}
		end
	end

	def show
	end

	def new
		@language = Language.new
	end

	def edit
		@language.autonyms = @language.autonyms.join(', ')
		@language.glossonyms = @language.glossonyms.join(', ')
	end

	def create
		@language = Language.new(language_params)

		respond_to do |format|
			if @language.save
				format.html { redirect_to @language }
			else
				format.html { redirect_to languages_path, notice: "Creation of a language failed." }
			end
		end
	end

	def update
		respond_to do |format|
			if @language.update_attributes(language_params)
				format.html { redirect_to @language, notice: "The language, #{@language.label}, is successfuly updated."}
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @language.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		if @language.collections.empty?
			@language.destroy! 
			redirect_to languages_path, notice: "The language, #{@language.label}, was deleted."
		else
			redirect_to @language, notice: 'Could not delete it, due to the existing translation(s)'
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_language
			@language = params.has_key?(:id) ? Language.find(params[:id]) : nil
		end

		# Only allow a list of trusted parameters through.
		def language_params
			params.require(:language).permit(:iso639_3, :label, :autonyms, :glossonyms, :reference)
		end

		# Only allow a list of trusted parameters through.
		def language_params
			params.require(:language).permit(:iso639_3, :label, :reference).
				merge(autonyms: (params.dig(:language, :autonyms).presence || '').split(/ *, */)).
				merge(glossonyms: (params.dig(:language, :glossonyms).presence || '').split(/ *, */))
		end


end
