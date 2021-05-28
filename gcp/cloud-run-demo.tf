locals {
  repo_name = "cloud-run-demo"
  branch_name = "main"
  image = "gcr.io/${var.dev_project}/${local.repo_name}"
}

resource google_cloudbuild_trigger cloud-run-demo-push-trigger {

  trigger_template {
    branch_name = local.branch_name
    repo_name = local.repo_name
  }

  github {
    name = local.repo_name
    owner = "krzysztofmo"
  }

  build {

    # Build the container image
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t",
        local.image,
        "."]
    }

    # Push the container image to Container Registry
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "push",
        local.image
      ]
      timeout = "1200s"
    }

    #Deploy container image to Cloud Run
    step {
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "run",
        "deploy",
        google_cloud_run_service.cloud-run-demo-service.name,
        "--image",
        local.image,
        "--region",
        google_cloud_run_service.cloud-run-demo-service.location,
        "--platform",
        "managed"]
    }
  }
}

resource google_cloud_run_service cloud-run-demo-service {
  name = local.repo_name
  location = module.infra.locationA.region

}