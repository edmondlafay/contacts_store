# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

event_names = ['visited a page', 'filled a form']
known_event_names = Event.pluck(:name)
(event_names-known_event_names).each{ |name| Event.create(name: name) }

Contact.create(email: "test#{Time.now.to_f}@domaine.fr", first_name: 'test', last_name: 'test', company:'test', events: Event.last(2))
