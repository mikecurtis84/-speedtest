class QueuejobsJob < ApplicationJob
  queue_as :default


  def queuewebpagespeedtest(job)
  	puts "....Queuing #{job.page["url"]}"
  	#Todo: use environment variable for Key

	  	begin
		 response = Net::HTTP.get_response(URI.parse("https://www.webpagetest.org/runtest.php?url=#{job.page["url"]}&location=ec2-eu-west-1:Chrome&f=json&k=#{ENV["webpagetestapikey"]}"))
		 response = JSON.parse(response.body)
	


	 if response["statusCode"] == 200
	 	job.update(:status => "queued", :webpagetestid => response["data"]["testId"])
	 	print "...job queued succesfully"
	 else
	 	print "...failed to queue job with Webpagespeedtest - #{response.inspect}"
	 	job.update(:status => "rejected", :har => response) 
	 end


	rescue => e
		#For whatever reason, No response was gained from WebPageSpeedTest. Leave the job queued so it can be reattempted in the next run
		puts "Error: No response from WebPageSpeedTest on job #{job.id}. Error; #{e}"
	end

  end

  def perform()
 	queuedjobs = Job.where(:status => "new")
 	puts "Queing #{queuedjobs.count} Jobs with WebPageSpeedTest"

 	queuedjobs.each do |j|
 		queuewebpagespeedtest(j)
 	end

   
  end
end
