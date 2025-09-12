# OctoMesh Construction Kit - Entwicklungshandbuch

## Übersicht
Dieses Dokument dokumentiert das Wissen zur Erstellung von OctoMesh Construction Kits basierend auf der Analyse der bestehenden Implementierungen und der Entwicklung des ProjectManagement Construction Kits.

## 1. Grundstruktur eines Construction Kits

### Verzeichnisstruktur
```
ConstructionKit/
├── ckModel.yaml           # Model-Metadaten und Dependencies
├── types/                 # Entity-Type Definitionen
│   └── *.yaml
├── attributes/            # Attribut-Definitionen
│   └── *.yaml
├── enums/                # Enumeration-Definitionen  
│   └── *.yaml
├── associations/         # Association-Definitionen
│   └── *.yaml
├── records/              # Record (komplexe Typen) Definitionen
│   └── *.yaml
└── AI/                   # Optional: AI-Agent Implementierungen
    └── *.cs
```

## 2. Schema-Definitionen

### 2.1 ckModel.yaml
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-meta.schema.json
modelId: [ModelName]
dependencies:
  - Basic      # Fast immer benötigt für Basis-Typen
  - System     # Für System-Entities
  # - weitere Dependencies nach Bedarf
```

### 2.2 Types (Entitäten)
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
types:
  - typeId: [TypeName]
    derivedFromCkTypeId: Basic/NamedEntity  # oder System/Entity
    isAbstract: false  # true für abstrakte Basisklassen
    description: "Beschreibung der Entität"
    attributes:
      - id: ${thisModel}/[AttributeName]  # Eigene Attribute
        name: [DisplayName]
        isOptional: true/false
        autoIncrementReference: "[SequenceName]"  # Für Auto-IDs
      - id: Basic/[BasicAttribute]  # Wiederverwendung von Basic
        name: [DisplayName]
    associations:
      - id: ${thisModel}/[AssociationName]
        targetCkTypeId: ${thisModel}/[TargetType]
        cardinality: One/ZeroOrOne/ZeroOrMany/Many
      - id: System/ParentChild  # Für hierarchische Beziehungen
        targetCkTypeId: ${thisModel}/[ParentType]
```

### 2.3 Attributes
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
attributes:
  - id: [AttributeName]
    valueType: String/Integer/Decimal/Boolean/DateTime/Enum/Record/BinaryLinked
    valueCkEnumId: ${thisModel}/[EnumName]  # Bei Enum-Type
    valueCkRecordId: ${thisModel}/[RecordName]  # Bei Record-Type
    isMultiValue: true/false  # Für Arrays
    description: "Attribut-Beschreibung"
    defaultValues:
      - [DefaultValue]
    metaData:
      - key: Unit
        value: "EUR/h"  # Einheit
      - key: MinValue
        value: "0"
      - key: MaxValue  
        value: "100"
      - key: semanticId
        value: "0173-1#02-AAO127#003"  # Industrie-Standards
```

### 2.4 Enums
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
enums:
  - enumId: [EnumName]
    description: "Enum-Beschreibung"
    values:
      - key: 0  # Numerischer Schlüssel
        name: [ValueName]
        description: "Wert-Beschreibung"
      - key: 1
        name: [NextValue]
        # ...
```

### 2.5 Associations
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
associationRoles:
  - id: [AssociationName]
    description: "Beziehungsbeschreibung"
    inboundName: [PluralName]  # z.B. "Tasks"
    inboundMultiplicity: N/One/ZeroOrOne
    outboundName: [SingularName]  # z.B. "Project"
    outboundMultiplicity: N/One/ZeroOrOne
```

### 2.6 Records (Komplexe Datentypen)
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
records:
  - recordId: [RecordName]
    description: "Record-Beschreibung"
    attributes:
      - id: ${thisModel}/[AttributeName]
        name: [DisplayName]
        isOptional: true/false
      - id: Basic/[BasicAttribute]
        name: [DisplayName]
      - id: System/KeyValuePair  # Für Dictionary-ähnliche Strukturen
        name: [Name]
        isMultiValue: true
```

## 3. Best Practices

### 3.1 Verwendung von Basic-Typen
**Immer prüfen ob Basic-Typen verwendet werden können:**

#### Häufig verwendete Basic-Types:
- `Basic/NamedEntity` - Für benannte Entitäten (enthält Name + Description)
- `Basic/Document` - Für Dokumente
- `Basic/Person` - Für Personen-Entitäten
- `Basic/Asset` - Für Assets/Ressourcen

#### Häufig verwendete Basic-Attributes:
- `Basic/From`, `Basic/To` - Für Zeitbereiche
- `Basic/TimeRange` - Record für Zeitbereiche
- `Basic/Time` - Einzelne Zeitpunkte
- `Basic/Comment` - Für Kommentare/Notizen
- `Basic/Contact` - Kontaktdaten-Record
- `Basic/Address` - Adress-Record
- `Basic/File` - Für Dateianhänge
- `Basic/CompanyName` - Firmennamen
- `Basic/Email` - E-Mail-Adressen
- `Basic/Phone` - Telefonnummern

### 3.2 Namenskonventionen

#### TypeIds:
- PascalCase: `ProjectDocument`, `Employee`
- Keine Präfixe oder Suffixe

#### Attribute:
- PascalCase für IDs: `ProjectCode`, `TaskStatus`
- camelCase für names in types: `name: projectCode`

#### Enums:
- PascalCase für EnumIds: `ProjectStatus`, `TaskPriority`
- PascalCase für Enum-Values: `InProgress`, `OnHold`

#### Associations:
- Beschreibende Namen: `ProjectTasks`, `TaskAssignee`
- Plural für Collections: `Tasks`, `TeamMembers`
- Singular für Einzelbeziehungen: `Manager`, `Client`

### 3.3 Vererbungshierarchie

```
System/Entity (Basis für alle Entities)
    ├── Basic/NamedEntity (mit Name + Description)
    │   ├── Project
    │   ├── Task
    │   ├── Sprint
    │   └── Risk
    ├── Basic/Document
    │   └── ProjectDocument
    └── Employee (direkt von System/Entity)
```

### 3.4 Association-Patterns

#### One-to-Many (Parent-Child):
```yaml
associations:
  - id: System/ParentChild
    targetCkTypeId: ${thisModel}/ParentType
```

#### Many-to-Many:
```yaml
associationRoles:
  - id: ProjectTeam
    inboundName: TeamMembers
    inboundMultiplicity: N
    outboundName: AssignedProjects
    outboundMultiplicity: N
```

#### Self-Referencing (z.B. Task Dependencies):
```yaml
associations:
  - id: ${thisModel}/TaskDependencies
    targetCkTypeId: ${thisModel}/Task
    cardinality: ZeroOrMany
```

### 3.5 AI-Integration

#### AI-Felder in Entities:
```yaml
attributes:
  - id: RiskScore
    valueType: Decimal
    description: "AI-calculated risk score (0-100)"
    metaData:
      - key: Unit
        value: "%"
      - key: MinValue
        value: "0"
      - key: MaxValue
        value: "100"
      - key: AIGenerated
        value: "true"
```

#### AI-Agent Integration:
- AI-Agents als separate C#-Klassen im AI/ Verzeichnis
- Nutzen die Mesh-API für Datenzugriff
- Schreiben berechnete Werte zurück in AI-Felder

## 4. Entwicklungsprozess

### Schritt 1: Analyse der Anforderungen
- Welche Entities werden benötigt?
- Welche Beziehungen existieren?
- Welche Attribute sind erforderlich?

### Schritt 2: Prüfung vorhandener Basic-Komponenten
```bash
# Basic ConstructionKit analysieren
ls /octo-construction-kit/src/ConstructionKits/Octo.Sdk.Packages.Basic/ConstructionKit/
```

### Schritt 3: Model-Definition
1. `ckModel.yaml` erstellen mit Dependencies
2. Verzeichnisstruktur anlegen

### Schritt 4: Type-Definitionen
1. Abstrakte Basistypen definieren (falls nötig)
2. Konkrete Types mit Vererbung erstellen
3. Basic-Types wiederverwenden wo möglich

### Schritt 5: Attribute-Definitionen
1. Projekt-spezifische Attribute definieren
2. MetaData für Einheiten und Wertebereiche
3. Enums für Status-Werte

### Schritt 6: Associations
1. Beziehungen zwischen Types definieren
2. Kardinalitäten festlegen
3. Bidirektionale Namen vergeben

### Schritt 7: Records für komplexe Datentypen
1. Wiederverwendbare Strukturen identifizieren
2. Records mit eigenen Attributen definieren

### Schritt 8: Validierung
```yaml
# Jede YAML-Datei muss mit $schema beginnen
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
```

## 5. Häufige Fehler und Lösungen

### Fehler 1: Zirkuläre Dependencies
**Problem**: Type A referenziert Type B, Type B referenziert Type A
**Lösung**: Eine Richtung als Association definieren

### Fehler 2: Fehlende Basic-Dependencies
**Problem**: Basic-Attribute verwendet ohne Basic in Dependencies
**Lösung**: In ckModel.yaml hinzufügen:
```yaml
dependencies:
  - Basic
```

### Fehler 3: Doppelte Attribute
**Problem**: Gleiche Attribute in mehreren Types
**Lösung**: Als gemeinsames Attribut definieren und wiederverwenden

### Fehler 4: Falsche Kardinalitäten
**Problem**: One statt ZeroOrOne verwendet
**Lösung**: Immer prüfen ob Beziehung optional sein kann

## 6. Testing und Deployment

### Lokale Validierung:
```bash
# YAML-Syntax prüfen
yamllint ConstructionKit/

# Schema-Validierung (wenn Tool vorhanden)
octomesh validate ./ConstructionKit
```

### Deployment:
```bash
# Zu OctoMesh deployen
octomesh deploy ./ConstructionKit

# Status prüfen
octomesh status ProjectManagement
```

## 7. Beispiel-Implementierung

Das vollständige ProjectManagement ConstructionKit zeigt:
- Vererbung von Basic-Types
- Verwendung von Basic-Attributes
- Komplexe Associations (M:N, Self-References)
- AI-Integration mit berechneten Feldern
- Records für strukturierte Daten
- Proper use of MetaData

Pfad: `/demo-process-automation/src/ProcessAutomationDemo/ConstructionKit/`

## 8. Weiterführende Ressourcen

- OctoMesh Dokumentation: https://docs.meshmakers.io
- Schema-Definitionen: https://schemas.meshmakers.cloud/
- Basic ConstructionKit: `/octo-construction-kit/src/ConstructionKits/Octo.Sdk.Packages.Basic/`
- Energy Community Beispiel: `/octo-construction-kit/src/ConstructionKits/Octo.Sdk.Packages.EnergyCommunity/`

## 9. Checkliste für neue Construction Kits

- [ ] ckModel.yaml mit korrekten Dependencies
- [ ] Alle Types von Basic/System ableiten
- [ ] Basic-Attributes wo möglich verwenden
- [ ] Enums für alle Status-Felder
- [ ] Associations bidirektional definiert
- [ ] Records für komplexe Strukturen
- [ ] MetaData für numerische Werte
- [ ] Beschreibungen für alle Elemente
- [ ] YAML-Schema in jeder Datei
- [ ] Keine zirkulären Dependencies
- [ ] AI-Felder markiert und dokumentiert
- [ ] README.md mit Verwendungsbeispielen