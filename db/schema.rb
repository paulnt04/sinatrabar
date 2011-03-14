create_table "songs", :force => true do |t|
  t.string  "name"
  t.string  "artist"
  t.string  "album"
  t.string  "coverArt"
  t.integer "times_played"
  t.string  "status"
end

create_table "stations", :force => true do |t|
  t.integer "number"
  t.string  "name"
end

create_table "user", :forace => true do |t|
  t.string "user_name"
  t.string "password"
end
