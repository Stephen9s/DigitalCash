class RsaKey < ActiveRecord::Base
  attr_accessible :private_key, :public_key
end
