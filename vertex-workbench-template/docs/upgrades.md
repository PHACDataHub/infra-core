# Document with an information how OS Image is Upgraded on Cloud Workstations and User Managed Notebooks

## User Managed Notebooks

1. Manual upgrade. The instance has to meet the [Requirements](https://cloud.google.com/vertex-ai/docs/workbench/user-managed/upgrade#requirements).
   And follow by [Instruction](https://cloud.google.com/vertex-ai/docs/workbench/user-managed/upgrade#manual_upgrade)

2. [Automatic upgrade](https://cloud.google.com/vertex-ai/docs/workbench/user-managed/upgrade#automatic_upgrade) Vertex AI Workbench can automatically upgrade instances that are running. If the instance is stopped, it doesn't automatically upgrade this instance, even if we enable auto upgrade when created the instance. Enable auto upgrade when we create a user-managed notebooks instance. During a recurring time period that we specify, Vertex AI Workbench checks whether your instance can be upgraded, and if so, Vertex AI Workbench upgrades this instance. We also can upgrade user-installed libraries by adding ```--user``` flag [User-installed libraries](https://cloud.google.com/vertex-ai/docs/workbench/user-managed/upgrade#user-installed-libraries)


## Cloud Workstations

Container image updates
Because the workstation container image is pre-pulled onto the pooled VMs, updates to the container image made in the remote image repository with the same image tag are not picked up until all the pooled VMs have been assigned or deleted after 12 hours. At that point, new VMs are created to replenish the pool and pull the updated container image.

To force a pool refresh to pick up the container image updates immediately, administrators can set the ```pool_size``` to ```0```, and then set it back to the preferred ```pool_size```. From the Google Cloud console, ***Disable*** the ***Quick start workstations*** feature in the workstation configuration, save the configuration, set it back to the preferred number, and then save again.

Alternatively, administrators and platform teams can update the image tag in the container.image field in the workstation configuration, which forces a refresh of the pool to pick up the new [container image](https://cloud.google.com/workstations/docs/customize-development-environment#container) tag.

[Cloud Workstations architecture / VPC network](https://cloud.google.com/workstations/docs/architecture#vpc-network)