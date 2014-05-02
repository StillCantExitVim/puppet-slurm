# == Class: slurm::slurmdb::config
#
class slurm::slurmdbd::config {

  include slurm

  $log_dir  = $slurm::log_dir
  $log_file = inline_template('<%= File.join(@log_dir, "slurmdbd.log") %>')
  $pid_dir  = $slurm::pid_dir

  File {
    owner => 'slurm',
    group => 'slurm',
  }

  file { $slurm::log_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { $slurm::pid_dir:
    ensure  => 'directory',
    mode    => '0700',
  }

  file { '/etc/slurm/slurmdbd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/slurmdbd.conf.erb'),
    notify  => Service['slurmdbd'],
  }

  if $slurm::manage_logrotate {
    #Refer to: https://computing.llnl.gov/linux/slurm/slurm.conf.html#lbAJ
    logrotate::rule { 'slurmdbd':
      path          => $log_file,
      compress      => true,
      missingok     => true,
      copytruncate  => false,
      delaycompress => false,
      ifempty       => false,
      rotate        => 10,
      sharedscripts => true,
      size          => '10M',
      create        => true,
      create_mode   => '0640',
      create_owner  => 'slurm',
      create_group  => 'root',
      postrotate    => '/etc/init.d/slurmdbd reconfig >/dev/null 2>&1',
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure  => present,
    value   => '1024',
  }
}