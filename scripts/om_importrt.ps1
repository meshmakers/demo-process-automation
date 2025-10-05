octo-cli -c ImportRt -f ./../data/_general/rt-root-folders.yaml -w
octo-cli -c ImportRt -f ./../data/_general/rt-autoincrement.yaml -w

# Import adapters
octo-cli -c ImportRt -f ./../data/_general/rt-adapters-mesh.yaml -w

# Import pipelines
octo-cli -c ImportRt -f ./../data/_pipelines/rt-pipeline-excel.yaml -w
octo-cli -c ImportRt -f ./../data/_pipelines/upload_accounting_document_v1.yaml -w
octo-cli -c ImportRt -f ./../data/_pipelines/upload_accounting_document_v2.yaml -w
octo-cli -c ImportRt -f ./../data/_pipelines/upload_accounting_document_v3.yaml -w
octo-cli -c ImportRt -f ./../data/_pipelines/detect_anomalies_amount_percent_change.yaml -w
octo-cli -c ImportRt -f ./../data/_pipelines/detect_anomalies_amount_spike_estimation.yaml -w

# Import queries
octo-cli -c ImportRt -f ./../data/_queries/_trees.yaml
octo-cli -c ImportRt -f ./../data/_queries/_accounting_documents_all.yaml
octo-cli -c ImportRt -f ./../data/_queries/_accounting_documents_review.yaml


