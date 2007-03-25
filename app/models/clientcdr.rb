class Clientcdr < ActiveRecord::Base
#
# pbxcdrs.start/pbxcdrs.answer should match btbilldetails.date/time
# pbxcdrs.dst should match btbilldetails.calledno (calledno may have spaces)
# pbxcdrs.duration/billsec should be _close_ to btbilldetails.duration
# btbilldetaila.cost is what we are looking for!:w

end
