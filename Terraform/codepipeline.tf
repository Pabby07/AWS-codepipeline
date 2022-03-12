resource "aws_iam_policy" "s3_access_policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# resource "aws_iam_role_policy_attachment" "codebuild-policy" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = aws_iam_policy.s3_access_policy.arn
# }

# resource "aws_iam_role_policy" "codebuild_role_s3_permissions" {
#   name = "pipeline-bucket-access"
#   role = aws_iam_role.codebuild_role.name
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect   = "Allow",
#         Action   = ["s3:ListBucket"],
#         Resource = [aws_s3_bucket.pipeline_artifacts_bucket.arn]
#       },
#       {
#         Effect   = "Allow",
#         Action   = "s3:*Object",
#         Resource = ["${aws_s3_bucket.pipeline_artifacts_bucket.arn}/*"]
#       }
#     ]
#   })
# }

resource "aws_codepipeline" "static_web_pipeline" {
  name     = "static-web-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
#   tags     = {
#     Environment = var.env
#   }

  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "Branch"               = var.repository_branch
        "Owner"                = var.repository_owner
        "PollForSourceChanges" = "false"
        "Repo"                 = var.repository_name
        "OAuthToken" = "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"
      }
      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "ThirdParty"
      provider  = "GitHub"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "EnvironmentVariables" = jsonencode(
          [
            {
              name  = "environment"
              type  = "PLAINTEXT"
              value = var.env
            },
          ]
        )
        "ProjectName" = "static-web-build"
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "BucketName" = var.static_web_bucket_name
        "Extract"    = "true"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name             = "Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "S3"
      run_order        = 1
      version          = "1"
    }
  }
}


# resource "aws_iam_role_policy" "codebuild-policy" {
#   role = aws_iam_role.codebuild_role.name

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Resource": [
#         "*"
#       ],
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:*"
#       ],
#       "Resource": [
#         "${aws_s3_bucket.pipeline_artifacts_bucket.arn}",
#         "${aws_s3_bucket.pipeline_artifacts_bucket.arn}/*"
#       ]
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "codebuild-policy" {
#   role       = aws_iam_role.codebuild_role.name
#   policy_arn = aws_iam_policy.codebuild-policy.arn
# }