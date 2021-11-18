class LinebotController < ApplicationController
    require 'line/bot'  # gem 'line-bot-api'

    # callbackアクションのCSRFトークン認証を無効
    protect_from_forgery :except => [:callback, :push]

    def client
        @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
    end

    def callback
        body = request.body.read

        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
        head :bad_request
        end

        events = client.parse_events_from(body)

        events.each { |event|
        case event
        when Line::Bot::Event::Message
            case event.type
            when Line::Bot::Event::MessageType::Text
            message = {
                type: 'text',
                text: event.message['text']
            }
            client.reply_message(event['replyToken'], message)
            when Line::Bot::Event::MessageType::Follow #友達登録イベント
                userId = event['source']['userId'] 
                User.find_or_create_by(uid: userId)
            when Line::Bot::Event::MessageType::Unfollow #友達削除イベント
                userId = event['source']['userId']  
                user = User.find_by(uid: userId)
                user.destroy if user.present?
            end
        end
        }

        head :ok
    end
    
    def push
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
        limit_tasks = Post.where(endday: Date.today)
        limit_tasks.each do |user|
            puts "名前：#{user.body}"
            puts "ユーザーID：#{user.user_uid}"
        end
        
        limit_tasks.each do |user|
            message = {
                type: 'text',
                text: "「#{user.body}」の期限は今日でっせ！"
            }
            response = client.push_message(user.user_uid, message)
            p response
        end
        # response = client.push_message('U30fa6516908f1e37b8cdcaacbc88496a', message)
        # p response
    end
end
