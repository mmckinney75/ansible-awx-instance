resource "tls_private_key" "awx_key" {
  algorithm   = "RSA"
  rsa_bits = "2048"
}

# output "awx_key_algorithm" {
#   value = "${tls_private_key.awx_key.algorithm}"
# }
#
# output "awx_key_priv_pem" {
#   value = "${tls_private_key.awx_key.private_key_pem}"
# }
#
# output "awx_key_pub_pem" {
#   value = "${tls_private_key.awx_key.public_key_pem}"
# }
#
# output "awx_key_pub_openssh" {
#   value = "${tls_private_key.awx_key.public_key_openssh}"
# }
#
# output "awx_key_pub_fingerprint" {
#   value = "${tls_private_key.awx_key.public_key_fingerprint_md5}"
# }
