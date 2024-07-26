variable "region" {
  type = string
  default = "eu-central-1"
}

variable "s3bucket_name" {
  type = string
  default = "team1-remotestate"
}

variable "dynamo_db_name" {
  type = string
  default = "team1-db_name"
}