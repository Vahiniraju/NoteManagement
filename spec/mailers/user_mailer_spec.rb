require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  context 'account_activation' do
    let!(:user) { create(:user, reset_token: 'random') }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Account activation')
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('activate your account:')
    end
  end

  context 'password_reset' do
    let!(:user) { create(:user, reset_token: 'random') }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Password reset')
      expect(mail.to).to eq([user.email])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('To reset your password click the link below:')
    end
  end
end
