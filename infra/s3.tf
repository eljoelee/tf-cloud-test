resource "aws_s3_bucket" "beer-codebuild-cache" {
    bucket = "beer-codebuild-cache"
}

resource "aws_s3_bucket_acl" "beer-codebuild-cache-acl" {
    bucket = aws_s3_bucket.beer-codebuild-cache.id
    acl    = "private"
}