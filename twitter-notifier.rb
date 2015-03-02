#!/usr/bin/ruby

#########################
#
# This scripts scrapes the latest tweets from an account, 
# and sends an e-mail with the 5 last statuses in it.
#
#########################

require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Recipient email, twitter account to scrape and twitter account name
email = ARGV[0]
twitter_account_url = ARGV[1]
twitter_account_name = ARGV[2]

# pull in the twitter page
doc = Nokogiri::HTML(open(twitter_account_url))

subject = "Latest tweets from #{twitter_account_name}"

tweets = doc.css('div.ProfileTweet')
count = 0

File.open('body_message.txt','w') do |file|
    file.puts "Scraped #{url} and got 5 most recent tweets\n"
end

tweets.each do |tweet|
    # for each scrapped tweet, extracting the date and the status
    date = tweet.css('a.ProfileTweet-timestamp').css('span.js-short-timestamp').text
    text = tweet.css('p.ProfileTweet-text').text
    File.open('body_message.txt','a') do |file|
	file.puts "#{date} - #{text}\n"
    end
    count += 1
    if count == 5
	break;
    end
end

# Sends an e-mail with the report written in body_message.txt - NOT SENDING MESSAGE FROM THIS SCRIPT - MANAGED BY OUR JENKINS
#system "mail -s '#{subject}' '#{email}' < body_message.txt" 
