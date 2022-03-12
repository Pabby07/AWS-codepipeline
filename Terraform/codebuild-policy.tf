# esource "aws_iam_role" "tf-codebuild-role" {
#   name = "tf-codebuild-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "codebuild.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF

# }
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
  version = "2012-10-17"
}



resource "aws_iam_role" "codebuild_role" {
  name               = "test-staticwebsite-code-build"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
#   tags = {
#     Stack = local.stack
#   }
}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
    statement{
        sid = ""
        actions = ["cloudwatch:*","logs:*", "s3:*", "codebuild:*", "secretsmanager:*","iam:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
    name = "tf-cicd-build-policy"
    path = "/"
    description = "Codebuild policy"
    policy = data.aws_iam_policy_document.tf-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
    policy_arn  = aws_iam_policy.tf-cicd-build-policy.arn
    role        = aws_iam_role.codebuild_role.id
}

# resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
#     policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
#     role        = aws_iam_role.tf-codebuild-role.id
# }