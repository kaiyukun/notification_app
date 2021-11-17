namespace :push_task do
    desc "LINEBOT：タスクの通知" 
    task :push_line_message_task => :environment do
        require 'line/bot'
        puts "Hello!!"
        message = {
            type: 'text',
            text: '今日がタスクの期限でっせ！https://oshierukun.herokuapp.com/'
        }
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
        limit_tasks = Post.where(endday: Date.today)
        posts = Post.all
        limit_tasks.each do |user|
            puts "名前：#{user.body}"
            puts "年齢：#{user.user_uid}"
        end
        
        limit_tasks.each do |user|
            client.push_message(user.user_uid, message)
            
        end
    end
end
