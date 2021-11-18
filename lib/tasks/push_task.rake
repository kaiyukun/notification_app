namespace :push_task do
    desc "LINEBOT：タスクの通知" 
    task :push_line_message_task => :environment do
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
        limit_tasks = Post.where(endday: Date.today)
        limit_tasks.each do |t|
            puts "名前：#{user.body}"
            puts "ユーザーID：#{user.user_uid}"
        end
        
        limit_tasks.each do |t|
            message = {
                type: 'text',
                text: "「#{user.body}」の期限は今日でっせ！"
            }
            response = client.push_message(user.user_uid, message)
            p response
        end
    end
end
