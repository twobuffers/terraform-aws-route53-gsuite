# needed only for the toolbox url
data "aws_route53_zone" "zone" {
  zone_id = var.zone_id
}

locals {
  # zone_name & domain name
  zone_name = data.aws_route53_zone.zone.name
  # To support Terraform AWS Provider v2.
  # Trailing coma is no longer there in v3:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-3-upgrade#removal-of-trailing-period-in-name-argument
  domain_name = trimsuffix(local.zone_name, ".")
  # toolbox url
  toolbox_url_template    = "https://toolbox.googleapps.com/apps/checkmx/check?domain=%s%s"
  optional_dkim_selector  = var.dkim_selector != null ? "&dkim_selector=${var.dkim_selector}" : ""
  gsuite_toolbox_url      = format(local.toolbox_url_template, local.domain_name, local.optional_dkim_selector)
  verisign_validation_url = "https://dnssec-analyzer.verisignlabs.com/${local.domain_name}"
  ns_tools_url            = "https://ns.tools/${local.domain_name}"
  mail_tester_url         = "https://www.mail-tester.com/"
  intodns_url             = "https://intodns.com/${local.domain_name}"
  dnscheck_url            = "http://www.dnscheck.pro/${local.domain_name}"
}

output "validation_urls" {
  value       = [local.gsuite_toolbox_url, local.verisign_validation_url,
    local.mail_tester_url, local.intodns_url, local.dnscheck_url
  ]
  description = "Direct Link to G Suite Toolbox Check MX tool"
}
