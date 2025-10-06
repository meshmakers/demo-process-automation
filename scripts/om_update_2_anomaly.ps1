param (
    [string]$configuration = "Release"
)

octo-cli -c importck -f ../src/ProcessAutomationDemo/bin/$configuration/net9.0/octo-ck-libraries/ProcessAutomationDemo/out/ck-accountingdemo.yaml -w

octo-cli -c ImportRt -f ./../data/_pipelines/upload_accounting_document_v3.yaml -w
octo-cli -c ImportRt -f ./../data/_pipelines/detect_anomalies_amount_percent_change.yaml -w
octo-cli -c ImportRt -f ./../data/_pipelines/detect_anomalies_amount_spike_estimation.yaml -w

octo-cli -c ImportRt -f ./../data/_queries/_accounting_documents_all.yaml
octo-cli -c ImportRt -f ./../data/_queries/_accounting_documents_review.yaml
