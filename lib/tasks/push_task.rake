namespace :push_task do
    desc "LINEBOT：タスクの通知" 
    task :push_line_message_task => :environment do
        webhook = LinebotController.new
        webhook.push
    end
end
