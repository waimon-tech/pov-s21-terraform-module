provider "aws" {
  alias   = "singapore"
  region  = "ap-southeast-1"
  profile = "lesson-prod-admin"
}

provider "aws" {
  alias   = "tokyo"
  region  = "ap-northeast-1"
  profile = "lesson-prod-admin"
}

provider "aws" {
  alias   = "seoul"
  region  = "ap-northeast-2"
  profile = "lesson-prod-admin"
}