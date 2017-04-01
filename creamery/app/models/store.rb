class Store < ApplicationRecord
    
    has_many :assignment
    has_many :employee, :through => :assignment
    
    validates :name, :street, :zip, presence: true
    validates :name, uniqueness: true
    validates :zip, length: { in: 2..12, message: "Length must be between 2 to 12 characters" }
    validates :state, inclusion: { in: %w(PA OH WV pa oh wv), message: "%{value} is not available" } 
    validates :active, exclusion: { in: [nil] }
    validates :phone, format: { with: /\A\d+(-\d+)*\z/, message: "Only numbers and dashes are allowed" }
    validates :phone, length: { in: 8..16 }
    
    scope :active, -> {where('active = ?', true) }
    scope :inactive, -> {where('active = ?', false)}
    scope :alphabetical, -> {order('name')}
    
end
