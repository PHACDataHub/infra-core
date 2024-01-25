# Policies and Procedures

This document outlines the policies and procedures for ensuring data security. The primary focus is on the mechanisms that enable safe data access restricted to epidemologists involved in the project.

## Policies:

### GCP Environment Access

1. **Access Policy**:
- BeyondCorp enforces Zero Trust security Model, ensuring that no user is trusted to access the GCP environment by default. This trust is determined by user and device identity and other contextual information.
- Context-aware access will be in place restricting access to the GCP environment based on IP. Only devices on the organization VPN will be able to login to the console.

2. **Independent GCP Environment**:
- Each project is isolated by configuring a separate GCP project.
- Only users/epidemologists part of the project are granted access to this environment.

3. **Login Mechanisms**
- Multi-Factor Authentication is setup for all users using a YubiKey, adding an extra layer of security for user login.
- Backup mechanisms can be setup using an Authenticator app.  

### Data Access:

1. **Uploads and Downloads**: 
- Data uoloads and downloads are strictly limited to devices connected to the VPN.
- Access is only granted to specific work devices authorized under the organization policy.

2. **Access Control Lists**:
- Further access can be controled using ACLs that provide access to the storage buckets only to specific group of users.