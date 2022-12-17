resource "aws_route53_record" "aliases" {
  for_each = var.aliases
  zone_id  = each.value.parent_zone_id
  name     = each.value.alias
  type     = "A"

  lifecycle {
    ignore_changes = [
      alias
    ]
  }

  alias {
    name                   = each.value.target_dns_name
    zone_id                = each.value.target_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

resource "aws_route53_record" "records" {
  for_each = var.records
  zone_id  = each.value.parent_zone_id
  name     = each.value.alias
  type     = each.value.type

  lifecycle {
    ignore_changes = [
      alias
    ]
  }

  ttl     = 60
  records = each.value.records
}

