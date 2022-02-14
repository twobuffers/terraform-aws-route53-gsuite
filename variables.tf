# ------------------------------------------------------------------------------
# Hosted Zone
# ------------------------------------------------------------------------------

variable "zone_id" {
  type        = string
  description = "AWS Hosted Zone ID to store GSuite DNS records"
}

# ------------------------------------------------------------------------------
# MX, SLF, DKIM
# ------------------------------------------------------------------------------

variable "mx_records" {
  type        = list(string)
  description = "List of MX Records"
  default = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM",
  ]
}

variable "mx_verification_record" {
  type        = string
  description = "MX Verification Record (like <something>.mx-verification.google.com)"
  default     = null
}

variable "spf_value" {
  type        = string
  description = "SPF Record for Gmail"
  default     = "v=spf1 include:_spf.google.com ~all"
}

# If you use key longer than 255 chars, you need to break it into two pieces using \"\":
# - https://aws.amazon.com/premiumsupport/knowledge-center/route53-resolve-dkim-text-record-error/
# - https://github.com/hashicorp/terraform-provider-aws/issues/2761
variable "dkim_value" {
  type        = string
  description = "DKIM Identifier Value"
  default     = false
}

variable "dkim_selector" {
  type        = string
  description = "DKIM Identifier Record Key selector (without `._domainkey`)"
  default     = "google"
}

variable "dmarc_value" {
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# DNSSEC-signed MX Records
# More: https://bornoe.org/blog/2019/07/g-suite-dnssec-signed-mx-records/
# ------------------------------------------------------------------------------

variable "dnssec_mx_records" {
  type        = list(string)
  description = "List of MX Records"
  default = [
    "1 mx1.smtp.goog",
    "5 mx2.smtp.goog",
    "5 mx3.smtp.goog",
    "10 mx4.smtp.goog"
  ]
}

variable "use_dnssec_signed_records" {
  type        = bool
  description = "Toggle to enable DNSSEC-signed Records for Gmail"
  default     = false
}

# ------------------------------------------------------------------------------
# GSuite custom URLs
# ------------------------------------------------------------------------------

variable "gsuite_custom_url_cname" {
  type        = string
  description = "CNAME Record for custom Application URLs"
  default     = "ghs.googlehosted.com"
}

variable "custom_subdomain_calendar" {
  type        = string
  description = "Subdomain for custom Calendar URL"
  default     = null
}

variable "custom_subdomain_drive" {
  type        = string
  description = "Subdomain for custom Drive URL"
  default     = null
}

variable "custom_subdomain_groups" {
  type        = string
  description = "Subdomain for custom Groups for Business URL"
  default     = null
}

variable "custom_subdomain_mail" {
  type        = string
  description = "Subdomain for custom Gmail URL"
  default     = null
}

variable "custom_subdomain_sites" {
  type        = string
  description = "Subdomain for custom Sites URL"
  default     = null
}

# ------------------------------------------------------------------------------
# Misc
# ------------------------------------------------------------------------------

variable "ttl" {
  type        = string
  description = "TTL"
  default     = "3600"
}
