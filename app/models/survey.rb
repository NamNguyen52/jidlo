class Survey < ActiveRecord::Base
  
  def do_crunch(q1,q2,q3,uniqueid) 
    check = Survey.find(uniqueid: uniqueid)
    @got_people = check.people
  end

end
