module DepartmentsHelper
  # this just lets us list all departments that can be selected nicely
  def departments_for_select
    Department.all.collect{ |d| [d.dept_name] }
  end
end