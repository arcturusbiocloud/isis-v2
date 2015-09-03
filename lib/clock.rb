require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'
require 'rest-client'

include Clockwork

every(30.seconds, 'Trying to run experiment') {
  # define the API url
  url = Rails.env.production? ? "horus01.arcturus.io:3001" : "10.1.10.111:3000"
  
  # execute a pending experiment
  project = Project.pending.last
  # get the free slot to run the experiment
  free_slot = Project.free_slot
  
  unless project.nil? || free_slot.nil?
    # making the rest call to run the experiment
    puts "making rest call to run the experiment :project_id => #{project.id}, :slot => #{free_slot}, :genetic_parts => #{project.genetic_parts.to_json}"
    req = RestClient.post "http://arcturus:huxnGrbNfQFR@#{url}/api/run_virtual_experiment", :project_id => project.id, :slot => free_slot, :genetic_parts => project.genetic_parts.to_json
    # compare req and save the slot on the project 
    unless req.nil?
      status = JSON.parse(req)["status"]
      if status != nil && status != "error"
        puts "saving slot, experiment running :project_id => #{project.id}, :slot => #{free_slot}"
        if project.slot.nil?
          project.slot = free_slot
          project.save
        end
      end
    end
    puts req
  end
}

every(1.minute, 'Trying to take a picture') {
  # define the API url
  url = Rails.env.production? ? "horus01.arcturus.io:3001" : "10.1.10.111:3000"

  project = Project.active.last
  unless project.nil?
    puts "making rest call to take the picture :project_id=> #{project.id}, :slot => #{project.slot}, :gene => #{project.genetic_parts[:gene]}"
    
    # get index and random A:E
    index = "#{(project.activities.count - 5)}_#{["A", "B", "C", "D", "E"].sample}"
    
    # making the rest call to take the picture
    req = RestClient.get "http://arcturus:huxnGrbNfQFR@#{url}/api/take_virtual_picture/#{project.id}/#{project.slot}/#{project.genetic_parts[:gene]}/#{index}"
    puts req
  end
}
