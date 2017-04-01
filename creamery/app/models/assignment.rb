class Assignment < ApplicationRecord
    
    belongs_to :store
    belongs_to :employee
    
    before_save :end_previous_assignment
    
    validates :employee, presence: true, on: :create
    validates :store, presence: true, on: :create
    validate :active_store, on: :create
    validate :active_employee, on: :create
    validates :employee_id, :store_id, :start_date, :pay_level, presence: true
    validates_date :start_date, on_or_before: lambda { Date.current }
    validates_date :end_date, on_or_after: lambda { self.start_date }, message: "End date before start date" 
    
    def active_store
        s = Store.find_by_id(store_id)
        if s == nil
            errors.add(:store_id, "doesn't exist")
        else
            errors.add(:store_id, "is not active") unless s.active?
        end
    end
    
    def active_employee
        s = Employee.find_by_id(employee_id)
        if s == nil
            errors.add(:employee_id, "doesn't exist")
        else
            errors.add(:employee_id, "is not active") unless s.active?
        end
    end
    
    scope :current, -> { where("end_date > ?", Date.current) }
    scope :past, -> { where("end_date <= ?", Date.current) }
    scope :for_store, -> (store_id = nil){ where("store_id == ?", store_id)}
    scope :for_employee, -> (employee_id = nil){ where("employee_id == ?", employee_id)}
    scope :for_pay_level, -> (pay_level = nil){ where("pay_level == ?", pay_level)}
    scope :chronological, -> { order("start_date DESC") }
    scope :by_store, -> { order ("store_id") }
    scope :for_role, -> (role = nil){ joins(:employee).where("role == ?", role) }
    scope :by_employee, -> (last = nil, first = nil){ joins(:employee).order("last_name").where("last_name == ?", last).order("first_name").where("first_name == ?", first) }
    
    def end_previous_assignment
        cur_assignment = Assignment.for_employee(self.employee_id).current.first
        if (cur_assignment != id) and (cur_assignment.id != id)
            cur_assignment.update_attribute(:end_date, start_date)
            cur_assignment.save!
        end
    end

end
