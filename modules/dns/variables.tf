variable "managed_zone" {
  description = "Name of the Cloud DNS managed zone."
  type        = string
}

variable "record_name" {
  description = "Fully qualified record name. Trailing dot is optional."
  type        = string
}

variable "record_type" {
  description = "DNS record type."
  type        = string
  default     = "CNAME"
}

variable "ttl" {
  description = "Time to live for the DNS record."
  type        = number
  default     = 300
}

variable "rrdatas" {
  description = "List of data strings for the DNS record."
  type        = list(string)
}
