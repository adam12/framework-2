# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "debug", "~> 1.7"
gem "rake"
gem "webrick"

group :development do
  gem "standard", "~> 1.9"
end

group :test do
  gem "minitest", "> 5.16"
end

# Framework
gem "framework-core", path: "framework-core"
gem "framework-render", path: "framework-render"
