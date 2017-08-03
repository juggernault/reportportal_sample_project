namespace :rp do
  require_relative 'features/support/helpers/rp_helper'

  desc 'Merge today\'s launches in report portal for specific project'
  task :merge_todays, [:project] do |t, args|
    raise 'Specify project name: `rake merge_todays[project_name]`' if args[:project].nil?
    Zpg::RP.merge_todays args[:project]
  end
end