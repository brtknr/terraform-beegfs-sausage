[beegfs_mgmt]
${beegfs_mgmt}
[beegfs_oss]${beegfs_oss}

[cluster_beegfs_mgmt:children]
beegfs_mgmt

[cluster_beegfs_mds:children]
beegfs_mgmt

[cluster_beegfs_oss:children]
beegfs_oss

[cluster_beegfs_client:children]
beegfs_mgmt
beegfs_oss
