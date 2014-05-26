configure :development do
  activate :livereload
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :slim
set :coffee

set :layout, false

ready do
  sprockets.append_path File.join root, 'bower_components'
end

configure :build do
  activate :minify_css
  activate :minify_javascript
end
