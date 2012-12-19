# slides 47-56
# http://techylib.com/en/view/arya/beyond_rails_with_torquebox

class EmailQueue
  include TorqueBox::Queue::Base
  
  def send_email(payload={})
    # case statement for kinds of emails
  end
  
end