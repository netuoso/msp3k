class Bot < ApplicationRecord
  include ApplicationHelper

  has_many :permissions

  scope :has_posting_key, lambda { where('posting_key is not NULL') }
  before_save :encrypt_posting_key, if: -> (record) { record.posting_key.present? && record.posting_key.length < 52 }

  def name
    self.username
  end

  def decrypted_posting_key
    SslService.decrypt(self[:posting_key]) if self.posting_key.present?
  end

  def vote(options)
    return unless self.posting_key
    Rails.logger.info { "[Vote] User: #{options[:app_user]}, Author: #{options[:author]}, Permlink: #{options[:permlink]}, Power: #{options[:power]}" }

    comment_permlink_with_timestamp = "this-post-received-an-upvote-from-msp3k-com-#{Time.now.to_i}"

    tx = Radiator::Transaction.new(url: Settings.primary_steemd_node, wif: self.decrypted_posting_key)
    vote_tx = generate_vote_tx(options.fetch(:author), options.fetch(:permlink), options.fetch(:power))

    bot_attribution_text = "This post received a #{options[:power]}\% vote by @#{self.username} courtesy of @#{options[:app_user]} from the Minnow Support Project ( @minnowsupport ). [Join us in Discord](https://discord.gg/tuJsjYk).\n\nUpvoting this comment will help support @minnowsupport."

    tx.operations << vote_tx
    # tx.operations << msp3k_kickback_op(self.username, comment_permlink_with_timestamp)
    tx.process(true)
  end

  def comment(options)
    return unless self.posting_key

    permlink_with_timestamp = options.fetch(:permlink)

    tx = Radiator::Transaction.new(url: Settings.primary_steemd_node, wif: self.decrypted_posting_key)
    comment_tx = generate_comment_tx(
                  options.fetch(:author),
                  permlink_with_timestamp,
                  options.fetch(:title),
                  options.fetch(:body),
                  options.fetch(:parent_permlink),
                  options.fetch(:parent_author),
                  options.fetch(:tags))

    tx.operations << comment_tx
    # tx.operations << msp3k_kickback_op(self.username, permlink_with_timestamp)
    tx.process(true)
  end

  def resteem(options)
    return unless self.posting_key

    comment_permlink_with_timestamp = "this-post-has-been-resteemed-from-msp3k-com-#{Time.now.to_i}"

    tx = Radiator::Transaction.new(url: Settings.primary_steemd_node, wif: self.decrypted_posting_key)
    reblog_tx = generate_reblog_tx(options.fetch(:author), options.fetch(:permlink))

    bot_attribution_text = "This post has been resteemed by @#{self.username} courtesy of @#{options.fetch(:app_user)} from the Minnow Support Project ( @minnowsupport ). [Join us in Discord](https://discord.gg/tuJsjYk).\n\nUpvoting this comment will help support @minnowsupport."

    tx.operations << reblog_tx
    # tx.operations << msp3k_kickback_op(self.username, comment_permlink_with_timestamp)
    tx.process(true)
  end

  def self.parse_url(url='')
    # Parses a SteemIt.com url and returns the supported actions and matched groups
    if url.match(/^https:\/\/steemit\.com\/(?<post_parent_permlink>(\w|\d|-)*)\/@(?<post_author>(\w|\d|-|\.)*)\/(?<post_permlink>(\w|\d|-)*)$/).present?
      regex_match = url.match(/^https:\/\/steemit\.com\/(?<post_parent_permlink>(\w|\d|-)*)\/@(?<post_author>(\w|\d|-|\.)*)\/(?<post_permlink>(\w|\d|-)*)$/)
      supported_actions = ['actions',['vote','resteem','comment']]
    elsif url.match(/^https:\/\/steemit\.com\/(?<post_parent_permlink>(\w|\d|-)*)\/@(?<post_author>(\w|\d|-|\.)*)\/(?<post_permlink>(\w|\d|-)*)#@(?<comment_author>(\w|\d|-)*)\/(?<comment_permlink>(\w|\d|-)*)$/).present?
      regex_match = url.match(/^https:\/\/steemit\.com\/(?<post_parent_permlink>(\w|\d|-)*)\/@(?<post_author>(\w|\d|-|\.)*)\/(?<post_permlink>(\w|\d|-)*)#@(?<comment_author>(\w|\d|-)*)\/(?<comment_permlink>(\w|\d|-)*)$/)
      supported_actions = ['actions',['vote','resteem','comment']]
    end

    if regex_match
      captured_groups = regex_match.names
      captured_values = regex_match.captures
      Rails.logger.info { "[ParseUrl]: Group Names: #{captured_groups}, Captured Values: #{captured_values}, Action: #{supported_actions}"}
      Hash[captured_groups.zip(captured_values).push(supported_actions)]
    end
  end

  private

  def encrypt_posting_key
    self.posting_key = SslService.encrypt(self.posting_key)
  end

end
