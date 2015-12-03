class Project < ActiveRecord::Base
  belongs_to :user
  has_many :activities
  has_many :project_experiments, dependent: :destroy
  has_many :experiments, through: :project_experiments

  accepts_nested_attributes_for :project_experiments,
                                reject_if: :all_blank,
                                allow_destroy: true

  validate :experiments_presence

  # To create nice URLs
  extend FriendlyId
  friendly_id :name, use: :slugged

  mount_uploader :gen_bank, GenBankUploader
  mount_uploader :report,   ReportUploader

  # - A project is created with status 0 (quoting) and an automatic email is
  #   sent to the staff.
  # - A staff member get in touch with partners to find out the cost of the
  #   project. Once the final price is defined, the project is updated to the
  #   status 1 (payment_pending) and an automatic email is sent, asking the
  #   customer to pay the experiment.
  # - The customer click the link on the email and make the payment through
  #   Stripe. The project is then updated to the status 2 (synthesizing), and an
  #   automatic email is sent to the staff, which will then get in touch with
  #   partner and authorize the execution of the experiment.
  # - Once the experiment arrives at Arcturus, a staff member update the project
  #   to the status 3 (getting_data).
  # - When all the data is manually collected and arranged into a PDF file, a
  #   staff member attaches the PDF file on the project, which is then updated
  #   to the status 4 (done).
  enum status: {
    quoting: 0,
    payment_pending: 1,
    synthesizing: 2,
    getting_data: 3,
    done: 4
  }

  validates :name,
            presence: true,
            length: { maximum: 25 },
            uniqueness: { scope: :user,
                          message: 'Already exists on your account' }

  validates :gen_bank, presence: true, on: :create

  validates :estimated_delivery_days,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 80,
                            message: 'Estimation should be between 1 and 80' },
            if: :quoted?

  validates :price,
            numericality: { greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 100000,
                            message: 'Price should be between 1 and 100000' },
            if: :quoted?

  # List the pending projects first
  default_scope { order('status, created_at DESC') }

  # Projects qualified to be shown on /explore
  scope :open_source, -> { where("is_open_source = 'true'") }

  # Projects qualified to be shown on the landing page
  scope :featured, -> { where("is_featured = 'true'") }

  before_create :random_icon
  before_create :store_gen_bank_content, if: proc { |m| m.gen_bank.present? }
  before_save :pay_with_card, if: proc { synthesizing? }
  before_save :store_report_content, if: proc { done? && report_content.nil? }

  # Actions to be taken based on the project status
  after_create :perform_action
  after_save :perform_action, if: proc { |m| m.changes[:status] }

  attr_accessor :stripeToken

  def report_filename
    name.parameterize + '-report.pdf'
  end

  def gen_bank_filename
    gen_bank.file.filename
  end

  private

  def pay_with_card
    return if Rails.env.test?

    validate_stripe_token

    Stripe::Charge.create(customer: stripe_customer.id,
                          amount: (price * 100).round,
                          description: name,
                          currency: 'usd')

  rescue Stripe::InvalidRequestError => e
    errors.add(:base, e.message)
    raise ActiveRecord::RecordInvalid.new(self)
  rescue Stripe::CardError => e
    errors.add(:base, e.message)
    raise ActiveRecord::RecordInvalid.new(self)
  end

  def validate_stripe_token
    return if stripeToken
    errors.add(:base, 'Could not verify card')
    fail ActiveRecord::RecordInvalid.new(self)
  end

  def stripe_customer
    Stripe::Customer.create(email: user.email, card: stripeToken)
  end

  def experiments_presence
    return if valid_experiments.count > 0
    errors.add(:base, :experiments_too_short)
  end

  def valid_experiments
    experiments.reject(&:marked_for_destruction?)
  end

  def quoted?
    status != 'quoting'
  end

  def store_gen_bank_content
    self.gen_bank_content = gen_bank.file.read
  end

  def store_report_content
    self.report_content = report.file.read
  end

  def random_icon
    self.icon_url_path = "project-icons/#{rand(15)}.png"
  end

  def perform_action
    case status
    when 'quoting' then action_quoting
    when 'payment_pending' then action_payment_pending
    when 'synthesizing' then action_synthesizing
    when 'getting_data' then action_getting_data
    when 'done' then action_done
    end
  end

  def action_quoting
    # Send email to the staff, so they can get in touch with partners to find
    # out the cost of the project
    ProjectMailer.quoting_email(self).deliver_later
    activities.create!(key: 0)
  end

  def action_payment_pending
    # Send email asking the customer to pay the experiment
    ProjectMailer.payment_pending_email(self).deliver_later
    activities.create!(key: 1)
  end

  def action_synthesizing
    # Send email to the staff, so they can get in touch with the partner and
    # authorize the execution of the experiment
    ProjectMailer.synthesizing_email(self).deliver_later
    activities.create!(key: 2)
  end

  def action_getting_data
    # Send email to the customer, saying that the experiment is done and that
    # Arcturus is collecting all the data
    ProjectMailer.getting_data_email(self).deliver_later
    activities.create!(key: 3)
  end

  def action_done
    # Send email to the customer, saying that the project is done, with a link
    # to download the report
    ProjectMailer.done_email(self).deliver_later
    activities.create!(key: 4)
  end
end

# == Schema Information
#
# Table name: projects
#
#  id                      :integer          not null, primary key
#  name                    :string           not null
#  slug                    :string           not null
#  is_open_source          :boolean          default(TRUE), not null
#  is_featured             :boolean          default(FALSE), not null
#  status                  :integer          default(0), not null
#  icon_url_path           :string           not null
#  user_id                 :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  gen_bank                :string           not null
#  gen_bank_content        :binary           not null
#  price                   :money
#  estimated_delivery_days :integer
#  report                  :string
#  report_content          :binary
#
