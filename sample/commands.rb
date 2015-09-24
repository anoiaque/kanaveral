command(:changelog) do
  command -> { "git log origin/master..master --format=short" }
  notice -> { "Create changelog from commits" }
end

command(:git_push) do
  command -> { "git push origin master" }
  notice -> { "Push to origin/master" }
end

command(:git_pull) do
  command -> { "git pull origin master" }
  notice -> { "Pull from origin/master" }
end

command(:assets_precompile) do
  command -> { "echo precompile assets" }
end

command(:unicorn_upgrade) do
  command -> { "echo unicorns upgrade" }
end

command(:delayed_job_restart) do
  command -> { "echo restart delayed job worker" }
end

command(:newrelic) do
  command -> { "echo '#{context.commits}' | newrelic deployments -c" }
end

command(:bundler) do
  command ->(context) { ". ~/.profile && cd #{context.server.root} && bundle --quiet --without development test" }
  notice -> { "Run Bundler install" }
end