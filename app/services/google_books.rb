require 'net/http'
require 'json'

isbn = "1408175207"
key = GOOGLE_API_KEY
domain = "https://www.googleapis.com/books/v1/volumes?"
uri = URI("#{domain}q=isbn:#{isbn}&key=#{key}")
response = Net::HTTP.get(uri)
book_hash = JSON.parse(response)
access = book_hash["items"][0]["volumeInfo"]

title = access["title"]
subtitle = access["subtitle"]
year = access["publishedDate"]
# year.scan(/\b\d{4}\b/)
pages = access["pageCount"]
description = access["description"]

authors = []
access["authors"].each do |author|
  authors << author
end
