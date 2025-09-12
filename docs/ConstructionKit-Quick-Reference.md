# OctoMesh Construction Kit - Quick Reference

## Dateistruktur-Templates

### 1. ckModel.yaml Template
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-meta.schema.json
modelId: [YourModelName]
dependencies:
  - Basic
  - System
  # Add more as needed
```

### 2. Type Definition Template
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
types:
  - typeId: [TypeName]
    derivedFromCkTypeId: Basic/NamedEntity  # or System/Entity
    isAbstract: false
    description: "Type description"
    attributes:
      - id: ${thisModel}/[AttributeName]
        name: [DisplayName]
        isOptional: true
        autoIncrementReference: "[SequenceName]"
      - id: Basic/[ReusedAttribute]
        name: [DisplayName]
    associations:
      - id: ${thisModel}/[AssociationName]
        targetCkTypeId: ${thisModel}/[TargetType]
        cardinality: ZeroOrOne  # One/ZeroOrOne/ZeroOrMany/Many
```

### 3. Attribute Definition Template
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
attributes:
  - id: [AttributeName]
    valueType: String  # String/Integer/Decimal/Boolean/DateTime/Enum/Record
    valueCkEnumId: ${thisModel}/[EnumName]  # For Enum types
    valueCkRecordId: ${thisModel}/[RecordName]  # For Record types
    isMultiValue: false
    description: "Attribute description"
    defaultValues:
      - [value]
    metaData:
      - key: Unit
        value: "EUR"
      - key: MinValue
        value: "0"
      - key: MaxValue
        value: "100"
```

### 4. Enum Definition Template
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
enums:
  - enumId: [EnumName]
    description: "Enum description"
    values:
      - key: 0
        name: [Value1]
        description: "Value description"
      - key: 1
        name: [Value2]
        description: "Value description"
```

### 5. Association Definition Template
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
associationRoles:
  - id: [AssociationName]
    description: "Association description"
    inboundName: [PluralName]  # e.g., "Tasks"
    inboundMultiplicity: N  # N/One/ZeroOrOne
    outboundName: [SingularName]  # e.g., "Project"
    outboundMultiplicity: One  # N/One/ZeroOrOne
```

### 6. Record Definition Template
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
records:
  - recordId: [RecordName]
    description: "Record description"
    attributes:
      - id: ${thisModel}/[AttributeName]
        name: [DisplayName]
        isOptional: false
      - id: Basic/[BasicAttribute]
        name: [DisplayName]
      - id: System/KeyValuePair
        name: [DictionaryField]
        isMultiValue: true
```

## Commonly Used Basic Types & Attributes

### Basic Types to Inherit From:
- `Basic/NamedEntity` - Has Name and Description
- `Basic/Document` - For documents
- `Basic/Person` - For person entities
- `Basic/Asset` - For assets/resources
- `Basic/Tree` - For hierarchical structures
- `System/Entity` - Base for all entities

### Basic Attributes to Reuse:

#### Time-Related:
- `Basic/From` - Start date
- `Basic/To` - End date
- `Basic/Time` - Single datetime
- `Basic/TimeRange` - Time range record

#### Contact-Related:
- `Basic/Contact` - Complete contact record
- `Basic/FirstName` - First name
- `Basic/LastName` - Last name
- `Basic/CompanyName` - Company name
- `Basic/Email` - Email address
- `Basic/Phone` - Phone number
- `Basic/Address` - Address record

#### General:
- `Basic/Comment` - For notes/comments
- `Basic/File` - For file attachments
- `Basic/Temperature` - Temperature values
- `System/Name` - Name field
- `System/Description` - Description field
- `System/Integer` - Integer values
- `System/KeyValuePair` - Key-value pairs

## Value Types Reference

### Primitive Types:
- `String` - Text values
- `Integer` - Whole numbers
- `Decimal` - Decimal numbers
- `Double` - Floating point
- `Boolean` - True/false
- `DateTime` - Date and time
- `Guid` - Unique identifier

### Complex Types:
- `Enum` - Enumeration (requires valueCkEnumId)
- `Record` - Complex type (requires valueCkRecordId)
- `BinaryLinked` - Binary file reference
- `StringArray` - Array of strings (deprecated, use isMultiValue)

## Cardinality Options

For associations in types:
- `One` - Exactly one (required)
- `ZeroOrOne` - Zero or one (optional)
- `ZeroOrMany` - Zero or more
- `Many` - One or more (at least one required)

For association roles:
- `N` - Many
- `One` - Exactly one
- `ZeroOrOne` - Zero or one

## Common Patterns

### Parent-Child Relationship:
```yaml
associations:
  - id: System/ParentChild
    targetCkTypeId: ${thisModel}/ParentType
```

### Self-Referencing (e.g., Dependencies):
```yaml
associations:
  - id: ${thisModel}/Dependencies
    targetCkTypeId: ${thisModel}/SameType
    cardinality: ZeroOrMany
```

### Many-to-Many:
```yaml
# In associationRoles file:
- id: ProjectTeam
  inboundName: TeamMembers
  inboundMultiplicity: N
  outboundName: Projects
  outboundMultiplicity: N
```

### Auto-Increment Field:
```yaml
attributes:
  - id: ${thisModel}/DocumentNumber
    name: DocumentNumber
    autoIncrementReference: "DocumentNumber"
```

## File Naming Conventions

- Types: `[TypeName].yaml` (e.g., `Project.yaml`)
- Attributes: `[Category]Attributes.yaml` (e.g., `ProjectAttributes.yaml`)
- Enums: `[Category]Enums.yaml` (e.g., `ProjectEnums.yaml`)
- Associations: `[Category]Associations.yaml` (e.g., `ProjectAssociations.yaml`)
- Records: `[Category]Records.yaml` (e.g., `ProjectRecords.yaml`)

## Validation Checklist

Before deployment:
- [ ] All files start with `$schema` declaration
- [ ] No circular dependencies
- [ ] All referenced types/attributes/enums exist
- [ ] Dependencies in ckModel.yaml are complete
- [ ] All required fields have values
- [ ] Descriptions provided for all elements
- [ ] MetaData added for numeric fields
- [ ] Default values set where appropriate
- [ ] Cardinalities correctly specified
- [ ] Basic types used where possible