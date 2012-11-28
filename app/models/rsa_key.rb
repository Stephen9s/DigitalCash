class RsaKey < ActiveRecord::Base
  attr_accessible :modulus, :encryption, :decryption
end
