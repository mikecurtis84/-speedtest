class FindjobstorunJob < ApplicationJob
  queue_as :default

  def updatedatetime(page)
  ##Update the next runtime
    if page["schedule"] == "Daily"
      page.update(runtime: page["runtime"] + 1.days)
    elsif page["schedule"] == "Weekly"
      page.update(runtime: page["runtime"] + 7.days)
    elsif page["schedule"] == "Monthly"
      page.update(runtime: page["runtime"] + 1.months)
    elsif page["schedule"] == "One-Off"
      page.update(runtime: page["runtime"] + 100.years)
    end
 end


  def perform() 
      puts "-----------------------
  "
  	#Todo:- Add some way of setting the status into the view and check for active here - no way to stop jobs at the mo!
    pagestorun = Page.where("runtime < ?", DateTime.now.to_s)
    
    pagestorun.each do |page|
      job = Job.new(:status => "new")
      page.jobs << job
      updatedatetime(page)
    end
    begin
      
     
  #Queue any jobs that need queuing, Check any jobs already queued, then schedule the next task
  QueuejobsJob.perform_later
  GetrunningtasksJob.perform_later
  FindjobstorunJob.set(wait: 1.minute).perform_later()

    rescue => e
      puts "ERROR in FindjobstorunJob - #{e}"
    end
  end

end