#activate findjobstorun
require 'sidekiq/api'


#Clear all queues on init; if it's been running previously, Sidekiq may continue to spawn old FindJobstoRun
Sidekiq::Queue.new.clear

FindjobstorunJob.perform_later
