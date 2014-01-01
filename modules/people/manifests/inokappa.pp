class people::inokappa {
  ## osx
  # Finder
  include osx::finder::unhide_library
  class osx::finder::show_all_files {
    include osx::finder
    boxen::osx_defaults { 'Show all files':
      user   => $::boxen_user,
      domain => 'com.apple.finder',
      key    => 'AppleShowAllFiles',
      value  => false,
      notify => Exec['killall Finder'];
    }
  }
  include osx::finder::show_all_files
  include osx::finder::show_hard_drives_on_desktop

  ## Dock
  include osx::dock::autohide
  class { 'osx::dock::position':
    position => 'right'
  }
  class { 'osx::dock::icon_size':
    size => '24'
  }

  class { 'osx::global::natural_mouse_scrolling':
    enabled => false
  }

  # Universal Access
  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom

  # Miscellaneous
  include osx::no_network_dsstores # disable creation of .DS_Store files on network shares
  include osx::software_update # download and install software updates

  # include turn-off-dashboard

  include virtualbox
  include vagrant
  include iterm2::stable
  include sublime_text_2
  sublime_text_2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }
  include chrome
  include thunderbird
  include dropbox
  include evernote
  include skitch
  include quicksilver
  include cyberduck
  include sourcetree

  # via homebrew
  package {
    [
      'tmux',
      'reattach-to-user-namespace', # use tmux to clipbord
      'tree',
      'proctools', # kill by process name. like $ pkill firefox       
      'git-extras',
      'ec2-api-tools',
      'ec2-ami-tools',
      'python',
      'brew-pip',
      'jq'
    ]:
  }

  # exec install awscli
  exec {
    'pip install awscli':
    cwd	   => '/tmp',
    path   => [ '/bin','/usr/bin','/opt/boxen/homebrew/bin' ],
    unless => ['which aws 2>/dev/null']
  } 

  # local application
  package {
    'Kobito':
      source   => "http://kobito.qiita.com/download/Kobito_v1.8.6.zip",
      provider => compressed_app;
    'GoogleJapaneseInput':
      source   => "https://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
      provider => pkgdmg;
  }

  $home     = "/Users/${::boxen_user}"
  $dotfiles = "${home}/.mydotfiles"

  file { $home:
    ensure  => directory
  }

  repository { $dotfiles:
    source  => 'inokappa/my_home_dot_files',
    require => File[$home]
  }

  file { "$home/.tmux.conf":
    ensure => link,
    target => "$dotfiles/tmux.conf",
  }
  file { "$home/.vimrc":
    ensure => link,
    target => "$dotfiles/vimrc",
  }
  file { "$home/.zshrc":
    ensure => link,
    target => "$dotfiles/zshrc",
  }
}
