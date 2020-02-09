FactoryBot.define do
  factory :note do
    title { 'Note Title' }
    text { 'Note text' }
    user
  end
end
