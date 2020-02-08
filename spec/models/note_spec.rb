require 'rails_helper'

RSpec.describe Note, type: :model do
  context 'validations' do
    subject { build(:note) }

    it { should validate_length_of(:title).is_at_most(30) }
    it { should validate_length_of(:text).is_at_most(1000) }
  end

  context 'before_validation' do
    let(:note) { Note.new(title: '', text: 'text') }
    let(:note2) { Note.new(title: '', text: '') }
    it 'assign first 30 characters of text to title' do
      expect(note.valid?).to eq true
      expect(note.title).to eq note.text[0..29]
    end

    it 'raise validation error when text and title both are empty' do
      expect(note2.valid?).to eq false
    end
  end

  context '.search' do
    let!(:note) { create(:note, title: 'Random') }
    let!(:note2) { create(:note, title: 'title', text: 'Random 123') }
    let!(:note3) { create(:note, title: 'new one', text: 'new text') }

    it 'returns notes which have search word in title or text' do
      notes = Note.search('random')
      expect(notes).to include(note, note2)
      expect(notes).not_to include(note3)
    end
  end

  context 'default scope' do
    let(:note) { create(:note) }
    let!(:note2) { create(:note) }

    it 'get records in descending order of update_at' do
      note.save
      notes = Note.all
      expect(notes.first).to eq note
      expect(notes.last).to eq note2
    end
  end
end
