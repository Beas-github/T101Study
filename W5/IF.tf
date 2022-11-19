cat <<EOT > if.tf
variable "names" {
  description = "T101 member"
  type        = list(string)
  default     = ["gasida", "ongja", "beas"]
}


output "for_directive_index_if_strip" {
  value = <<EOF
%{~ for i, name in var.names ~}
  \${name}%{ if i < length(var.names) - 1 }, %{ endif }
%{~ endfor ~}
EOF
}

EOT