class ArticlesController < ApplicationController
	protect_from_forgery
	before_action :set_article, only: [:show, :edit, :update, :destroy]

	# GET /collections
	# GET /collections.json
	def index
		articles = Article.all

		respond_to do |format|
			format.html
			format.json { render json: articles.as_json }
			format.csv  { send_data articles.as_csv, filename: 'Myth_busters_translations.csv'}
		end
	end

	# GET /articles/1
	# GET /articles/1.json
	def show
		if @article.nil?
			redirect_to article_path(25)
		end
	end

	# GET /articles/new
	def new
		@article = Collection.new
	end

	# GET /articles/1/edit
	def edit
	end

	# POST /articles
	# POST /articles.json
	def create
		respond_to do |format|
			if @article.save
				format.html { redirect_to @article, notice: 'Collection was successfully created.' }
				format.json { render :show, status: :created, location: @article }
			else
				format.html { render :new }
				format.json { render json: @article.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /articles/1
	# PATCH/PUT /articles/1.json
	def update
		respond_to do |format|
			if @article.update(article_params)
				format.html { redirect_to @article, notice: 'Collection was successfully updated.' }
				format.json { render :show, status: :ok, location: @article }
			else
				format.html { render :edit }
				format.json { render json: @article.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /articles/1
	# DELETE /articles/1.json
	def destroy
		@article.destroy
		respond_to do |format|
			format.html { redirect_to articles_url, notice: 'Collection was successfully destroyed.' }
			format.json { head :no_content }
		end
	end


	private
		# Use callbacks to share common setup or constraints between actions.
		def set_article
			@article = params.has_key?(:id) ? Article.find(params[:id]) : nil
		end

		# Only allow a list of trusted parameters through.
		def article_params
			params.require(:article).permit(:label, :source, :language_id, :script_id).
				merge(authors: (params.dig(:language, :authors).presence || '').split(/ *, */))
		end
end
