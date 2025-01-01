output "this" {
  value = aws_route53_zone.this
}

output "policy_arn" {
  value = module.policy.this.arn
}