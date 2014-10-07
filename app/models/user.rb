class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  
  field :name
  field :spotify_id
  field :spotify_playlist_id
  field :spotify_hash, type: Hash
end