class people::inokappa {
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

  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom

  include osx::no_network_dsstores # disable creation of .DS_Store files on network shares
  include osx::software_update # download and install software updates

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
  include ruby

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
      'jq',
      'mysql55',
      'brew-gem'
    ]:
  }

  ruby::gem { "chef for 2.0.0-p247":
    gem     => 'chef',
    ruby    => '2.0.0-p247'
  }
  ruby::gem { "knife-solo for 2.0.0-p247":
    gem     => 'knife-solo',
    ruby    => '2.0.0-p247'
  }
  ruby::gem { "capistrano for 2.0.0-p247":
    gem     => 'capistrano',
    version => '2.15.4',
    ruby    => '2.0.0-p247'
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
    target => "$dotfiles/tmux.conf.mac",
  }
  file { "$home/.vimrc":
    ensure => link,
    target => "$dotfiles/vimrc",
  }
  file { "$home/.zshrc":
    ensure => link,
    target => "$dotfiles/zshrc",
  }

  $tmuxutil = "${home}/.tmux-pbcopy"
  $mybin    = "${home}/bin"
  file { $mybin:
    ensure  => directory
  }
  repository { $tmuxutil:
    source  => 'inokappa/tmux-pbcopy',
    require => File[$home]
  }
  file { "$mybin/tmux-pbcopy":
    ensure => link,
    target => "$tmuxutil/tmux-pbcopy",
    require => File[$mybin]
  }
}
