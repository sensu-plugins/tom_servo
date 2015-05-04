
# Set any paths
HOMEDIR         = Dir.home
PROJECT_ROOT    = File.expand_path(File.join(HOMEDIR, 'clone'))
LIB_ROOT        = File.expand_path(File.join(HOMEDIR, 'clone/lib'))

# Deploy user
DEPLOY_USER     = 'sensu-plugin'
DEPLOY_EMAIL    = 'sensu-plugin@sensu-plugins.io'

SUPPORTED_RUBIES = %w(1.9.3 2.0 2.1 2.2)
