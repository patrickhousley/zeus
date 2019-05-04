resource "aws_acm_certificate" "patrickhousley_dev_certificate" {
  domain_name       = "*.patrickhousley.dev"
  validation_method = "EMAIL"

  // We also want the cert to be valid for the root domain even though we'll be
  // redirecting to the www. domain immediately.
  subject_alternative_names = ["patrickhousley.dev"]
}
