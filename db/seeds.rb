# Create admin
User.create!(email: 'admin@arcturus.io', username: 'arc-admin', password: '123456', password_confirmation: '123456', admin: true)

# Create user 1
user = User.create!(email: 'user@arcturus.io', username: 'arc-user', password: '123456', password_confirmation: '123456')

# Create user 2
User.create!(email: 'guest@arcturus.io', username: 'arc-guest', password: '123456', password_confirmation: '123456')

# Create experiments
Experiment.create!(name: 'Protein assay', price: 10)
Experiment.create!(name: 'Gel images', price: 12)
Experiment.create!(name: 'qPCR', price: 15)
Experiment.create!(name: 'Sequencing', price: 18)

# Create projects
file = File.open('test/fixtures/project_uploader/pithovirus.gb')

user.projects.create(name: 'Pithovirus One', gen_bank: file, experiments: [Experiment.find(1)])

project = user.projects.create(name: 'Pithovirus Two', gen_bank: file, experiments: [Experiment.find(1), Experiment.find(2)])
project.update(price: project.experiments.sum(:price), estimated_delivery_days: 5, status: 1)

project = user.projects.create(name: 'Pithovirus Three', gen_bank: file, experiments: [Experiment.find(1), Experiment.find(2), Experiment.find(3)])
project.update(price: project.experiments.sum(:price), estimated_delivery_days: 6, status: 1)
project.update(status: 2)

project = user.projects.create(name: 'Pithovirus Four', gen_bank: file, experiments: [Experiment.find(1), Experiment.find(2), Experiment.find(3), Experiment.find(4)])
project.update(price: project.experiments.sum(:price), estimated_delivery_days: 7, status: 1)
project.update(status: 2)
project.update(status: 3)

project = user.projects.create(name: 'Pithovirus Five', gen_bank: file, experiments: [Experiment.find(2), Experiment.find(4)])
project.update(price: project.experiments.sum(:price), estimated_delivery_days: 4, status: 1)
project.update(status: 2)
project.update(status: 3)
report = File.open('test/fixtures/project_uploader/report.pdf')
project.update(status: 4, report: report)
