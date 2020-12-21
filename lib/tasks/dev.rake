namespace :dev do

  DEFAULT_PASSWORD = 123456
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Cleaning DB...") do
        %x(rails db:drop)
      end

      show_spinner("Creating DB...") do
        %x(rails db:create)
      end

      show_spinner("Migrating DB...") do
        %x(rails db:migrate)
      end

      show_spinner("Creating default admin..") do
        %x(rails dev:add_default_admin)
      end

      show_spinner("Creating default user...") do
        %x(rails dev:add_default_user)
      end
    else
      puts "You aren't in developmente environment."
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private
  
  def show_spinner (msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})") # Stop animation
  end
end
