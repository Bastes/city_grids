# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  city_names = %w(Amiens Angers Annecy Bordeaux Grenoble Le Mans Lille-Valenciennes Limoges Lyon LorLux Montpellier Orléans Paris Rennes Strasbourg Tours)

  factory :city do
    sequence(:name) { |n| "#{city_names.sample} ##{n}" }
    email           'uninteresting@email.com'
    activated       true

    trait(:pending)   { activated false }
    trait(:activated) { activated true }
  end
end
