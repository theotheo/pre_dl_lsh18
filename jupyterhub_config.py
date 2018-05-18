import os
from os.path import join

c.JupyterHub.logo_file = '/logo.png'

# c.JupyterHub.spawner_class='sudospawner.SudoSpawner'

# Github Settings
c.GitHubOAuthenticator.client_id = os.environ['GITHUB_CLIENT_ID']
c.GitHubOAuthenticator.client_secret = os.environ['GITHUB_CLIENT_SECRET']
c.GitHubOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']

# Authentication Setup
c.JupyterHub.authenticator_class = 'oauthenticator.LocalGitHubOAuthenticator'
c.LocalGitHubOAuthenticator.create_system_users = True
c.LocalAuthenticator.add_user_cmd = ['adduser', '-q', '--gecos', '""', '--home', '/hub/home/USERNAME', '--disabled-password']

# c.Spawner.cmd = ['/usr/local/bin/jupyterhub-singleuser']

# Create empty whitelist and setup admin users
c.Authenticator.whitelist = whitelist = set()
c.Authenticator.admin_users = admin = set()
c.JupyterHub.admin_access = True

# Use userlist to determine administrators
with open(join('.', 'userlist')) as f:
    for line in f:
        if not line:
            continue
        parts = line.split()
        name = parts[0]
        if len(parts) > 1 and parts[1] == 'admin':
            admin.add(name)