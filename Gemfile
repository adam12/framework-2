# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "bake"
gem "debug"
gem "erubi"
gem "rake"
gem "webrick"

group :development do
  gem "standard"
end

group :test do
  gem "minitest"
  gem "simplecov"
end

group :benchmark do
  gem "benchmark-ips"
end

# Framework
gem "framework-core", path: "framework-core"
gem "framework-render", path: "framework-render"
gem "framework-web", path: "framework-web"
