param (
    [string]$tenantId = "processautomationdemo"
)
octo-cli -c Create -tid $tenantId -db $tenantId
octo-cli -c EnableCommunication
octo-cli -c EnableReporting

