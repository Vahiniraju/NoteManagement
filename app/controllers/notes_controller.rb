class NotesController < ApplicationController
  before_action :assign_note, only: %i[update edit destroy]
  before_action :logged_in_user
  before_action :authorize_user, only: %i[edit update destroy]

  def index
    @notes = if params[:search_field]
               current_user.notes.search(params[:search_field])
             else
               current_user.notes.all
             end
    @notes = @notes.paginate(page: params[:page], per_page: 10)
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      NoteMailer.create_notification(@note).deliver_later if current_user.mailable?
      flash[:success] = 'Note successfully created'
      redirect_to notes_path
    else
      render :new
    end
  end

  def edit; end

  def update
    old_title = @note.title
    old_text = @note.text
    if @note.update(note_params)
      NoteMailer.update_notification(old_title, old_text, @note).deliver_later if current_user.mailable?
      flash[:success] = 'Note successfully updated'
      redirect_to notes_path
    else
      render :edit
    end
  end

  def destroy
    if @note.destroy
      NoteMailer.destroy_notification(@note).deliver_later if current_user.mailable?
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

  def logged_in_user
    return if logged_in?

    remember_location
    flash[:danger] = 'Please log in.'
    redirect_to login_path
  end

  def authorize_user
    return unless logged_in?

    return if current_user.notes.where(id: params[:id]).present?

    flash[:danger] = 'You are not authorized for this action'
    redirect_to notes_path
  end
end
