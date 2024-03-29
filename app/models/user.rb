class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    has_many :books, dependent: :destroy
    has_many :book_comments, dependent: :destroy
    has_one_attached :profile_image
    has_many :favorites, dependent: :destroy

    # # フォローフォロワーのやつ
    # has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    # has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

    # # Userの一覧画面

    # has_many :followings, through: :relationships, source: :followed
    # has_many :followers, through: :reverse_of_relationships, source: :follower

has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

# 一覧画面で使う
has_many :followings, through: :relationships, source: :followed
has_many :followers, through: :reverse_of_relationships, source: :follower

# DMのアソシエーショん
has_many :entries, dependent: :destroy
has_many :messages, dependent: :destroy

has_many :view_counts, dependent: :destroy


    # validates :name, length: {in: 2..20},
    validates :introduction, {length: {maximum:50} }
    validates :name, uniqueness: true, length: {maximum: 20, minimum: 2}



    def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [100, 100]).processed
    end

    # フォローした時の処理
    def follow(user_id)
      relationships.create(followed_id: user_id)
    end

    # フォローを外すときの処理
    def unfollow(user_id)
      relationships.find_by(followed_id: user_id).destroy
    end

    # フォローしているかの判定
    def following?(user)
      followings.include?(user)
    end
    
    
    
    
    # 検索方法分岐
    def self.looks(search, word)
      
      if search == "perfect_match"
        @user = User.where("name LIKE?", "#{word}")
        
        elsif search == "forward_match"
          @user = User.where("name LIKE?","#{word}%")
          
          elsif search == "backward_match"
            @user = User.where("name LIKE?", "%#{word}")
            
            elsif search == "partial_match"
              @user = User.where("name LIKE?", "%#{word}%")
              
            else
              @user = User.all
            end
          end
              
            
        
          




end
