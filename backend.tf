terraform {
  backend "s3" {
    # Prod
    bucket         = "paulonunes12dvptfstate001"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "paulonunes12dvptfstate001"
  }
}
