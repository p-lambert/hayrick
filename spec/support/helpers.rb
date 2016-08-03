module Helpers
  def create_album(name, artist, release_date)
    album = DB[:albums].insert(
      name: name,
      artist: artist,
      release_date: release_date
    )

    DB[:albums][id: album]
  end
end
