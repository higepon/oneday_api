ActionMailer::Base.default_url_options = { host: Settings.default_host }

if Settings.try(:mail)
  ActionMailer::Base.smtp_settings = {
    address:              Settings.mail.try(:address),
    port:                 Settings.mail.try(:port),
    domain:               Settings.mail.try(:domain),
    user_name:            Settings.mail.try(:user_name),
    password:             Settings.mail.try(:password),
    authentication:       :plain,
    enable_starttls_auto: true
  }
end
