export PROJECT_ID="avian-cosmos-400510"
export PROJECT_NUMBER="559303572017"
export STATE_BUCKET="gcp_tfstate-bucket"


if gsutil ls -b "gs://$STATE_BUCKET" &>/dev/null; then
  echo "Bucket $STATE_BUCKET already exists."
else
  # Create the bucket
  echo "Creating bucket $STATE_BUCKET..."
  gcloud storage buckets create gs://$STATE_BUCKET --project=$PROJECT_ID --default-storage-class=STANDARD --location=Europe-West3 --uniform-bucket-level-access
  echo "Bucket $STATE_BUCKET created successfully."
fi


gcloud iam workload-identity-pools create github \
    --project=$PROJECT_ID \
    --location="global" \
    --description="GitHub pool" \
    --display-name="GitHub pool"

gcloud iam workload-identity-pools providers create-oidc "github" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="github" \
  --display-name="GitHub provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.workflow_ref=assertion.job_workflow_ref,attribute.event_name=assertion.event_name" \
  --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam service-accounts create tf-plan \
    --project=$PROJECT_ID \
    --description="SA use to run Terraform Plan" \
    --display-name="Terraform Planner"

gcloud iam service-accounts create tf-apply \
    --project=$PROJECT_ID \
    --description="SA use to run Terraform Apply" \
    --display-name="Terraform Applier"

gcloud storage buckets add-iam-policy-binding gs://${STATE_BUCKET} \
  --member=serviceAccount:tf-plan@${PROJECT_ID}.iam.gserviceaccount.com \
  --role=roles/storage.objectAdmin

gcloud storage buckets add-iam-policy-binding gs://${STATE_BUCKET} \
  --member=serviceAccount:tf-apply@${PROJECT_ID}.iam.gserviceaccount.com \
  --role=roles/storage.objectAdmin

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member=serviceAccount:tf-apply@${PROJECT_ID}.iam.gserviceaccount.com \
 --role=roles/iam.serviceAccountAdmin

gcloud iam service-accounts add-iam-policy-binding "tf-plan@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/github/attribute.event_name/pull_request"


gcloud iam service-accounts add-iam-policy-binding "tf-apply@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/github/attribute.workflow_ref/outofdevops/workload-identity-federation/.github/workflows/terraform.yaml@refs/heads/main"