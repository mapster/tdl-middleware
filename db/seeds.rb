# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create({name: 'Alexander Hoem Rosbach', email: 'alexander@rosbach.no', password: '123123', password_confirmation: '123123'})
admin_auth = UserAuthorization.create({user_id: admin.id, manage_exercises: true, manage_users: true, manage_authorizations: true})

if Rails.env == "development"
  exercise1 = Exercise.create({
                                  name: 'exercise1',
                                  title: 'Exercise1',
                                  kind: 'expectation',
                                  difficulty: 3,
                                  description: 'Bla bla',
                              })
  SourceFile.create({name: 'File.java', contents: 'noe tekst', source_set: exercise1})
  SourceFile.create({name: 'File2.java', contents: 'annen tekst', source_set: exercise1})
end
