output "prometheus_hook_url" {
  value = "${aws_codepipeline_webhook.prometheus.url}"
}
