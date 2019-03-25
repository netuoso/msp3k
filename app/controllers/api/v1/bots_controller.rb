class Api::V1::BotsController < Api::V1::BaseController

	def vote
    parsed_url = Bot.parse_url(permitted_params[:url])

    action_params = {
      bots: permitted_params[:bots].split(','),
      bot_action: action_name,
      app_user: permitted_params[:app_user],
      author: parsed_url['actions'].include?('resteem') ? parsed_url['post_author'] : parsed_url['comment_author'],
      permlink: parsed_url['actions'].include?('resteem') ? parsed_url['post_permlink'] : parsed_url['comment_permlink'],
      power: 5
    }

    begin
      perform_action(action_params)
      if @success
        render json: {success: @success, response: @bot_response}
      else
        render json: {success: @success, error: @bot_response, backtrace: @error_backtrace}
      end
    rescue => e
      render json: {success: false, error: e, backtrace: e.backtrace.first(10)}
    end
	end

	def resteem
    parsed_url = Bot.parse_url(permitted_params[:url])

    action_params = {
      bots: permitted_params[:bots].split(','),
      bot_action: action_name,
      app_user: permitted_params[:app_user],
      author: parsed_url['actions'].include?('resteem') ? parsed_url['post_author'] : parsed_url['comment_author'],
      permlink: parsed_url['actions'].include?('resteem') ? parsed_url['post_permlink'] : parsed_url['comment_permlink']
    }

    begin
      perform_action(action_params)
      if @success
        render json: {success: @success, response: @bot_response}
      else
        render json: {success: @success, error: @bot_response, backtrace: @error_backtrace}
      end
    rescue => e
      render json: {success: false, error: e, backtrace: e.backtrace.first(10)}
    end
	end

  private

  def perform_action(options)
    options[:bots].each do |bot|
      authorize @apiuser, "#{bot.gsub('-','_')}_#{options[:bot_action]}_allowed?"
    end

    begin
      bots = Bot.where(username: options[:bots])

        case options[:bot_action]
        when 'vote'
          action_response = bots.collect do |bot|
            bot.vote(app_user: options[:app_user],
                    author: options[:author],
                    permlink: options[:permlink],
                    power: options[:power])
          end

        when 'comment'
          action_response = bots.collect do |bot|
            bot.comment(app_user: @apiuser.username,
                        author: bot.username,
                        permlink: options[:permlink],
                        title: options[:title],
                        body: options[:body],
                        parent_permlink: options[:parent_permlink],
                        parent_author: options[:parent_author],
                        tags: options[:tags])
          end

        when 'resteem'
          action_response = bots.collect do |bot|
            bot.resteem(app_user: options[:app_user],
                        author: options[:author],
                        permlink: options[:permlink])
          end

        end

      @success = true
      @bot_response = action_response
    rescue => e
      @success = false
      @bot_response = e
      @error_backtrace = e.backtrace.first(10)
    end
  end

end
