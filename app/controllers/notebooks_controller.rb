class NotebooksController < ApplicationController
  before_action :set_notebook, only: [:show, :edit, :update, :destroy]

  def index
    @notebooks = Notebook.all.order("updated_at desc")
  end

  def show
    @notes = Note.where(notebook_id: 1).order('updated_at desc')
  end

  def new
    @notebook = Notebook.new
  end

  def edit
  end

  def create
    notebook_params.merge(user_id: 1)
    @notebook = Notebook.new(notebook_params)

    respond_to do |format|
      if @notebook.save
        format.html { redirect_to notebooks_path, notice: 'Notebook was successfully created.' }
        format.json { render action: 'show', status: :created, location: @notebook }
      else
        format.html { render action: 'new' }
        format.json { render json: @notebook.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @notebook.update(notebook_params)
        format.html { redirect_to @notebook, notice: 'Notebook was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @notebook.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notebook.destroy
    respond_to do |format|
      format.html { redirect_to notebooks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notebook
      @notebook = Notebook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notebook_params
      params.require(:notebook).permit(:title, :user_id)
    end
end
