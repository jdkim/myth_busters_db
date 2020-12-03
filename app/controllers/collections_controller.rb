class CollectionsController < ApplicationController
	protect_from_forgery
	before_action :set_collection, only: [:show, :edit, :update, :destroy]

	autocomplete :language, :label
	autocomplete :script, :label

	# GET /collections
	# GET /collections.json
	def index
		@collections = Collection.all

		respond_to do |format|
			format.html
			format.json { render json: @collections.as_json }
			format.csv  { send_data @collections.as_csv, filename: 'Myth_busters_translations_meta.csv'}
		end
	end

	def pairs
		lid1 = params[:lang1] || 'eng-eng'
		@collections = Collection.where(lid:lid1)
	end

	# GET /collections/1
	# GET /collections/1.json
	def show
		if @collection.nil?
			redirect_to collection_path(25)
		end
		respond_to do |format|
			format.html
			format.json { render json: @collection.as_json }
			format.csv  { send_data @collection.as_csv, filename: "Myth_busters_translations_meta_#{@collection.label}.csv"}
		end
	end

	# GET /collections/new
	def new
		@collection = Collection.new
	end

	# GET /collections/1/edit
	def edit
		@collection.authors = @collection.authors.join(', ')
	end

	# POST /collections
	# POST /collections.json
	def create
		@collection = Collection.new(collection_params)

		respond_to do |format|
			if @collection.save
				format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
				format.json { render :show, status: :created, location: @collection }
			else
				format.html { render :new }
				format.json { render json: @collection.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /collections/1
	# PATCH/PUT /collections/1.json
	def update
		respond_to do |format|
			if @collection.update(collection_params)
				format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
				format.json { render :show, status: :ok, location: @collection }
			else
				format.html { render :edit }
				format.json { render json: @collection.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /collections/1
	# DELETE /collections/1.json
	def destroy
		@collection.destroy
		respond_to do |format|
			format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	def upload_dialog
	end

	def upload_languages
		tempfile = params[:file].tempfile.path
		filename = params[:file].original_filename
		CSV.foreach(tempfile).with_index do |row, i|
			next if i == 0 || i == 1

			check, lname, lname_var, autonym, autonym_rep, g, source, lcode, n, sname, scode, translator, n, wikipedia = row
			sname ||= 'Latin'
			scode ||= 'Latn, 215'

			lname_var ||= ''
			lnames = lname_var.split(', ')
			lnames.uniq!

			autonym ||= ''
			autonyms = autonym.split(' / ')
			if autonym_rep.present?
				autonyms.unshift(autonym_rep)
				autonyms.uniq!
			end

			language = if lan = Language.find_by_label(lname)
				lan
			else
				lan = Language.new(iso639_3:lcode, label:lname, autonyms:autonyms, glossonyms:lnames, reference:wikipedia)	
				lan.save
				lan
			end

			script = if _script = Script.find_by_label(sname)
				_script
			else
				_script = Script.new(iso15924:scode, label:sname)
				_script.save
				_script
		end

			translator ||= ''
			authors = translator.split(', ')

			collection = Collection.new(label:lname, authors:authors, language_id:language.id, script_id:script.id)
			collection.save
		end
	end

	def upload_articles
		tempfile = params[:file].tempfile.path

		filename = params[:file].original_filename
		clabel = File.basename(filename, ".xlsx.csv")
		collection = Collection.where(label: clabel).first
		collection.empty!

		CSV.foreach(tempfile).with_index do |row, i|
			next if i == 0

			number, title, native_number = row

			article = Article.new(collection_id:collection.id, number:number, native_number:native_number, title:title)
			article.save
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_collection
			@collection = params.has_key?(:id) ? Collection.find(params[:id]) : nil
		end

		# Only allow a list of trusted parameters through.
		def collection_params
			params.require(:collection).permit(:label, :source, :language_id, :script_id).
				merge(authors: (params.dig(:collection, :authors).presence || '').split(/ *, */))
		end
end
