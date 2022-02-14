# ------------------------------------------------------------------------------
# Set MX records
# ------------------------------------------------------------------------------

locals {
  mx_verification_records = var.mx_verification_record != null ? [var.mx_verification_record] : []
  gsuite_records          = var.use_dnssec_signed_records ? var.dnssec_mx_records : var.mx_records
  final_mx_records        = concat(local.gsuite_records, local.mx_verification_records)
}

resource "aws_route53_record" "mx" {
  zone_id = var.zone_id
  name    = ""
  type    = "MX"
  records = local.final_mx_records
  ttl     = "3600"
}

# ------------------------------------------------------------------------------
# Sender Policy Framework (SPF)
# Protect against forged emails & make sure messages aren't marked as spam
# https://support.google.com/a/answer/33786
# ------------------------------------------------------------------------------

resource "aws_route53_record" "txt_spf" {
  count   = var.spf_value != null ? 1 : 0
  zone_id = var.zone_id
  name    = ""
  type    = "TXT"
  records = [var.spf_value]
  ttl     = "3600"
}

resource "aws_route53_record" "spf" {
  count   = var.spf_value != null ? 1 : 0
  zone_id = var.zone_id
  name    = ""
  type    = "SPF"
  records = [var.spf_value]
  ttl     = "3600"
}

# ------------------------------------------------------------------------------
# DomainKeys Identified Mail (DKIM) standard
# Set up DKIM to prevent email spoofing
# https://support.google.com/a/answer/174124?hl=en
#
# Google Admin DKIM:
# https://admin.google.com/ac/apps/gmail/authenticateemail
#
# To check:
#     dig google._domainkey.rynkowski.pl txt
# or
#     nslookup -q=TXT google._domainkey.rynkowski.pl
#
# Warning!
# If you use key longer than 255 chars, you need to break it into two pieces using \"\":
# - https://aws.amazon.com/premiumsupport/knowledge-center/route53-resolve-dkim-text-record-error/
# - https://github.com/hashicorp/terraform-provider-aws/issues/2761
# ------------------------------------------------------------------------------

resource "aws_route53_record" "dkim" {
  count   = var.dkim_value != null ? 1 : 0
  zone_id = var.zone_id
  name    = "${var.dkim_selector}._domainkey"
  type    = "TXT"
  records = [var.dkim_value]
  ttl     = "3600"
}

# ------------------------------------------------------------------------------
# Domain-based Message Authentication, Reporting & Conformance (DMARC)
# Specifies how your domain handles suspicious emails.
# https://support.google.com/a/answer/2466563
# ------------------------------------------------------------------------------

resource "aws_route53_record" "dmarc" {
  count   = var.dmarc_value != null ? 1 : 0
  zone_id = var.zone_id
  name    = "_dmarc"
  type    = "TXT"
  records = [var.dmarc_value]
  ttl     = "3600"
}

# ------------------------------------------------------------------------------
# GSuite custom URLs
#
# GSuite docs about creating custom URLs:
# https://support.google.com/a/answer/53340?hl=en
#
# Google Admin Custom URLs:
# https://admin.google.com/ac/accountsettings/customurl
# ------------------------------------------------------------------------------

locals {
  custom_subdomain_list = concat(
    var.custom_subdomain_calendar != null ? [var.custom_subdomain_calendar] : [],
    var.custom_subdomain_drive != null ? [var.custom_subdomain_drive] : [],
    var.custom_subdomain_mail != null ? [var.custom_subdomain_mail] : [],
    var.custom_subdomain_groups != null ? [var.custom_subdomain_groups] : [],
    var.custom_subdomain_sites != null ? [var.custom_subdomain_sites] : [],
  )
}

resource "aws_route53_record" "custom_subdomain" {
  for_each = toset(local.custom_subdomain_list)
  zone_id  = var.zone_id
  name     = each.value
  type     = "CNAME"
  records  = [var.gsuite_custom_url_cname]
  ttl      = "3600"
}

# ------------------------------------------------------------------------------
# TOOLS TO VERIFY DNS RECORDS
# ------------------------------------------------------------------------------
#
# Google Toolbox to check the setup
# Example: https://toolbox.googleapps.com/apps/checkmx/check?domain=rynkowski.pl&dkim_selector=google
#
# Verisign Domain check
# Example: https://dnssec-analyzer.verisignlabs.com/rynkowski.pl
#
# NS.TOOLS
# Example: https://ns.tools/rynkowski.pl
#
# Mail-tester - tests by sending an email to tmp address
# Link: https://www.mail-tester.com/
#
# intodns.com
# Example: https://intodns.com/rynkowski.pl
#
# nscheck.pro - very comprehensive check of the DNS records
# Example: http://www.dnscheck.pro/rynkowski.pl
# ------------------------------------------------------------------------------
