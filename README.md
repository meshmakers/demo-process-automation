# Process Automation Demo - Construction Kit

A comprehensive hands-on demonstration of OctoMesh Process Automation featuring an accounting document processing construction kit with AI-powered anomaly detection capabilities.

## Overview

This demo showcases a complete process automation solution built on the OctoMesh platform, including:

- **Construction Kit**: Pre-built accounting domain model with document processing capabilities
- **AI Pipelines**: Intelligent document analysis and anomaly detection
- **Runtime Data**: Sample queries, pipelines, and test data for immediate experimentation
- **Automation Scripts**: PowerShell scripts for rapid tenant setup and data import

## Quick Start

### Prerequisites

- OctoMesh CLI (`octo-cli`) installed and configured
- PowerShell Core
- .NET 9.0 SDK (for building the construction kit)

### 1. Create Tenant

```powershell
cd scripts
.\om_create_tenants.ps1
```

This creates a new tenant named `processautomationdemo` with communication and reporting enabled.

### 2. Import Construction Kit Models

```powershell
.\om_importck.ps1
```

Import the basic construction kit and the custom accounting demo model including:
- Basic types and attributes
- Accounting document entities
- AI-enabled analysis fields

### 3. Import Runtime Data

```powershell
.\om_importrt.ps1
```

Loads sample data including:
- Document processing pipelines
- Anomaly detection algorithms
- Pre-configured queries
- Mesh adapters

## Components

### Construction Kit

The accounting demo construction kit includes:

- **Document Types**: Invoice, Receipt, Contract processing
- **AI Analysis**: Anomaly detection, amount validation, pattern recognition
- **Workflow Integration**: Automated document routing and approval flows

### Pipelines

| Pipeline                                   | Description                                                |
|--------------------------------------------|------------------------------------------------------------|
| `upload_accounting_document_v1`            | Initial version document upload                            |
| `upload_accounting_document_v2`            | Enhanced document upload with metadata extraction          |
| `upload_accounting_document_v3`            | Enhanced document upload with complete metadata extraction |
| `detect_anomalies_amount_percent_change`   | Percentage-based anomaly detection                         |
| `detect_anomalies_amount_spike_estimation` | Statistical spike detection                                |

### Sample Queries

- `_accounting_documents_all.yaml`: Complete document listing
- `_accounting_documents_review.yaml`: Documents requiring review
- `_trees.yaml`: Hierarchical data structures

## Project Structure

```
demo-process-automation/
├── src/ProcessAutomationDemo/          # Construction kit source
│   └── ConstructionKit/                # YAML model definitions
├── scripts/                            # Automation scripts
│   ├── om_create_tenants.ps1           # Tenant creation 
│   ├── om_delete_tenants.ps1           # Delete demo tenant
│   ├── om_importck.ps1                 # Construction kit import
│   ├── om_importrt.ps1                 # Runtime data import
│   └── upload*.ps1                     # File upload utilities
├── data/                               # Sample runtime data
│   ├── _pipelines/                     # AI processing pipelines
│   ├── _queries/                       # Pre-built queries
│   ├── _general/                       # Configuration data
│   └── testFiles/                      # Sample documents
└── docs/                               # Further documentation
```

## Development Workflow

### Building the Construction Kit

```bash
cd src/ProcessAutomationDemo
dotnet build --configuration Release
```

The build process generates the deployable construction kit YAML files in the output directory.

### Customizing the Model

1. Edit YAML files in `src/ProcessAutomationDemo/ConstructionKit/`
2. Rebuild the project
3. Re-import using `om_importck.ps1`

### Adding New Pipelines

1. Create new pipeline YAML files in `data/_pipelines/`
2. Update `om_importrt.ps1` to include the new pipeline
3. Re-run the import script

## Demo Units

### Unit 1: Invoice Import - Comparing Basic vs AI-Enhanced Processing

This unit demonstrates two different approaches to invoice processing:

#### Basic Invoice Upload (`uploadFile.ps1`)

Simple document upload without data extraction:

```powershell
.\uploadFile.ps1 -file "..\data\testFiles\0_initial\DemoRechnung.pdf"
```

**Pipeline Features (v1):**
- Direct PDF upload to `/uploadaccountingdocument`
- Creates `AccountingDocument` with default values (`GrossTotal = 0`)
- Stores file in FileSystem under "Accounting" folder
- Links document to file via association
- **Use Case**: Fast upload when manual data entry is acceptable

#### AI-Enhanced Invoice Upload (`uploadFilev2.ps1`)

Intelligent document processing with automatic data extraction:

```powershell
.\uploadFilev2.ps1 -file "..\data\testFiles\0_initial\DemoRechnung.pdf"
```

**Pipeline Features (v2):**
- Enhanced PDF upload to `/uploadaccountingdocumentv2`
- **OCR Text Recognition** - Extracts all text from PDF
- **AI-Powered Data Extraction** using Anthropic AI to extract:
  - `transactionDate`: Invoice date
  - `companyName`: Vendor company name
  - `companyAddress`: Company address
  - `grossTotal`: Total amount including tax
  - `netTotal`: Net amount before tax
  - `taxAmount`: Tax amount
- Creates `AccountingDocument` with **real extracted data**
- **Use Case**: Fully automated processing for high-volume scenarios

#### Comparison Table

| Feature              | Basic Upload (v1)            | AI-Enhanced (v2)                  |
|----------------------|------------------------------|-----------------------------------|
| **Speed**            | Fast                         | Slower (OCR + AI processing)      |
| **Data Extraction**  | None - manual entry needed   | Automatic field extraction        |
| **Accuracy**         | Depends on manual input      | AI-based extraction accuracy      |
| **Cost**             | Low                          | Higher (AI API usage)             |
| **Automation Level** | Minimal                      | Full automation                   |
| **Best For**         | Small volumes, manual review | High volumes, automated workflows |

#### Test Instructions

1. Upload the same invoice with both methods:
   ```powershell
   # Basic upload
   .\uploadFile.ps1 -file "..\data\testFiles\0_initial\DemoRechnung.pdf"

   # AI-enhanced upload
   .\uploadFilev2.ps1 -file "..\data\testFiles\0_initial\DemoRechnung.pdf"
   ```

2. Compare the created `AccountingDocument` entities in the system
3. Observe the difference in `GrossTotal` and other extracted fields

### Unit 2: Bulk Import with Enhanced Data Extraction

This unit demonstrates bulk document processing using the most advanced pipeline (v3) which extracts comprehensive accounting data for anomaly detection scenarios.

#### Enhanced Bulk Upload (`uploadDirectoryv3.ps1`)

Process multiple invoices simultaneously with comprehensive data extraction:

```powershell
.\uploadDirectoryv3.ps1 -tenantId "processautomationdemo" -baseUrl "https://assets.staging.meshmakers.cloud" -directory "..\data\testFiles\1_anomalies\interval\"
```

**Pipeline Features (v3):**
- Bulk PDF upload to `/uploadaccountingdocumentv3`
- **Enhanced OCR Processing** with confidence scoring
- **Advanced AI Extraction** using comprehensive JSON schema
- **Complete Data Model Population** including:
  - **Amount Details**: `grossTotal`, `netTotal`, `taxTotal`
  - **Bank Information**: `accountHolder`, `iban`
  - **Issuer Details**: `companyName`, complete address structure
  - **Transaction Data**: `date`, `number`
  - **Document State**: Automatically set to `NEW`

#### Advanced Data Extraction Schema

The v3 pipeline extracts a comprehensive data structure:

```json
{
  "amount": {
    "grossTotal": 1200.00,
    "netTotal": 1000.00,
    "taxTotal": 200.00
  },
  "bankAccount": {
    "accountHolder": "Company Name",
    "iban": "AT741233964761549439"
  },
  "issuer": {
    "companyName": "Invoice Issuer",
    "address": {
      "street": "Main Street 123",
      "zipcode": 5020,
      "cityTown": "Salzburg",
      "nationalCode": "AT"
    }
  },
  "transaction": {
    "date": "2025-09-30",
    "number": "inv-20250930-abc"
  }
}
```

#### Script Features

**Batch Processing:**
- Processes all PDF files in specified directory
- Configurable file filter (default: `*.pdf`)
- Progress tracking with success/failure counts
- Detailed error handling and reporting

**Results Export:**
- Generates timestamped CSV report: `upload_results_YYYYMMDD_HHMMSS.csv`
- Tracks status, response, and errors for each file
- Useful for audit trails and troubleshooting

#### Usage Example

```powershell
# Upload all anomaly test files
.\uploadDirectoryv3.ps1 -tenantId "processautomationdemo" -baseUrl "https://assets.staging.meshmakers.cloud" -directory "..\data\testFiles\1_anomalies\interval"

# Custom directory with different base URL
.\uploadDirectoryv3.ps1 -tenantId "processautomationdemo" -baseUrl "https://assets.staging.meshmakers.cloud" -directory "..\data\testFiles\1_anomalies\amounts"

# Upload only specific file types
.\uploadDirectoryv3.ps1 -tenantId "processautomationdemo" -baseUrl "https://assets.staging.meshmakers.cloud" -directory "..\data\testFiles\1_anomalies\iban" -filter "*.pdf"
```

#### Expected Results

After processing, you'll have:
1. **10 AccountingDocument entities** with complete extracted data
2. **Comprehensive metadata** for anomaly detection algorithms
3. **CSV report** with processing results
4. **FileSystem storage** of all uploaded PDFs

This dataset is specifically designed to trigger the anomaly detection pipelines in subsequent demo units.

### Unit 3: Anomaly Detection - ML.NET vs Statistical Approaches

After importing data with Unit 2, this unit demonstrates two different approaches to anomaly detection in the uploaded accounting documents.

#### ML.NET Spike Detection (`detect_anomalies_amount_spike_estimation`)

Advanced machine learning-based anomaly detection using ML.NET algorithms:

**Pipeline Execution:**
```bash
octo-cli -c ExecutePipeline -n detect_anomalies_amount_spike_estimation
```

**ML.NET Features:**
- **Spike Detection**: Uses `MachineLearningAnomalyDetection@1` transformer
- **Advanced Algorithm**: ML.NET's time series anomaly detection models
- **Statistical Parameters**:
  - `detectSpikes: true` - Focuses on sudden value increases
  - `detectChangePoints: false` - Ignores gradual trend changes
  - `minDataPoints: 3` - Minimum samples needed for analysis
  - `pValueHistoryLength: 3` - Statistical significance window

**Detection Logic:**
- Groups documents by `Issuer.CompanyName`
- Analyzes `GrossTotal` amounts within each company group
- Calculates anomaly scores with statistical confidence levels
- Provides detailed metrics: `level`, `score`, `pValue`

#### Statistical Percent Change Detection (`detect_anomalies_amount_percent_change`)

Simple but effective statistical anomaly detection:

**Pipeline Execution:**
```bash
octo-cli -c ExecutePipeline -n detect_anomalies_amount_percent_change
```

**Statistical Features:**
- **Percent Change Method**: Uses `StatisticalAnomalyDetection@1` transformer
- **Threshold-Based**: Configurable percentage deviation detection
- **Simple Algorithm**: Basic statistical comparison
- **Parameters**:
  - `method: PercentChange` - Compares values to historical average
  - `threshold: 50.0` - Deviations >50% trigger anomalies
  - `minSamples: 2` - Minimal data requirement for testing

**Detection Logic:**
- Groups documents by `Issuer.CompanyName`
- Calculates average `GrossTotal` per company
- Flags invoices deviating >50% from company average
- Simple percentage-based scoring

#### Comparison: ML.NET vs Statistical Approaches

| Aspect                   | ML.NET Spike Detection        | Statistical Percent Change     |
|--------------------------|-------------------------------|--------------------------------|
| **Algorithm Complexity** | Advanced ML models            | Simple statistical comparison  |
| **Detection Method**     | Time series spike analysis    | Percentage deviation from mean |
| **Accuracy**             | High (considers patterns)     | Good (threshold-based)         |
| **Setup Complexity**     | Moderate                      | Simple                         |
| **Performance**          | Slower (ML processing)        | Fast                           |
| **False Positives**      | Lower (context-aware)         | Higher (simple threshold)      |
| **Minimum Data**         | 3 data points                 | 2 data points                  |
| **Best For**             | Complex patterns, time series | Quick setup, simple rules      |

#### Anomaly Response Actions

Both pipelines perform identical actions when anomalies are detected:

1. **Document Status Update**: Changes `DocumentState` from `NEW` to `REVIEW`
2. **Comment Addition**: Adds descriptive comment explaining the anomaly:
   - **ML.NET**: "Invoice amounts are out of range with level X, score Y, pValue Z"
   - **Statistical**: Includes reason and deviation percentage
3. **Workflow Trigger**: Documents enter review queue for manual inspection

#### Testing with Sample Dataset

The `1_anomalies/interval/` dataset is designed to trigger both detection methods:

**Normal Pattern**: Monthly invoices (Jan-Apr) from Delta Energie
**Anomaly Pattern**: Multiple invoices in May 2023 (11th-15th)

Expected results:
- **Spike Detection**: Identifies frequency anomaly in May billing
- **Percent Change**: May detect amount variations if present

#### Demo Workflow

1. **Import Data** (Unit 2):
   ```powershell
   .\uploadDirectoryv3.ps1 -tenantId "processautomationdemo" -baseUrl "https://assets.staging.meshmakers.cloud" -directory "..\data\testFiles\1_anomalies\interval\"
   ```

2. **Run ML.NET Detection**:

    Run the ML.NET-based anomaly detection pipeline using the AdminPanel.

3. **Reset for Re-testing**:
   ```powershell
   .\reset-review-documents.ps1 -AuthToken "your-token"
   ```

4. **Run Statistical Detection**:

    Run the statistical anomaly detection pipeline using the AdminPanel.

5. **Review Results**: Query documents with `DocumentState = "REVIEW"`

6. **Reset for Re-testing**:
   ```powershell
   .\reset-review-documents.ps1 -AuthToken "your-token"
   ```

This demonstrates how different anomaly detection approaches can be applied to the same dataset, 
showcasing the flexibility of the OctoMesh platform for various analytical needs.

## File Upload Utilities

Additional PowerShell scripts for document management:

- `uploadFile.ps1`: Basic single file upload (Pipeline v1)
- `uploadFilev2.ps1`: AI-enhanced single file upload (Pipeline v2)
- `uploadDirectoryv3.ps1`: Batch directory upload
- `reset-review-documents.ps1`: Reset documents from REVIEW status back to NEW

### Document Status Management

The `reset-review-documents.ps1` script allows you to reset all documents that are in "REVIEW" status back to "NEW" status. This is useful for demo purposes when you want to restart the review workflow.

**Usage:**
```powershell
.\reset-review-documents.ps1 -AuthToken "your-jwt-token"
```

**Optional Parameters:**
- `-BaseUri`: OctoMesh server base URI (default: `https://localhost:5001`)
- `-tenant`: Tenant name (default: `processautomationdemo`)

**What it does:**
1. Queries all `AccountingDocument` entities with `documentState = "REVIEW"`
2. Updates each document to set:
   - `documentState = "NEW"`
   - `comment = null`
3. Reports the number of successfully reset documents

**Note:** This script requires authentication. You'll need to obtain a valid JWT token from your OctoMesh instance:

```powershell
# Example to get a token (adjust parameters as needed)
octo-cli -c auth-status
```

## Cleanup

To remove the demo tenant:

```powershell
.\om_delete_tenants.ps1
```

## Advanced Features

### AI Integration

The construction kit demonstrates several AI capabilities:

- **Document Classification**: Automatic document type detection
- **Data Extraction**: Key-value pair extraction from documents
- **Anomaly Detection**: Statistical analysis for unusual patterns
- **Quality Scoring**: Automated document quality assessment

### Extensibility

The demo is designed for extension:

- Add new document types by extending the construction kit
- Create custom AI pipelines for specific business rules
- Integrate with external systems via mesh adapters
- Build custom queries for specific reporting needs

## Documentation

Detailed documentation is available in the `docs/` directory:

- `ConstructionKit-Step-by-Step.md`: Complete construction kit development guide
- `ConstructionKit-Development-Guide.md`: Advanced development patterns
- `ConstructionKit-Quick-Reference.md`: API reference and examples

## Support

For issues and questions:

- Review the documentation in the `docs/` folder
- Check the OctoMesh documentation
- Examine the sample data files for usage patterns

This demo provides a complete foundation for building sophisticated process automation solutions with AI capabilities using the OctoMesh platform.