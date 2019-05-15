
# Runs first before any other seeding
#
# Seedbank runs everything in seeds directory in alphabetic order
# Seedbank has an option to change dependency but prefer to not put this
# before every other file as it would get repetitive
#

Rake::Task['db:truncate_all'].invoke

# Users
Rake::Task['db:import:users'].invoke('test')
