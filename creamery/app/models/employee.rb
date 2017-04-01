class Employee < ApplicationRecord
    
    has_many :assignment
    has_one :store, :through => :assignment
    
    validates :first_name, :last_name, :date_of_birth, :role, :SSN, presence: true
    validates :phone, :SSN, format: { with: /\A\d+(-\d+)*\z/, message: "Only numbers and dashes are allowed" }
    validates :first_name, :last_name, length: {maximum: 30}
    validates :phone, length: { in: 8..16 }
    validates :SSN, length: { in: 9..11}
    validates_date :date_of_birth, on_or_before: lambda { Date.current }
    
    scope :active, -> {where('active = ?', true) }
    scope :inactive, -> {where('active = ?', false)}
    scope :alphabetical, -> {order('first_name')}
    
    scope :younger_than_18, -> { where("date_of_birth > ?", 18.year.ago) }
    scope :is_18_or_older, -> { where("date_of_birth <= ?", 18.year.ago) }
    scope :regulars, -> {where('role = ?', 'Employee') }
    scope :managers, -> {where('role = ?', 'Manager') }
    scope :admins, -> {where('role = ?', 'Admin') }
    
    def name
        output = "" + self.last_name + ", " + self.first_name 
        return output
    end
    
    def proper_name
        output = "" + self.first_name + ", " + self.last_name
        return output
    end
    
    def current_assignment
        Assignment.joins(:employee).where("end_date > ?", Date.current).where("start_date <= ?", Date.current).where("employee_id == ?", self.id)
    end
    
    def over_18
        if age > 18
            return true
        else
            return false
        end
    end
    
    def age
        current = Time.now.utc.to_date
        y = current.year - self.date_of_birth.year
        
        if current.month > self.date_of_birth.month
            return y - 1
            
        elsif current.month == self.date_of_birth.month
            if current.day > self.date_of_birth.day
                return y - 1
            else
                return y
            end
            
        else
            return y
        end        
    end
    
end
