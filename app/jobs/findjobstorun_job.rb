class FindjobstorunJob < ApplicationJob
  queue_as :default


  def updatedatetime(page)
  ##Update the next runtime
  end



  def perform()
  	puts "Finding jobs to run"
  	#Todo:- Add some way of setting the status into the view and check for active here - no way to stop jobs at the mo!
    pagestorun = Page.where("runtime < ?", DateTime.now)

    pagestorun.each do |page|
    job = Job.create(:status => "new")
    page.jobs << job
    updatedatetime(page)
    end

  end
end
