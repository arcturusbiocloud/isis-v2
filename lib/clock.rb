require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'
require 'rest-client'

include Clockwork

every(1.minute, 'Trying to run experiment') {
  # define the API url
  url = Rails.env.production? ? "horus01.arcturus.io:3000" : "10.1.10.111:3000"
  
  # execute a pending experiment
  project = Project.pending.last
  unless project.nil?
    # get the free slot to run the experiment
    free_slot = Project.free_slot

    # making the rest call to run the experiment
    puts "making rest call to run the experiment :project_id => #{project.id}, :slot => #{free_slot}, :genetic_parts => #{project.genetic_parts.to_json}"
    # req = RestClient.post "http://arcturus:huxnGrbNfQFR@#{url}/api/run_virtual_experiment", :project_id => project.id, :slot => free_slot, :genetic_parts => project.genetic_parts.to_json
    # puts req

    # compare req and save the slot on the project 
  end
}

every(1.minute, 'Trying to take a picture') {
  # take picture with Project.active.last
  # change the Project model to update the status of project to completed after 3 pictures
  # ...
  project = Project.active.last
  unless project.nil?
    puts "making rest call to take the picture :project_id=> #{project.id}, :slot => #{project.slot}"
  end
}
