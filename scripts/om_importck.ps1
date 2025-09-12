param (
    [string]$configuration = "Release"
)

octo-cli -c EnableCommunication
octo-cli -c EnableReporting
octo-cli -c importck -f ./ck-basic.yaml -w
octo-cli -c importck -f ../src/ProcessAutomationDemo/bin/$configuration/net9.0/octo-ck-libraries/ProcessAutomationDemo/out/ck-accountingdemo.yaml -w
