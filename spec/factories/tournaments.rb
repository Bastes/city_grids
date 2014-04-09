# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  tournament_names = ['Mortal Kombat', 'The King of Iron Fist', 'Street Fighter', 'Bushido Blade', 'Dead or Alive', 'Fatal Fury']

  factory :tournament do
    name                 { tournament_names.sample }
    address              { 'Troll2Jeux, 22 rue Hector Malot, Paris' }
    sequence(:begins_at) { |n| n.days.from_now.to_date + 11.hours }
    sequence(:ends_at)   { |n| n.days.from_now.to_date + 19.hours }
    organizer_email      'someone@somewhere.com'
    organizer_alias      'Kickass Dude'
    places               { rand(4..32) * 2 }
    abstract "The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother's keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who would attempt to poison and destroy My brothers. And you will know My name is the Lord when I lay My vengeance upon thee.\nDo you see any Teletubbies in here? Do you see a slender plastic tag clipped to my shirt with my name printed on it? Do you see a little Asian child with a blank expression on his face sitting outside on a mechanical helicopter that shakes when you put quarters in it? No? Well, that's what you see at a toy store. And you must think you're in a toy store, because you're here shopping for an infant named Jeb.\nNormally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you. But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass."
    city
  end
end
