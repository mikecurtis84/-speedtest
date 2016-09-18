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
    else

    end

  end



  def perform() 
  	#Todo:- Add some way of setting the status into the view and check for active here - no way to stop jobs at the mo!
    pagestorun = Page.where("runtime < ?", DateTime.now)
    puts "FindjobstorunJob checking for new jobs, found #{pagestorun.count} jobs...."
    
    pagestorun.each do |page|
      job = Job.new(:status => "new")
      page.jobs << job
      updatedatetime(page) #Todo: This should only happen once we've confirmed job is queued. 
    end

    if pagestorun.count != 0
      #Run the queuejob task to pick out all unqueued jobs and send them to webpagespeedtest
      QueuejobsJob.perform_later
    end


  #set the next check for jobs in 5 minutes
  puts "finished FindjobstorunJob, taking a wee 1 minute nap"
  FindjobstorunJob.set(wait: 1.minute).perform_later
  end


end
