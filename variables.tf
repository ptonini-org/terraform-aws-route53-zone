variable "name" {}

variable "root_records" {
  type     = map(list(string))
  default  = {}
  nullable = false
}

variable "records" {
  type = map(object({
    name    = optional(string)
    type    = optional(string)
    records = set(string)
  }))
  default  = {}
  nullable = false
}