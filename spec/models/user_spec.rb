require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  context 'validations' do
    subject { build(:user) }

    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_length_of(:last_name).is_at_most(50) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_length_of(:password).is_at_least(8) }
    it { should have_many(:notes) }
  end

  it 'remember should update remember_token' do
    user.remember
    expect(user.remember_digest.present?).to eq true
  end

  it 'forget should update remember_token to nil' do
    user.remember_digest = 'dsfsdf'
    user.save!
    user.forget
    expect(user.remember_digest).to eq nil
  end

  it 'sets activation_digest when user is created' do
    expect(user.activation_digest.present?).to eq true
  end

  it 'sets reset_digest' do
    user.create_reset_digest
    expect(user.reset_digest.present?).to eq true
  end

  it 'send email password reset email' do
    user.reset_token = 'token'
    expect { user.send_password_reset_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'send email activation email' do
    user.activation_token = 'token'
    expect { user.send_activation_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'activate to set activate_at' do
    user.activate
    expect(user.activated_at.present?).to eq true
  end
end
