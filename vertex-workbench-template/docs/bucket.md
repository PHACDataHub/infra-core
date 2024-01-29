# Google Cloud Storage Buckets

## Data Versioning

Data versionsing allows the storage of multiple versions of objects within the GCS bucket. This facilitates data version control, providing a historical record of changes made over time. Versioning enhances data management and recovery capabilities.

## Storage Role-Based Access Control

This section highlights the security features and access control measures to the primary Google Cloud Storage (GCS) bucket in the project to ensure data protection. 

### Personas and Storage Roles

Access control is managed through Google Cloud's IAM (Identity and Access Management) roles. The roles assigned to each persona ensure that they have the appropriate level of access based on their responsibilities.

#### 1. **Service Account in Vertex AI Notebook Instance (Used by Analyst)**

- **Role: Storage Object Admin**
  - **Access:**
    - Read and write access to objects within the GCS bucket.
    - Ability to delete objects within the GCS bucket.
    - Can manage objects from the Vertex AI notebook environment.

#### 2. **Terraform Service Account (Automation/Infrastructure)**

- **Role: Storage Admin**
  - **Access:**
    - Full control over GCS buckets.
    - Can create, delete, and modify storage buckets.
    - Read and write access to all objects within GCS buckets.

#### 3. **Epidemiologist (Console User)**

- **Role: Storage Object Admin**
  - **Access:**
    - Read and write access to objects within the GCS bucket.
    - Ability to upload, download, and delete files through the GCP console.

### Key Security Features

- **Uniform Bucket-Level Access:** Disables ACLs and grants access to the bucket and the data it contains through bucket-level IAM policies.

- **Force Destroy:** When set to `false`, prevents the automatic deletion of the GCS bucket if it contains data. This acts as a safeguard against accidental data loss during bucket deletion, requiring manual intervention for deletion.

- **Public Access Prevention:** Prevents GCS buckets from being exposed to the public. Enforces access only through Access Control Lists (ACLs) or, as in this case, IAM policies.

- **Beyond Corp:** Enable a zero trust security model in the future, through [`BeyondCorp`](https://cloud.google.com/beyondcorp) to restrict user access to the project resources based on [user and device identity](policies-and-procedures.md).