data "aws_iam_policy_document" "codepipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
  version = "2008-10-17"
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "test-staticwebsite-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json
#   tags = {
#     Stack = local.stack
#   }
}

data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
    # statement{
    #     sid = ""
    #     actions = ["codestar-connections:UseConnection"]
    #     resources = ["*"]
    #     effect = "Allow"
    # }
    statement{
        sid = ""
        actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
    name = "tf-cicd-pipeline-policy"
    path = "/"
    description = "Pipeline policy"
    policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
    policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
    role = aws_iam_role.codepipeline_role.id
}