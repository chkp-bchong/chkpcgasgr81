resource "aws_cloudformation_stack" "chkp_mgmt_cft_stack" {
  name = "${var.project_name}-mgmt-cft-stack"

  parameters ={
    VPC                       = aws_vpc.cg_vpc.id
    ManagementSubnet          = aws_subnet.cg_mgmt_a_sub.id
    ManagementVersion         = "${var.cpversion}-BYOL"
    ManagementInstanceType    = var.mgmt_size
    ManagementName            = "${var.project_name}-mgmt"
    KeyName                   = var.key_name
    ManagementPasswordHash    = var.password_hash
    Shell                     = "/bin/bash"
    ManagementPermissions     = "Create with read-write permissions"
    ManagementHostname        = "chkp-mgmt"
    AdminCIDR                 = "0.0.0.0/0"
    GatewaysAddresses         = "0.0.0.0/0"
    ManagementBootstrapScript = <<BOOTSTRAP
echo 'mgmt_cli -r true set access-rule layer Network rule-number 1 action "Accept" track "Log"' > /etc/cloudsetup.sh;
echo 'cloudguard on' >> /etc/cloudsetup.sh;
echo 'autoprov-cfg -f init AWS -mn "${var.managementserver_name}" -tn "${var.configurationtemplate_name}" -otp "${var.sic_key}" -ver "${var.cpversion}" -po "Standard" -cn "AWScontroller" -r "ap-southeast-1" -iam' >> /etc/cloudsetup.sh;
echo 'autoprov-cfg -f set template -tn "${var.configurationtemplate_name}" -pp "${var.proxy_port}"' >> /etc/cloudsetup.sh;
echo 'autoprov-cfg -f set template -tn "${var.configurationtemplate_name}" -ia -ips -appi -av -ab' >> /etc/cloudsetup.sh;
chmod +x /etc/cloudsetup.sh;
/etc/cloudsetup.sh > /var/log/cloudsetup.log
BOOTSTRAP
  }

  template_url       = "https://cgi-cfts.s3.amazonaws.com/management/management.yaml"
  capabilities       = ["CAPABILITY_IAM"]
  disable_rollback   = true
  timeout_in_minutes = 50

}

resource "aws_cloudformation_stack" "chkp_in_asg_cft_stack" {
  name = "${var.project_name}-in-asg-cft-stack"

  parameters = {
    VPC                                      = aws_vpc.cg_vpc.id
    GatewaysSubnets                          = join(",", aws_subnet.cg_nb_sub.*.id)
    ControlGatewayOverPrivateOrPublicAddress = "private"
    GatewaysMinSize                          = 1
    GatewaysMaxSize                          = 2
    ManagementServer                         = var.managementserver_name
    ConfigurationTemplate                    = var.configurationtemplate_name
    GatewayName                              = "${var.project_name}-in-asg"
    GatewayInstanceType                      = var.northbound_asg_size
    GatewaysTargetGroups                     = "${aws_lb_target_group.chkp_ext_alb_tg.arn}"
    KeyName                                  = var.key_name
    GatewayPasswordHash                      = var.password_hash
    GatewaySICKey                            = var.sic_key
    GatewayVersion                           = "${var.cpversion}-BYOL"
    Shell                                    = "/bin/bash"
    ELBType                                  = "internal"
    ELBPort                                  = var.proxy_port
    ELBClients                               = "0.0.0.0/0"
  }

  template_url       = "https://cgi-cfts.s3.amazonaws.com/autoscale/autoscale.yaml"
  capabilities       = ["CAPABILITY_IAM"]
  disable_rollback   = true
  timeout_in_minutes = 50
}