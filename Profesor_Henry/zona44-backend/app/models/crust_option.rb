class CrustOption < ApplicationRecord
  enum size: { personal: 0, small: 1, medium: 2, large: 3 }
end
