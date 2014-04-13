require 'spec_helper'

feature 'Visitor creates a tournament' do
  let!(:city)       { create :city }
  let!(:tournament) { attributes_for :tournament, begins_at: 5.days.from_now, city: city }

  scenario 'with proper data', js: true do
    visit city_path city
    click_on "J'organise un tournois"
    fill_in "Votre adresse email",          with: tournament[:organizer_email]
    fill_in "Votre pseudo",                 with: tournament[:organizer_alias]
    fill_in "Nom du tournois",              with: tournament[:name]
    fill_in "Adresse du tournois",          with: tournament[:address]
    fill_in "Date et heure de début",       with: tournament[:begins_at]
    fill_in "Date et heure de fin",         with: tournament[:ends_at]
    fill_in "Nombre de places",             with: tournament[:places]
    fill_in "Informations sur le tournois", with: tournament[:abstract]
    click_on "Créer mon tournois"
    expect(page).to have_content("Un email de validation vous a été envoyé. Cliquez sur le lien qu'il contient pour activer votre tournois.")
  end

  scenario 'with invalid data', js: true do
    visit city_path city
    click_on "J'organise un tournois"
    fill_in "Votre adresse email",          with: tournament[:organizer_email]
    fill_in "Votre pseudo",                 with: tournament[:organizer_alias]
    fill_in "Nom du tournois",              with: tournament[:name]
    fill_in "Adresse du tournois",          with: tournament[:address]
    fill_in "Date et heure de début",       with: 'This is not a proper date, now, is it ?'
    fill_in "Date et heure de fin",         with: tournament[:ends_at]
    fill_in "Nombre de places",             with: tournament[:places]
    fill_in "Informations sur le tournois", with: tournament[:abstract]
    click_on "Créer mon tournois"
    expect(page).to have_selector '.input.tournament_begins_at.error'
  end
end
