class Relationship < ApplicationRecord
  # class_nameを使用することで、実際はUserテーブルの所を:follower, :followedという仮想テーブルで扱ってもらう
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
