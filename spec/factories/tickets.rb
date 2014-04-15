# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  nickname_prefixes = %w(Roxx Kick Dude King Maxx Fonz Big Super Bad)
  nickname_suffixes = %w(ozor fucker ass ness zog czyk shlokh ical)
  factory :ticket do
    sequence(:email)    { |n| "another-fake-email-#{n}@nowhere.com" }
    sequence(:nickname) { |n| "#{nickname_prefixes.sample}#{nickname_suffixes.sample} ##{n}" }
    tournament
  end
end
