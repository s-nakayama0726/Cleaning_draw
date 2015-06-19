# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# coding: utf-8

user = CleaningEntry.new
user.name = "Aさん"
user.draw_no = 1;
user.join_flag = 1;
user.save

user = CleaningEntry.new
user.name = "Bさん"
user.draw_no = 2;
user.join_flag = 1;
user.save

user = CleaningEntry.new
user.name = "Cさん"
user.draw_no = 3;
user.join_flag = 0;
user.save

user = CleaningEntry.new
user.name = "Dさん"
user.draw_no = 4;
user.join_flag = 0;
user.save

user = CleaningEntry.new
user.name = "Eさん"
user.draw_no = 5;
user.join_flag = 0;
user.save