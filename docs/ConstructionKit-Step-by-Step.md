# Construction Kit Erstellungsprozess - Schritt für Schritt

## Kontext
Dieser Guide dokumentiert den exakten Prozess zur Erstellung eines OctoMesh Construction Kits, basierend auf der Entwicklung des ProjectManagement Construction Kits für einen KI-Agenten Kurs.

## Voraussetzungen
- Zugriff auf Basic ConstructionKit: `/octo-construction-kit/src/ConstructionKits/Octo.Sdk.Packages.Basic/`
- Verständnis der YAML-Syntax
- Kenntnis der Domäne (z.B. Projektmanagement)

## Schritt-für-Schritt Anleitung

### Phase 1: Vorbereitung und Analyse

#### 1.1 Basic ConstructionKit analysieren
```bash
# Struktur verstehen
ls /octo-construction-kit/src/ConstructionKits/Octo.Sdk.Packages.Basic/ConstructionKit/

# Wichtige Basic-Types identifizieren
cat types/NamedEntity.yaml  # Basis für benannte Entitäten
cat types/Document.yaml     # Basis für Dokumente
cat types/Person.yaml       # Falls vorhanden

# Wiederverwendbare Attribute finden
cat attributes/Basics.yaml
cat attributes/Contact.yaml
cat attributes/TimeRange.yaml
```

#### 1.2 Domänen-Analyse
Fragen beantworten:
- Welche Hauptentitäten gibt es? (z.B. Project, Task, Employee)
- Welche Beziehungen existieren? (z.B. Project hat Tasks)
- Welche Status/Zustände gibt es? (z.B. TaskStatus: ToDo, InProgress, Done)
- Welche KI-Felder werden benötigt? (z.B. RiskScore, ComplexityScore)

### Phase 2: Grundstruktur erstellen

#### 2.1 Verzeichnisstruktur anlegen
```bash
mkdir -p ConstructionKit/{types,attributes,enums,associations,records}
```

#### 2.2 Model-Definition (ckModel.yaml)
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-meta.schema.json
modelId: ProjectManagement  # Ihr Model-Name
dependencies:
  - Basic    # Fast immer benötigt
  - System   # Für System/Entity
```

### Phase 3: Enumerations definieren

#### 3.1 Status-Enums erstellen
Datei: `enums/ProjectEnums.yaml`
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
enums:
  - enumId: ProjectStatus
    description: "Project status values"
    values:
      - key: 0
        name: Planning
        description: "Project is in planning phase"
      - key: 1
        name: InProgress
        description: "Project is actively being worked on"
      # weitere...
```

**Wichtig**: 
- Keys sind numerisch (0, 1, 2...)
- Names in PascalCase
- Descriptions sind hilfreich für UI

### Phase 4: Attribute definieren

#### 4.1 Kategorisierung
Attribute in logische Gruppen aufteilen:
- ProjectAttributes.yaml
- TaskAttributes.yaml
- EmployeeAttributes.yaml
- CommonAttributes.yaml

#### 4.2 Attribute mit MetaData
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
attributes:
  - id: Budget
    valueType: Decimal
    description: "Total project budget"
    metaData:
      - key: Unit
        value: "EUR"
      - key: MinValue
        value: "0"
```

**Best Practices**:
- Einheiten für numerische Werte angeben
- Min/Max-Werte wo sinnvoll
- Default-Werte für Enums

### Phase 5: Types (Entitäten) definieren

#### 5.1 Vererbungshierarchie planen
```
Basic/NamedEntity (hat Name + Description)
  ├── Project
  ├── Task
  └── Sprint

System/Entity (Basis)
  ├── Employee (nutzt Basic/Contact als Attribut)
  └── Client
```

#### 5.2 Type mit Basic-Attributen
Datei: `types/Project.yaml`
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
types:
  - typeId: Project
    derivedFromCkTypeId: Basic/NamedEntity  # Erbt Name + Description
    description: "Represents a project in the system"
    attributes:
      - id: ${thisModel}/ProjectCode
        name: ProjectCode
        autoIncrementReference: "ProjectCode"  # Auto-ID
      - id: Basic/From  # Wiederverwendung!
        name: StartDate
      - id: Basic/To
        name: Deadline
      - id: ${thisModel}/Budget
        name: Budget
      # KI-Felder
      - id: ${thisModel}/RiskScore
        name: RiskScore
        isOptional: true
    associations:
      - id: ${thisModel}/ProjectTasks
        targetCkTypeId: ${thisModel}/Task
      # weitere...
```

**Wichtige Patterns**:
- `${thisModel}/` für eigene Attribute
- `Basic/` für Basic-Attribute
- `System/` für System-Features

### Phase 6: Associations definieren

#### 6.1 Association Roles
Datei: `associations/ProjectAssociations.yaml`
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
associationRoles:
  - id: ProjectTasks
    description: "Tasks belonging to a project"
    inboundName: Tasks          # Plural auf Projekt-Seite
    inboundMultiplicity: N       # Viele Tasks
    outboundName: Project        # Singular auf Task-Seite
    outboundMultiplicity: One    # Ein Projekt
```

#### 6.2 In Types referenzieren
```yaml
# In Project.yaml
associations:
  - id: ${thisModel}/ProjectTasks
    targetCkTypeId: ${thisModel}/Task
    
# In Task.yaml  
associations:
  - id: System/ParentChild  # Vordefinierte Parent-Child
    targetCkTypeId: ${thisModel}/Project
```

### Phase 7: Records (Komplexe Typen)

#### 7.1 Record definieren
Datei: `records/ProjectRecords.yaml`
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
records:
  - recordId: SkillRecord
    description: "Record type for skill assessment"
    attributes:
      - id: ${thisModel}/SkillName
        name: SkillName
      - id: ${thisModel}/SkillLevel
        name: Level
      - id: Basic/Time  # Basic verwenden!
        name: LastUsed
```

### Phase 8: Integration von Basic-Components

#### 8.1 Checkliste Basic-Verwendung
Vor der Erstellung eigener Attribute prüfen:

**Zeitangaben**:
- ❌ NICHT: `StartDate: DateTime`
- ✅ BESSER: `Basic/From` und `Basic/To`
- ✅ ODER: `Basic/TimeRange` (Record)

**Kontaktdaten**:
- ❌ NICHT: Eigene FirstName, LastName, Email
- ✅ BESSER: `Basic/Contact` (Record mit allem)

**Allgemeine Felder**:
- ❌ NICHT: `Notes: String`
- ✅ BESSER: `Basic/Comment`

### Phase 9: KI-Integration

#### 9.1 KI-Felder markieren
```yaml
attributes:
  - id: RiskScore
    valueType: Decimal
    description: "AI-calculated risk score (0-100)"
    metaData:
      - key: Unit
        value: "%"
      - key: AIGenerated  # Markierung!
        value: "true"
      - key: UpdateFrequency
        value: "hourly"
```

#### 9.2 AI-Agent Ordner
```bash
mkdir ConstructionKit/AI
# C# Agent-Klassen hier ablegen
```

### Phase 10: Validierung und Cleanup

#### 10.1 Schema-Check
Jede YAML-Datei MUSS beginnen mit:
```yaml
$schema: https://schemas.meshmakers.cloud/construction-kit-elements.schema.json
```

#### 10.2 Referenz-Check
- Alle `valueCkEnumId` verweisen auf existierende Enums?
- Alle `targetCkTypeId` verweisen auf existierende Types?
- Alle Attribute in Types sind definiert?

#### 10.3 Cleanup
```bash
# Alte/temporäre Dateien entfernen
rm *.bak
rm sample*.yaml
```

### Phase 11: Dokumentation

#### 11.1 README.md erstellen
Inhalt:
- Übersicht des Construction Kits
- Hauptentitäten und deren Zweck
- KI-Features
- API-Beispiele
- Deployment-Anleitung

## Häufige Stolpersteine

### Problem 1: "Attribute not found"
**Ursache**: Attribut verwendet aber nicht definiert
**Lösung**: In attributes/*.yaml definieren oder Basic-Attribut verwenden

### Problem 2: "Circular dependency"
**Ursache**: A → B → A Beziehung
**Lösung**: Eine Richtung als Association, andere über API

### Problem 3: "Invalid cardinality"
**Ursache**: `cardinality: N` statt `cardinality: Many`
**Lösung**: 
- In types: One/ZeroOrOne/ZeroOrMany/Many
- In associationRoles: N/One/ZeroOrOne

### Problem 4: "Missing dependency"
**Ursache**: Basic-Attribute verwendet ohne Basic in Dependencies
**Lösung**: In ckModel.yaml ergänzen:
```yaml
dependencies:
  - Basic
```

## Deployment

### Lokal testen:
```bash
# YAML-Syntax
yamllint ConstructionKit/

# Wenn OctoMesh CLI vorhanden:
octomesh validate ./ConstructionKit
```

### Deploy zu OctoMesh:
```bash
octomesh deploy ./ConstructionKit
octomesh status ProjectManagement
```

## Zusammenfassung

Die wichtigsten Regeln:
1. **Immer Basic prüfen** bevor eigene Attribute erstellt werden
2. **Schema-Declaration** in jeder YAML-Datei
3. **MetaData** für alle numerischen Attribute
4. **Konsistente Namensgebung** (PascalCase für IDs)
5. **Vererbung nutzen** (NamedEntity für benannte Objekte)
6. **KI-Felder markieren** mit MetaData
7. **Associations bidirektional** definieren
8. **Records für Wiederverwendung** komplexer Strukturen

## Ergebnis
Ein vollständiges, Basic-kompatibles ConstructionKit das:
- OctoMesh Standards folgt
- Basic-Components wiederverwendet
- KI-Integration ermöglicht
- Erweiterbar und wartbar ist