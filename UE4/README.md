# Exercise Goals Overview

### **Exercise 4: Azure Policies**
- **Azure Region:** It should be ensured that only the Azure regions in Europe may be used for the provision of resources.
provision of resources may be used.
- **Azure Storage Account:** Ensure that no storage account can be accessed without authentication (or data in this storage account) can be accessed without authentication.
- **Public IP addresses:** It should be ensured that public IP addresses (type: Public IP Address) can only be made available in a specific resource group.
can be made available.

How can it be ensured that the policies mentioned fulfill the described purpose?
For this purpose, test the policy in which Azure resources are provided against these policies.
are made available. Where and how is the process blocked?




# 🚀 Step by Step in Azure Portal with JSON in policy definitons
## Steps in Azure Portal - Azure Regions
- Go to your subscription 
![Bild1](Pictures\AzureRegion0.png)
- Search for Policies
- Click on Authoring and Definitions and Policy Definition
- Click on Definition Location for the subscription
- Write a Name
- Write a Description
- Choose **Category** and now choose **Create new** or **Use existing** 
- Policy definition is done by ARM-Templates as a JSON file. Information can be found here <a href="[https://www.example.com/my great page](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics?WT.mc_id=Portal-Microsoft_Azure_Policy)">Azure Policy definition structure basics</a>

```json
{
  "properties": {
    "displayName": "Allowed locations",
    "policyType": "BuiltIn",
    "mode": "Indexed",
    "description": "This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region.",
    "metadata": {
      "version": "1.0.0",
      "category": "General"
    },
    "version": "1.0.0",
    "parameters": {
      "listOfAllowedLocations": {
        "type": "Array",
        "metadata": {
          "description": "The list of locations that can be specified when deploying resources.",
          "strongType": "location",
          "displayName": "Allowed locations"
        }
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "location",
            "notIn": "[parameters('listOfAllowedLocations')]"
          },
          {
            "field": "location",
            "notEquals": "global"
          },
          {
            "field": "type",
            "notEquals": "Microsoft.AzureActiveDirectory/b2cDirectories"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
  },
  "id": "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c/versions/1.0.0",
  "type": "Microsoft.Authorization/policyDefinitions/versions",
  "name": "1.0.0"
}
```
#### Steps in Azure Portal - Azure Storage Account
- Same steps as before but the policy definition needs to change here.
- Explanation of the JSON:
  - `displayName`: "Azure Storage Account" → The name of the policy, which helps users identify its purpose.
  - `policyType`: "BuiltIn" → Indicates that this is a built-in policy. If you create a custom policy, this would be "Custom".
  - `mode`: "All" → The policy applies to all resource types within Azure.
  - `metadata`: → Contains additional information about the policy.
  - `category`: "Storage" → Categorizes the policy under "Storage" for easier management.
  - `parameters`: {} → No additional parameters are needed for this policy.
  - `policyRule:` → Defines the logic of the policy.
    - `if:` → Contains conditions that must be met for the policy to apply.
allOf (ensures all conditions must be true):
    - `field`: "type" → Ensures the resource is a Storage Account.
    - `field`: "Microsoft.Storage/storageAccounts/allowBlobPublicAccess" → Checks if public access is enabled (true).
    - `then`: Defines the enforcement action.
    - `effect`: "Deny" → Prevents the creation or modification of a Storage Account if public access is enabled.
```json
{
  "properties": {
    "displayName": "Azure Storage Account",
    "policyType": "Custom",
    "mode": "All",
    "description": "No Public Access to blob containers. ",
    "metadata": {
      "createdBy": "1acd614e-6323-4a7b-8a27-da703d8c982c",
      "createdOn": "2025-02-07T19:41:30.1772229Z",
      "updatedBy": "1acd614e-6323-4a7b-8a27-da703d8c982c",
      "updatedOn": "2025-02-07T19:41:59.856263Z"
    },
    "version": "1.0.0",
    "parameters": {},
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Storage/storageAccounts"
          },
          {
            "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
            "equals": true
          }
        ]
      },
      "then": {
        "effect": "Deny"
      }
    },
    "versions": [
      "1.0.0"
    ]
  },
  "id": "/subscriptions/432242be-a20b-4494-bf1c-2a3f132275c7/providers/Microsoft.Authorization/policyDefinitions/35023602-93b2-4590-a74f-1fd50c1a7a5c",
  "type": "Microsoft.Authorization/policyDefinitions",
  "name": "35023602-93b2-4590-a74f-1fd50c1a7a5c",
  "systemData": {
    "createdBy": "2410781028@hochschule-burgenland.at",
    "createdByType": "User",
    "createdAt": "2025-02-07T19:41:30.1997604Z",
    "lastModifiedBy": "2410781028@hochschule-burgenland.at",
    "lastModifiedByType": "User",
    "lastModifiedAt": "2025-02-07T19:41:59.8334365Z"
  }
}
```

## Steps in Azure Portal - Azure Storage Account
- Same steps as before but the policy definition needs to change here.
- Explanation of the JSON:
  - `displayName`: "Azure Storage Account" → The name of the policy, which helps users identify its purpose.
  - `policyType`: "BuiltIn" → Indicates that this is a built-in policy. If you create a custom policy, this would be "Custom".
  - `mode`: "All" → The policy applies to all resource types within Azure.
  - `metadata`: → Contains additional information about the policy.
  - `category`: "Storage" → Categorizes the policy under "Storage" for easier management.
  - `parameters`: {} → No additional parameters are needed for this policy.
  - `policyRule:` → Defines the logic of the policy.
    - `if:` → Contains conditions that must be met for the policy to apply.
allOf (ensures all conditions must be true):
    - `field`: "type" → Ensures the resource is a Storage Account.
    - `field`: "Microsoft.Storage/storageAccounts/allowBlobPublicAccess" → Checks if public access is enabled (true).
    - `then`: Defines the enforcement action.
    - `effect`: "Deny" → Prevents the creation or modification of a Storage Account if public access is enabled.
```json
{
  "properties": {
    "displayName": "Azure Storage Account",
    "policyType": "Custom",
    "mode": "All",
    "description": "No Public Access to blob containers. ",
    "metadata": {
      "createdBy": "1acd614e-6323-4a7b-8a27-da703d8c982c",
      "createdOn": "2025-02-07T19:41:30.1772229Z",
      "updatedBy": "1acd614e-6323-4a7b-8a27-da703d8c982c",
      "updatedOn": "2025-02-07T19:41:59.856263Z"
    },
    "version": "1.0.0",
    "parameters": {},
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Storage/storageAccounts"
          },
          {
            "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
            "equals": true
          }
        ]
      },
      "then": {
        "effect": "Deny"
      }
    },
    "versions": [
      "1.0.0"
    ]
  },
  "id": "/subscriptions/432242be-a20b-4494-bf1c-2a3f132275c7/providers/Microsoft.Authorization/policyDefinitions/35023602-93b2-4590-a74f-1fd50c1a7a5c",
  "type": "Microsoft.Authorization/policyDefinitions",
  "name": "35023602-93b2-4590-a74f-1fd50c1a7a5c",
  "systemData": {
    "createdBy": "2410781028@hochschule-burgenland.at",
    "createdByType": "User",
    "createdAt": "2025-02-07T19:41:30.1997604Z",
    "lastModifiedBy": "2410781028@hochschule-burgenland.at",
    "lastModifiedByType": "User",
    "lastModifiedAt": "2025-02-07T19:41:59.8334365Z"
  }
}
```
## Steps in Azure Portal - Public IP addresses
### **Explanation of the Policy Definition**

This Azure Policy ensures that **Public IP Addresses** can only be created in a **specific resource group**. If a Public IP Address is created **outside** the allowed resource group, the deployment is denied.

---

#### **1. Policy Metadata**
- `Display Name`: "Restrict Public IP Addresses to Specific Resource Group"  
- `Policy Type`: Custom (user-defined)  
- `Mode`: `"All"`, meaning it applies to all resources  
- `Category`: Network  

---

#### **2. Policy Parameter: Allowed Resource Group**
- Defines a parameter `"allowedResourceGroup"` where Public IPs are allowed.  
- Accepts a **string** as input, which is the name of the allowed resource group.  
- Helps enforce governance by limiting where Public IPs can be created.  

---

#### **3. Policy Rule: Denying Public IPs Outside the Allowed Resource Group**
##### **Conditions (`if` clause)**
- The policy applies only to resources of type **`Microsoft.Network/publicIPAddresses`**.
- It checks the **resource group name** of the Public IP being created.
- If the resource group **does not match** the `"allowedResourceGroup"`, the condition is met.

##### **Enforcement (`then` clause)**
- If the conditions match, the policy applies the **"Deny"** effect.
- This prevents the Public IP Address from being created in unauthorized resource groups.

---
#### **4. Output**
```json
{
  "properties": {
    "displayName": "Restrict Public IP Addresses to Specific Resource Group",
    "policyType": "Custom",
    "mode": "All",
    "metadata": {
      "category": "Network"
    },
    "parameters": {
      "allowedResourceGroup": {
        "type": "String",
        "metadata": {
          "displayName": "Allowed Resource Group",
          "description": "The name of the resource group where public IPs are allowed."
        }
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/publicIPAddresses"
          },
          {
            "not": {
              "value": "[resourceGroup().name]",
              "equals": "[parameters('allowedResourceGroup')]"
            }
          }
        ]
      },
      "then": {
        "effect": "Deny"
      }
    }
  }
}

```
---
#### **5. How the Policy Works**
1. When a **Public IP Address** is being created or updated:
   - Azure checks if the resource type is `"Microsoft.Network/publicIPAddresses"`.
   - It verifies if the resource group matches the allowed one.
   - If the resource group is **not allowed**, the deployment is denied.

2. If a user tries to create a Public IP Address outside the allowed resource group, they will see an **Azure Policy violation** message.

---

#### **6. Example Usage**
##### ✅ **Allowed Configuration**
- **Resource Group:** `"my-secure-rg"`
- **Policy Parameter:** `"allowedResourceGroup": "my-secure-rg"`
- **Result:** Public IP is created successfully.

##### ❌ **Blocked Configuration**
- **Resource Group:** `"test-rg"`
- **Policy Parameter:** `"allowedResourceGroup": "my-secure-rg"`
- **Result:** Deployment **denied** due to policy enforcement.

---

#### **7. Next Steps**
- **Assign the policy** at the subscription or management group level.
- **Test the policy** by attempting to deploy Public IPs in different resource groups.
- **Modify if needed** to allow multiple resource groups or different enforcement actions.




---
