DB = Sequel.sqlite

DB.create_table :albums do
  primary_key :id
  String :name
  String :artist
  Date :release_date
end
