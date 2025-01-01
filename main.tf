resource "aws_route53_zone" "this" {
  name = var.name

  lifecycle {
    ignore_changes = [
      tags["business_unit"],
      tags["product"],
      tags["env"],
      tags_all
    ]
  }
}

module "policy" {
  source  = "app.terraform.io/ptonini-org/iam-policy/aws"
  version = "~> 1.0.0"
  name    = "${var.name}-zone-access-policy"
  statement = [
    {
      effect    = "Allow"
      actions   = ["route53:ListHostedZones", "route53:GetChange"],
      resources = ["*"]
    },
    {
      effect    = "Allow",
      actions   = ["route53:ListResourceRecordSets", "route53:ChangeResourceRecordSets"],
      resources = ["arn:aws:route53:::hostedzone/${aws_route53_zone.this.id}"]
    }
  ]
}

module "root_record" {
  source   = "app.terraform.io/ptonini-org/route53-record/aws"
  version  = "~> 1.0.0"
  for_each = var.root_records
  name     = var.name
  zone_id  = aws_route53_zone.this.id
  type     = each.key
  records  = each.value
}

module "record" {
  source   = "app.terraform.io/ptonini-org/route53-record/aws"
  version  = "~> 1.0.0"
  for_each = var.records
  name     = coalesce(each.value.name, each.key)
  zone_id  = aws_route53_zone.this.id
  type     = each.value.type
  records  = each.value.records
}