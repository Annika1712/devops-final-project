variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "arn_administrators" {
  description = "arn of the user, for example arn:aws:iam::111122223333:user/my-user. Run in CLI aws iam get-user or aws iam get-group"
  type        = set(string)
  default = [
    "arn:aws:iam::851725332718:user/annika",
    "arn:aws:iam::851725332718:user/olha",
    "arn:aws:iam::851725332718:user/chi",
    "arn:aws:iam::851725332718:user/frahan"
  ]

}
