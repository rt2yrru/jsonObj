namespace :db do
  task :populate => :environment do
    Article.delete_all
    99.times do |n|
      title  = Faker::Lorem.words(3)
      body = Faker::Lorem.paragraphs(2)
      author  = Faker::Name.name
      Article.create!(:title => title,
                   :body => body,
                   :author => author)
      puts "Article created!"
    end
  end
end