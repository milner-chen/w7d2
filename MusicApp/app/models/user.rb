class User < ApplicationRecord
    # figvaper
    attr_reader :password

    before_validation :ensure_session_token

    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email)
        if user && user.is_password?(password) # if user not nil + pass matches
            user
        else
            nil
        end
    end

    def generate_unique_session_token  # generate a unique token
        token = SecureRandom::urlsafe_base64 # remember syntax
        while User.exists?(session_token: token) # call exists? on User class
            token = SecureRandom::urlsafe_base64
        end
        token # remember to return token!!!
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save
        # set something to nil
    end

    def ensure_session_token # make sure token is set
        self.session_token ||= generate_unique_session_token
    end

    def password=(password) # use password to set password_digest
        @password = password # save pass info for validations
        self.password_digest = BCrypt::Password.create(password) # don't forget to set
    end

    def is_password?(password) #
        BCrypt::Password.new(self.password_digest).is_password?(password) # remember there is no password column
    end

end