module DepartmentsHelper
  def departments_for_select
    Department.all.collect{ |d| [d.dept_name] }
  end
end