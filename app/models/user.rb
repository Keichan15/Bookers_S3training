class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, uniqueness: true, length: {in:2..20}
  validates :introduction, length: {maximum: 50}

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  ## 仮想テーブル内の:follower, :followedに対して Relationship内からデータを引っ張ってきていることを明示
  # フォローする人(フォローするユーザーから見た中間(仮想)テーブル)
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされる人(フォローされているユーザーから見た中間(仮想)テーブル)
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 仮想テーブル follower を通り、フォローされる側(followed)を集める処理をfollowing_userと命名
  # フォローしているユーザーのデータが確認可能
  has_many :following_user, through: :follower, source: :followed
  # 仮想テーブル followed を通り、フォローする側(follower)を集める処理をfollowerと命名
  # フォローされているユーザーのデータが確認可能
  has_many :follower_user, through: :followed, source: :follower


  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # ユーザーをフォローする
  def follow(user)
    follower.create(followed_id: user.id)
  end

  # ユーザーのフォローを外す
  def unfollow(user)
    follower.find_by(followed_id: user.id).destroy
  end

  # フォローの確認を行う
  def following?(user)
    following_user.include?(user)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward' # 前方一致
      User.where('name LIKE ?', content+'%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%'+content)
    else
      User.where('name LIKE ?', '%'+content+'%')
    end
  end

end
