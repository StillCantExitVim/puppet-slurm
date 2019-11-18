#
define slurm::gres (
  $gres_name = $name,
  $type = undef,
  $node_name = undef,
  Optional[Enum['nvml']] $auto_detect = undef,
  $count = undef,
  $cores = undef,
  $file = undef,
  $links = undef,
  $switch_name = $name,
  $switches = undef,
  $nodes = undef,
  $link_speed = undef,
  $order = '50',
) {

  include ::slurm

  $conf_values = {
    'Name' => $gres_name,
    'Type' => $type,
    'NodeName' => $node_name,
    'AutoDetect' => $auto_detect,
    'Count' => $count,
    'Cores' => $cores,
    'File' => $file,
    'Links' => $links,
  }

  concat::fragment { "slurm-gres.conf-${name}":
    target  => 'slurm-gres.conf',
    content => template($::slurm::gres_template),
    order   => $order,
  }

}
