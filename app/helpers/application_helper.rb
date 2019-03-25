module ApplicationHelper

  def bootstrap_class_for(flash_type)
    case flash_type
    when "success"
      "alert-success"   # Green
    when "error"
      "alert-danger"    # Red
    when "alert"
      "alert-warning"   # Yellow
    when "notice"
      "alert-info"      # Blue
    else
      flash_type.to_s
    end
  end

  def current_user_is_admin?
    current_user && current_user.is_admin?
  end

  def generate_vote_tx(author, permlink, power)
    {
      type: :vote,
      voter: self.username,
      author: author,
      permlink: permlink,
      weight: power.to_i*100
    }.merge(msp3k_attribution)
  end

  def generate_comment_tx(author, permlink, title, body, parent_permlink, parent_author, tags)
    {
      type: :comment,
      author: author,
      permlink: permlink,
      title: title,
      body: body,
      parent_permlink: parent_permlink ? parent_permlink : tags,
      parent_author: parent_author,
    }.merge(msp3k_attribution(tags))
  end

  def msp3k_kickback_op(author, permlink)
      Radiator::Operation.new(
        type: :comment_options,
        author: author,
        permlink: permlink,
        max_accepted_payout: '1000000.000 SBD',
        percent_steem_dollars: 10000,
        allow_replies: true,
        allow_votes: true,
        allow_curation_rewards: true,
        extensions: Radiator::Type::Beneficiaries.new('msp3k': 5000)
      )
  end

  def generate_reblog_tx(author, permlink)
    {
      type: :custom_json,
      required_auths: [],
      required_posting_auths: [self.username],
      id: 'follow',
      json: ['reblog',{account: self.username, author: author, permlink: permlink}].to_json
    }.merge(msp3k_attribution)
  end

  def msp3k_attribution(tags=[])
    {
      json_metadata: {
        tags: tags && tags.class == Array ? tags.append(Settings.default_posting_tags) : Settings.default_posting_tags,
        app: 'msp3k/1.0',
        format: 'markdown+html',
        community: 'minnowsupport'
      }.to_json
    }
  end

end
