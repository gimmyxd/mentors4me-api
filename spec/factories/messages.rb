FactoryGirl.define do
  factory :message do
    chat_id 1
    sender 'MyString'
    receiver 'MyString'
    message 'MyText'
  end
end
