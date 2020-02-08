class NotesController < ApplicationController
  before_action :assign_note, only: %i[update edit destroy]
  def index
    @notes = if params[:search_field]
               Note.search(params[:search_field])
             else
               Note.all
             end
    @notes = @notes.paginate(page: params[:page], per_page: 10)
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      flash[:success] = 'Note successfully created'
      redirect_to notes_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @note.update(note_params)
      flash[:success] = 'Note successfully updated'
      redirect_to notes_path
    else
      render :edit
    end
  end

  def destroy
    if @note.destroy
      flash[:success] = 'Note has been deleted'
    else
      flash[:danger] = 'Note could not be deleted'
    end
    redirect_to notes_path
  end

  private

  def note_params
    params.require(:note).permit(:title, :text)
  end

  def assign_note
    @note = Note.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:warning] = 'Record Not Found'
    redirect_to notes_path
  end
end
