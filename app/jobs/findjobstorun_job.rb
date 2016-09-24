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
    end
 end


  def perform() 
  	#Todo:- Add some way of setting the status into the view and check for active here - no way to stop jobs at the mo!
    pagestorun = Page.where("runtime < ?", DateTime.now)
    puts "FindjobstorunJob checking for new jobs, found #{pagestorun.count} jobs...."
    
    pagestorun.each do |page|
      job = Job.new(:status => "new")
      page.jobs << job
      updatedatetime(page)
    end


    if pagestorun.count != 0
      #Run the queuejob task to pick out all unqueued jobs and send them to webpagespeedtest
      QueuejobsJob.perform_later
    end

  #Check any jobs in the queue, then schedule the next task
  puts "finished FindjobstorunJob, checking for any jobs in queue and scheduling next "
  GetrunningtasksJob.perform_later
  FindjobstorunJob.set(wait: 1.minute).perform_later
  end

end