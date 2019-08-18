# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

return if User.any?

5.times do |i|
  u = User.create(name: "Vasya #{i}")
  5.times do |j|
    u.movements.create(user: u, datetime: Time.now, amount: rand(-100..100))
  end
end
