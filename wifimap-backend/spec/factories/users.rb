FactoryGirl.define do
  factory :user do |user|
    user.email "user@test.com"
    user.password "password123"
    user.admin false
  end

  factory :admin_user, class: User do |user|
    user.email "admin@test.com"
    user.password "password123"
    user.admin true
  end
end
