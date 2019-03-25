class BotsController < BaseController
  include ApplicationHelper

  def index
    @permitted_bots = current_user.bots.pluck(:username)
    @permitted_actions = current_user.permissions.collect { |permission| permission.action }.uniq
  end

  def perform_action
    params[:bots].each do |bot|
      authorize current_user, "#{bot.gsub('-','_')}_#{params[:bot_action]}_allowed?"
    end

    bots = Bot.where(username: params[:bots])

    bot_attribution_text = %Q{<center>![](https://i.imgur.com/GU9jFP9.png)</center>\n
This post has been #{params[:bot_action] == 'vote' ? 'voted on' : 'resteemed'} from MSP3K courtesy of @#{current_user.username} from the Minnow Support Project ( @minnowsupport ).\n
Bots Information:\n}

    bots.each do |bot|
      action_options =
        case params[:bot_action]
        when 'vote'
            @original_author = vote_params[:author]
            @original_permlink = vote_params[:permlink]
            bot_attribution_text += "- @#{bot.username} - #{vote_params[:power]}%\n"
            bot_attribution_text += "\n" if bot == bots.last
            {
              app_user: vote_params[:app_user].present? ? vote_params[:app_user] : current_user.username,
              author: vote_params[:author],
              permlink: vote_params[:permlink],
              power: vote_params[:power]
            }
        when 'comment'
            {
              app_user: current_user.username,
              author: bot.username,
              permlink: "comment_params[:permlink]-#{Time.now.to_i}",
              title: comment_params[:title],
              body: comment_params[:body],
              parent_permlink: comment_params[:parent_permlink],
              parent_author: comment_params[:parent_author],
              tags: comment_params[:tags]
            }
        when 'resteem'
            @original_author = resteem_params[:author]
            @original_permlink = resteem_params[:permlink]
            bot_attribution_text += "- @#{bot.username}\n"
            bot_attribution_text += "\n" if bot == bots.last
            {
              app_user: resteem_params[:app_user].present? ? resteem_params[:app_user] : current_user.username,
              author: resteem_params[:author],
              permlink: resteem_params[:permlink]
            }
        end

      Rails.logger.info { "[BotsController] Scheduling #{bot.username} to #{params[:bot_action]} with options: #{action_options}" }
      ProcessActionJob.set(wait_until: 5.seconds.from_now).perform_later(bot,params[:bot_action],action_options)
    end

    bot_attribution_text += "[Join the P.A.L. Discord](https://discord.gg/tuJsjYk) | [Check out MSPSteem](https://www.mspsteem.com) | [Listen to MSP-Waves](http://mspwaves.com)"

    # Only leave attribution comment if msp3k bot is present
    msp3k_bot = Bot.find_by(username:'msp3k')
    if msp3k_bot && params[:bot_action] != 'comment' && @original_author && @original_permlink
      comment_permlink_with_timestamp = "this-post-has-been-curated-by-msp3k-com-#{Time.now.to_i}"
      attribution_comment_tx = {
        author: msp3k_bot.username,
        permlink: comment_permlink_with_timestamp,
        title: 'This post has been curated by MSP3k.com',
        body: bot_attribution_text,
        parent_permlink: @original_permlink,
        parent_author: @original_author,
        tags: comment_params[:tags]
      }
      Rails.logger.info { "[BotsController] Scheduling #{msp3k_bot.username} to comment with options: #{attribution_comment_tx}" }
      ProcessActionJob.set(wait_until: 5.seconds.from_now).perform_later(msp3k_bot,'comment',attribution_comment_tx)
    end

    redirect_to root_path, notice: "Bot(s) #{params[:bots].join(', ')} scheduled to #{params[:bot_action]} as soon as possible."
  end

  def parse_url
    authorize current_user, :parse_url_allowed?

    begin
      parsed_url = Bot.parse_url(params.permit(:steemit_url)['steemit_url'])

      render json: {success: true, response: parsed_url}
    rescue => e
      Rails.logger.error { "[ParseURL] Error: #{e}. Backtrace: #{e.backtrace.first(10)}"}
      render json: {success: false, error: e, backtrace: e.backtrace.first(10)}
    end
  end

  private

  def vote_params
    params.permit(:app_user,:bots,:author,:permlink,:power)
  end

  def comment_params
    params.permit(:permlink,:title,:body,:parent_permlink,:parent_author,:tags)
  end

  def resteem_params
    params.permit(:app_user,:bots,:author,:permlink)
  end

end
