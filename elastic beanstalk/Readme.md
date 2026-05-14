# Introduction to Elastic Beanstalk
What is Platform as a Service? (PaaS)
A platform allowing customers to develop, run, and manage applications without the complexity of building and maintaining the infrastructure typically associated with developing and launching an app

Think of Elastic Beanstalk (EB) as the Heroku of AWS

# Choose a platform, upload your code and it runs with little knowledge of the infrastructure.
Not Recommended for "Production" applications
(AWS is talking about enterprise, large companies.)
Elastic Beanstalk is powered by a CloudFormation template setups for you:

Elastic Load Balancer
Autoscaling Groups
RDS Database
EC2 Instance preconfigured (or custom) platforms
Monitoring (CloudWatch, SNS)
In-Place and Blue/Green deployment methodologies
Security (Rotates passwords)
Can run Dockerized environments

# EB – Supported Languages
Langage     Framework
Ruby        Rails
Python      Django
PHP         Laravel
Tomcat      Spring
Node.js     Express

Elastic Beanstalk supporte plusieurs langages et leurs frameworks populaires :

Ruby → Rails : langage backend populaire, Rails est son framework web principal
Python → Django : Python très utilisé en data/web, Django est son framework web robuste

En résumé : tu uploades ton code dans l'un de ces langages/frameworks, et Elastic Beanstalk gère automatiquement toute l'infrastructure dessous (serveurs, load balancer, scaling, monitoring) sans que tu aies à t'en occuper.

# docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html
# https://guides.rubyonrails.org/getting_started.html
# guides.rubyonrails.org/getting_started.html#creating-the-blog-application

gem install rails

# Create our rails projects

> Update db/database.yml to have our username and password

## Install packages

```sh
bundle install
```

# Start our rails project

```sh
bundle exec rails s -b 0.0.0.0
```


# rails generate migration create_tables

class CreateTables < ActiveRecord::Migration[7.1]
  def change
    create_table :things do |t|
      t.string :name
      t.timestamps
    end
    Thing.create!(name: "Hello")
    Thing.create!(name: "World")
    Thing.create!(name: "Goodbye")
    Thing.create!(name: "Moon")
  end
end

# create the table
bundle exec rails db:create

# migrate the table 
bundle exec rails db:migrate

# install eb cli
docs.docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html#eb-cli3-install.scripts

## Package or EB

zip -r package.zip example
zip -r package.zip .

# docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.logging.html
# docs.aws.amazon.com/elasticbeanstalk/latest/dg/ebextensions.html

# [ec2-user@ip-172-31-24-59 ~]$ env
SHELL=/bin/bash
RACK_ENV=production
BUNDLE_WITHOUT=test:development
HISTCONTROL=ignoredups
RAILS_SKIP_ASSET_COMPILATION=true
SYSTEMD_COLORS=false
HISTSIZE=1000
HOSTNAME=ip-172-31-24-59.ca-central-1.compute.internal
RUBY_VERSION=3.2.2
PWD=/home/ec2-user
LOGNAME=ec2-user
RDS_PASSWORD=password
HOME=/home/ec2-user
RDS_DB_NAME=ebdb
LANG=en_US.UTF-8
RAILS_SKIP_MIGRATIONS=false





# eb/basic/example/config/environments/production.rb
# config.assume_ssl = true
Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
- config.force_ssl = true
+ # we dont have a valid SSL certificate to install on the nginx proxy
+ config.force_ssl = false

# Log to STDOUT by default
config.logger = ActiveSupport::Logger.new(STDOUT)






# dockerfile
# syntax=docker/dockerfile:1
FROM ruby:3.1.2-slim-buster
RUN apt-get update -qq && apt-get install -y nodejs libpq-dev build-essential libsqlite3-dev
COPY . /app
WORKDIR /app

ENV SECRET_KEY_BASE 5c212d4f447bc55087ee0a2a7291c05f
ENV RAILS_ENV production
#RUN bundle config --global build.nokogiri --use-system-libraries
RUN bundle config --global frozen 1
RUN bundle config set without 'development test'
RUN bundle install

RUN chmod u+x /app/startup.sh
ENTRYPOINT ["/app/startup.sh"]

EXPOSE 80




# brew install awsebcli
# bentranz.medium.com/deploy-ruby-on-rails-application-to-aws-elastic-beanstalk-amazon-linux-2-138654b1ce41
