output "vpc_id" {
    value = aws_vpc.beer.id
}

ouput "subnet_ids" {
    value = aws_subnet.public_beer.*.id
}

output "s3_bucket" {
    value = aws_s3_bucket.beer-codebuild-cache.bucket
}

output "s3_arn" {
    value = aws_s3_bucket.beer-codebuild-cache.arn
}