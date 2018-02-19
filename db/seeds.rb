# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# setup Users
User.create(email: 'svonborries@gmail.com', password: 'leo20032007', password_confirmation: 'leo20032007')
User.create(email: 'bjvtamayo78@gmail.com', password: 'BRANDON10jason', password_confirmation: 'BRANDON10jason')
User.create(email: 'bpdarlyn@gmail.com', password: 'naciel121293', password_confirmation: 'naciel121293')
User.create(email: 'joel@gmail.com', password: 'joel123', password_confirmation: 'joel123')

# setup Offices
Office.create(name: 'AGENCIA SAN MIGUEL', localization: 'AV. MONTENEGRO Nº 1420, EDIF. SAN MIGUEL ARCÁNGEL, ZONA SAN MIGUEL', quantity_of_people: 50)
Office.create(name: 'AGENCIA 20 DE OCTUBRE', localization: 'AV. 20 DE OCTUBRE N° 2095, ESQ. ASPIAZU, ZONA SOPOCACHI', quantity_of_people: 4)
Office.create(name: 'AGENCIA PÉREZ VELASCO', localization: 'AV. MONTES N° 744, ESQ. JOSÉ MARIA SERRANO, ZONA CENTRAL', quantity_of_people: 12)
Office.create(name: 'AGENCIA CAMACHO', localization: 'AV. MONTENEGRO Nº 1420, EDIF. SAN MIGUEL ARCÁNGEL, ZONA SAN MIGUEL', quantity_of_people: 15)
Office.create(name: 'AGENCIA MIRAFLORES', localization: 'AV. HÉROES DEL PACÍFICO N° 1384, CASI ESQ. EE.UU., ZONA MIRAFLORES', quantity_of_people: 7)
Office.create(name: 'AGENCIA ACHUMANI', localization: 'AV. GARCÍA LANZA N° 1484, ESQ. CALLE 13, ZONA ACHUMANI', quantity_of_people: 80)
Office.create(name: 'AGENCIA BUENOS AIRES', localization: 'CALLE TUMUSLA N° 705, ESQ. AV. BUENOS AIRES, ZONA 14 DE SEPTIEMBRE', quantity_of_people: 55)
Office.create(name: 'AGENCIA MEGA CENTER', localization: 'AV. RAFAEL PABÓN, COMPLEJO MEGA CENTER, ZONA IRPAVI', quantity_of_people: 20)
Office.create(name: 'AGENCIA VILLA FÁTIMA', localization: 'AV. DE LAS AMÉRICAS N° 396, ZONA VILLA FÁTIMA', quantity_of_people: 49)
Office.create(name: 'BNB EXPRESS AV. MONTES', localization: 'AV. MONTES N° 616, ESQ. BATALLÓN ILLIMANI, ZONA CENTRAL', quantity_of_people: 75)
Office.create(name: 'BNB EXPRESS LINARES', localization: 'CALLE SANTA CRUZ N° 265, ESQ. LINARES, ZONA CENTRAL', quantity_of_people: 11)
Office.create(name: 'AGENCIA GRAN PODER', localization: 'CALLE SEBASTIAN SEGUROLA N° 1050, ZONA GRAN PODER', quantity_of_people: 14)
Office.create(name: 'BNB EXPRESS OBRAJES', localization: 'AV. HERNANDO SILES N°247 ESQ. CALLE 12, EDIFICIO REINA ESTHER PB, ZONA OBRAJES', quantity_of_people: 22)

#setup ExchangeRate
ExchangeRate.create(date: "2016-11-26", sell: 6.97, buy: 6.85, ufv: 2.16513)
ExchangeRate.create(date: "2016-11-25", sell: 6.97, buy: 6.85, ufv: 2.16492)
ExchangeRate.create(date: "2016-11-24", sell: 6.97, buy: 6.85, ufv: 2.16471)
ExchangeRate.create(date: "2016-11-23", sell: 6.97, buy: 6.85, ufv: 2.16450)
ExchangeRate.create(date: "2016-11-22", sell: 6.97, buy: 6.85, ufv: 2.16429)
ExchangeRate.create(date: "2016-11-21", sell: 6.97, buy: 6.85, ufv: 2.16408)
ExchangeRate.create(date: "2016-11-20", sell: 6.97, buy: 6.85, ufv: 2.16366)
ExchangeRate.create(date: "2016-11-19", sell: 6.97, buy: 6.85, ufv: 2.16366)
ExchangeRate.create(date: "2016-11-18", sell: 6.97, buy: 6.85, ufv: 2.16345)
ExchangeRate.create(date: "2016-11-17", sell: 6.97, buy: 6.85, ufv: 2.16324)
ExchangeRate.create(date: "2016-11-16", sell: 6.97, buy: 6.85, ufv: 2.16303)
ExchangeRate.create(date: "2016-11-15", sell: 6.97, buy: 6.85, ufv: 2.16282)
ExchangeRate.create(date: "2016-11-14", sell: 6.97, buy: 6.85, ufv: 2.16261)
ExchangeRate.create(date: "2016-11-13", sell: 6.97, buy: 6.85, ufv: 2.16219)
ExchangeRate.create(date: "2016-11-12", sell: 6.97, buy: 6.85, ufv: 2.16219)
ExchangeRate.create(date: "2016-11-11", sell: 6.97, buy: 6.85, ufv: 2.16198)
ExchangeRate.create(date: "2016-11-10", sell: 6.97, buy: 6.85, ufv: 2.16177)
ExchangeRate.create(date: "2016-11-09", sell: 6.97, buy: 6.85, ufv: 2.16157)
ExchangeRate.create(date: "2016-11-08", sell: 6.97, buy: 6.85, ufv: 2.16137)
ExchangeRate.create(date: "2016-11-07", sell: 6.97, buy: 6.85, ufv: 2.16117)
ExchangeRate.create(date: "2016-11-06", sell: 6.97, buy: 6.85, ufv: 2.16077)
ExchangeRate.create(date: "2016-11-05", sell: 6.97, buy: 6.85, ufv: 2.16077)
ExchangeRate.create(date: "2016-11-04", sell: 6.97, buy: 6.85, ufv: 2.16057)
ExchangeRate.create(date: "2016-11-03", sell: 6.97, buy: 6.85, ufv: 2.16037)
ExchangeRate.create(date: "2016-11-02", sell: 6.97, buy: 6.85, ufv: 2.15997)
ExchangeRate.create(date: "2016-11-01", sell: 6.97, buy: 6.85, ufv: 2.15997)
