require 'test_helper'

class ProjectMailerTest < ActionMailer::TestCase
  setup do
    extend ActionDispatch::TestProcess

    @user = users(:one)
    @file = fixture_file_upload('/project_uploader/pithovirus.gb')
  end

  test 'quoting' do
    project = @user.projects.create!(name: 'Pithovirus',
                                     gen_bank: @file,
                                     experiments: [experiments(:one)])

    assert_not ActionMailer::Base.deliveries.empty?

    email = ActionMailer::Base.deliveries.last

    assert_equal ['no-reply@arcturus.io'], email.from
    assert_equal ['staff@arcturus.io'], email.to
    assert_equal 'New project created id: 6 name: Pithovirus', email.subject
    assert_equal read_fixture('quoting').join, email_body(email)
  end

  test 'payment_pending' do
    @project = projects(:one)
    @project.update_attribute(:status, 1)

    assert_not ActionMailer::Base.deliveries.empty?

    email = ActionMailer::Base.deliveries.last

    assert_equal ['no-reply@arcturus.io'], email.from
    assert_equal ['admin@arcturus.io'], email.to
    assert_equal 'Arcturus BioCloud - Glowing Bacteria', email.subject
    assert_equal read_fixture('payment_pending').join, email_body(email)
  end

  test 'synthesizing' do
    @project = projects(:one)
    @project.update_attribute(:status, 2)

    assert_not ActionMailer::Base.deliveries.empty?

    email = ActionMailer::Base.deliveries.last

    assert_equal ['no-reply@arcturus.io'], email.from
    assert_equal ['staff@arcturus.io'], email.to
    assert_equal 'Project paid id: 1 name: Glowing Bacteria', email.subject
    assert_equal read_fixture('synthesizing').join, email_body(email)
  end

  test 'getting_data' do
    @project = projects(:one)
    @project.update_attribute(:status, 3)

    assert_not ActionMailer::Base.deliveries.empty?

    email = ActionMailer::Base.deliveries.last

    assert_equal ['no-reply@arcturus.io'], email.from
    assert_equal ['admin@arcturus.io'], email.to
    assert_equal 'Arcturus BioCloud - Glowing Bacteria', email.subject
    assert_equal read_fixture('getting_data').join, email_body(email)
  end

  test 'done' do
    @project = projects(:one)
    @project.report = fixture_file_upload('/project_uploader/report.pdf')
    @project.update_attribute(:status, 4)

    assert_not ActionMailer::Base.deliveries.empty?

    email = ActionMailer::Base.deliveries.last

    assert_equal ['no-reply@arcturus.io'], email.from
    assert_equal ['admin@arcturus.io'], email.to
    assert_equal 'Arcturus BioCloud - Glowing Bacteria', email.subject
    assert_equal read_fixture('done').join, email_body(email)
  end
end
