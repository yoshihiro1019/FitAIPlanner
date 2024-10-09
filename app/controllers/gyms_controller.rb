# app/controllers/gyms_controller.rb
class GymsController < ApplicationController
    def index
      # ジム情報の取得（ダミーデータなど）
      @gyms = [
        { name: "ジムA", location: "東京" },
        { name: "ジムB", location: "大阪" },
        { name: "ジムC", location: "福岡" }
      ]
    end
  end
  