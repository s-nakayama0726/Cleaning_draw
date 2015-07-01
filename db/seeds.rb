# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# coding: utf-8

user = CleaningEntry.new
user.name = "user1"
user.draw_no = 1;
user.join_flag = 1;
user.user_id = "user1"
user.pass= "user1"
user.email = "s-nakayama@ankh-systems.co.jp"
user.save

user = CleaningEntry.new
user.name = "user2"
user.draw_no = 2;
user.join_flag = 1;
user.user_id = "user2"
user.pass = "user2"
user.email = "default@sample.co.jp"
user.save

user = CleaningEntry.new
user.name = "user3"
user.draw_no = 3;
user.join_flag = 0;
user.user_id = "user3"
user.pass = "user3"
user.email = "default@sample.co.jp"
user.save

user = CleaningEntry.new
user.name = "user4"
user.draw_no = 4;
user.join_flag = 0;
user.user_id = "user4"
user.pass = "user4"
user.email = "default@sample.co.jp"
user.save

user = CleaningEntry.new
user.name = "user5"
user.draw_no = 5;
user.join_flag = 0;
user.user_id = "user5"
user.email = "default@sample.co.jp"
user.pass = "user5"
user.save