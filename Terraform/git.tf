provider "github" {
  token = "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"
}

resource "github_repository" "git_repo" {
  name        = "golang-training"
  visibility = "public"
}