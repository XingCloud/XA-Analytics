# -*- coding: utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

category = ReportCategory.create({:name => 'Category1', :template => 1, :position => 1})
report = Report.create({:project_id => 1, :report_category_id => category.id, :template => 1, :title => "Hahaha"})