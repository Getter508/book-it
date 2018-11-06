require 'net/http'
require 'json'

isbn = "0060541814"
domain = "http://openlibrary.org/api/books?"
uri = URI("#{domain}bibkeys=ISBN:#{isbn}&jscmd=data&format=json")
response = Net::HTTP.get(uri)
book_hash = JSON.parse(response)

access = book_hash["ISBN:#{isbn}"]

genres = []
access["subjects"].each do |genre|
  genres << genre["name"].capitalize if Genre::GENRES.include?(genre["name"].capitalize)
  genres << Genre::GENRES_MAP[genre["name"]].capitalize if Genre::GENRES_MAP[genre["name"]]
end

large_cover = access["cover"]["large"]
medium_cover = access["cover"]["medium"]
small_cover = access["cover"]["small"]
