require 'rubygems'
require 'mechanize'
require "csv"
require 'colorize'

agent,offset,result = Mechanize.new,0,[]
puts

while offset < 5350
    offset = offset.to_s
    string = 'http://www.meetup.com/BeginnerProgrammers/members/?offset=' + offset
    page = agent.get(string)
    names_on_page = page.search('.memName')
    offset = offset.to_i
    names_on_page.count.times do |x|
         result << names_on_page[x]['href'].split('http://www.meetup.com/BeginnerProgrammers/members/')[1].split('/')[0]
    end
    percent_left = (offset * 100.0) / 5350.0
    percent_left = sprintf('%.1f', percent_left) 
    print " ==> Scraping Progress " +  " #{percent_left}% " + "pg.#{offset}".colorize(background: :red) + "\r"
    offset += 20
end

puts
puts "Success!".green
puts "Writing to csv now ...".green


CSV.open("file.csv", "wb") do |csv|
    result.count.times do |x|
        csv << [result[x]]
    end
end