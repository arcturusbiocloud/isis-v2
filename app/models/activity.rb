require 'action_view'

class Activity < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

  belongs_to :project

  enum key: {
    quoting: 0,
    payment_pending: 1,
    synthesizing: 2,
    getting_data: 3,
    done: 4
  }

  def background
    I18n.t("timeline.background.#{key}")
  end

  def icon
    # Font-awesome icons to represent the different stages of the project,
    # displayed on the timeline.
    I18n.t("timeline.icon.#{key}")
  end

  def custom_css_style
    I18n.t("timeline.custom_css_style.#{key}")
  end

  def title
    I18n.t("timeline.title.#{key}")
  end

  def description
    I18n.t("timeline.description.#{key}", price: price, days: days)
  end

  private

  def price
    return unless project.price
    number_to_currency(project.price)
  end

  def days
    project.estimated_delivery_days
  end
end

# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  key        :integer          default(0), not null
#  detail     :string
#  project_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
