class GetrunningtasksJob < ApplicationJob
  queue_as :default


  def getjobs(job)
	puts "Job completed, getting details."  	
	response = Net::HTTP.get_response(URI.parse("https://www.webpagetest.org/export.php?test=#{job["webpagetestid"]}"))
	return JSON.parse(response.body)
  end


  def testjob(job)
  	puts "testing to see if job id:#{job["id"]} is complete..." 
  	response = Net::HTTP.get_response(URI.parse("https://www.webpagetest.org/testStatus.php?f=json&test=#{job["webpagetestid"]}"))
  	response = JSON.parse(response.body)
  	
  	if response["statusCode"] == 200
  		results = getjobs(job)
  		summary = results["log"]["pages"][0]
  		puts summary["pageTimings"]["_startRender"]
  		job.update(:har => results.to_s, :loadtime => summary["_loadTime"], :startrender => summary["pageTimings"]["_startRender"], :requests => summary["_requestsFull"], :fullyloaded => summary["_fullyLoaded"], :status => "Complete") #Add Status 
  	elsif response["statusCode"] == 101
  		puts "Job #{job["id"]} not yet complete, status #{response["statusText"]}"
    else
      job.update(:status => "failed", :har => response)
  	end


  end


  def perform()
	jobs = Job.where(:status => "queued")  

	jobs.each do |j|
		testjob(j)
	end

  end

end
