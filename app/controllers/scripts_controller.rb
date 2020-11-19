class ScriptsController < ApplicationController
	before_action :set_script, only: [:show, :edit, :update, :destroy]

	def index
	end

	def show
	end

	def new
		@script = Script.new
	end

	def edit
	end

	def create
		@script = Script.new(script_params)
		@script.save

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @script }
		end
	end

	def update
		respond_to do |format|
			if @script.update_attributes(script_params)
				format.html { redirect_to @script, notice: "The script, #{@script.label}, is successfuly updated."}
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @script.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		if @script.collections.empty?
			@script.destroy! 
			redirect_to languages_path, notice: "The script, #{script.label}, was deleted."
		else
			redirect_to @script, notice: 'Could not delete it, due to the existing translation(s)'
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_script
			@script = params.has_key?(:id) ? Script.find(params[:id]) : nil
		end

		# Only allow a list of trusted parameters through.
		def script_params
			params.require(:script).permit(:iso15924, :label)
		end
end
