class NoteMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.note_mailer.note_notification.subject
  #
  def create_notification(note)
    @user = note.user
    @note = note
    mail to: @user.email, subject: 'Note Created'
  end

  def update_notification(old_title, old_text, new_note)
    @user = new_note.user
    @note = new_note
    @old_title = old_title
    @old_text = old_text
    mail to: @user.email, subject: 'Note Updated'
  end

  def destroy_notification(note)
    @user = note.user
    @note = note
    mail to: @user.email, subject: 'Note Deleted'
  end
end
