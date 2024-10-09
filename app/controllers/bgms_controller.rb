class BgmsController < ApplicationController
    def index
      @playlists = RSpotify::Playlist.search('workout') # 適切な検索キーワードでプレイリストを取得
    end
  end
  