# Codebase Structure and Conventions

## Folder and File Structure

### Overall Project Structure
The ALMakeDemo project follows a **flat AL structure** with build automation focus:

```
ALMakeDemo/
├── .aidocs/                    # AI-generated project documentation
├── .alpackages/                # AL package cache (auto-generated)
├── .git/                       # Git version control
├── .github/                    # GitHub workflows and instructions
├── .gitignore                  # Git ignore patterns
├── .snapshots/                 # AL snapshot files (auto-generated)
├── .vscode/                    # VS Code configuration
├── app.json                    # AL app manifest
├── build.log                   # Build output log
├── CustomerListExt.PageExt.al  # Single AL object file
├── Default Publisher_ALMakeDemo_1.0.0.0.app  # Compiled output
├── Makefile                    # Unified build system entry point
├── README.md                   # Project documentation
└── scripts/                    # Build automation scripts
    └── make/
        ├── windows/            # Windows PowerShell scripts
        │   ├── build.ps1
        │   ├── clean.ps1
        │   ├── show-config.ps1
        │   ├── show-analyzers.ps1
        │   └── lib/
        │       ├── common.ps1
        │       └── json-parser.ps1
        └── linux/              # Linux Bash scripts
            ├── build.sh
            ├── clean.sh
            ├── show-config.sh
            ├── show-analyzers.sh
            └── lib/
                ├── common.sh
                └── json-parser.sh
```

### AL Source Organization
- **Flat Structure**: All AL objects are in the root directory (no src/ folder)
- **Single Object**: Currently contains only one AL object file
- **No Functional Grouping**: No subfolders for organizing objects by business area (typical for small demonstration projects)

### Non-AL Project Organization
- **Build Scripts**: Highly organized in platform-specific directories with shared libraries
- **Documentation**: Well-structured with README and generated .aidocs folder
- **Configuration**: Standard AL project configuration files in expected locations

## File Naming Conventions

### AL Object Files
The project demonstrates **correct AL file naming conventions** according to Microsoft best practices:

| Object | File Name | Compliance |
|--------|-----------|------------|
| pageextension 50100 CustomerListExt | `CustomerListExt.PageExt.al` | ✅ **Compliant** |

**Analysis:**
- **Pattern**: `<ObjectName>.<FullTypeName>.al`
- **Object Type Abbreviation**: Uses `PageExt` (correct Microsoft abbreviation for Page Extension)
- **No Prefix/Suffix**: Simple object name without company prefix (acceptable for demo projects)
- **Character Set**: Uses only A-Z, a-z, 0-9 characters as recommended

### Build Script Files
Build automation files follow consistent patterns:
- **Platform Scripts**: `{action}.{ps1|sh}` (e.g., `build.ps1`, `clean.sh`)
- **Shared Libraries**: Descriptive names like `common.ps1`, `json-parser.sh`
- **Cross-Platform Consistency**: Same base names across Windows/Linux implementations

## Object Naming Conventions

### AL Object Names
Current objects follow AL naming best practices:

| Object Type | Object Name | Analysis |
|-------------|-------------|----------|
| Page Extension | `CustomerListExt` | ✅ PascalCase, descriptive, uses "Ext" suffix |

**Compliance Assessment:**
- **PascalCase**: ✅ Correctly applied
- **Descriptive Names**: ✅ Clear indication of purpose
- **Extension Suffix**: ✅ Uses "Ext" to indicate extension object
- **No Prefix**: ✅ Acceptable for demo/learning projects (enterprise projects typically require company prefix)

### Namespace Convention
- **Namespace**: `DefaultPublisher.ALMakeDemo`
- **Pattern**: `{Publisher}.{AppName}`
- **Compliance**: ✅ Follows Microsoft recommended hierarchy
- **Stability**: Good choice for demo project (company.product pattern)

## Variable and Method Naming Conventions

### Variable Naming Analysis
From the single AL file:

```al
field(BalanceDue; Rec."Balance Due")
```

**Assessment:**
- **Field Name**: `BalanceDue` - ✅ PascalCase, no special characters
- **Record Reference**: Uses `Rec.` pattern - ✅ Standard AL pattern
- **Source Field**: `"Balance Due"` - Standard Business Central field name

### Method/Trigger Naming
The OnOpenPage trigger demonstrates standard AL practices:
- **Trigger Names**: Uses built-in trigger naming (OnOpenPage)
- **No Custom Methods**: Project doesn't define custom procedures to evaluate

## Code Formatting and Readability

### AL Code Style Assessment
The CustomerListExt.PageExt.al file demonstrates:

**Positive Practices:**
- ✅ **Lowercase Keywords**: `pageextension`, `extends`, `field`, `begin`, `end`
- ✅ **Four-Space Indentation**: Consistent throughout the file
- ✅ **Curly Brackets on New Lines**: Proper bracket placement for layout sections
- ✅ **Single Statement Per Line**: Each statement on its own line
- ✅ **Proper Spacing**: Appropriate whitespace around operators and keywords

**Code Sample Analysis:**
```al
pageextension 50100 CustomerListExt extends "Customer List"
{
    layout
    {
        addlast(content)
        {
            field(BalanceDue; Rec."Balance Due")
            {
                ApplicationArea = All;
                Caption = 'Balance Due';
                ToolTip = 'Shows the outstanding balance amount for the customer';
            }
        }
    }

    trigger OnOpenPage();
    begin
        Message('App published: Hello world');
    end;
}
```

**Formatting Compliance:**
- ✅ Lowercase keywords throughout
- ✅ Consistent 4-space indentation
- ✅ Proper bracket placement
- ✅ Semicolon usage follows AL conventions
- ✅ Property formatting follows Microsoft guidelines

### Comments and Documentation
- **Header Comments**: Includes standard AL template comments
- **Inline Documentation**: Good use of Caption and ToolTip properties
- **Educational Comments**: References AL snippets and coding guidance

## Internal Object Structure

### Page Extension Structure Analysis
The `CustomerListExt` page extension follows recommended internal structure:

1. **Object Declaration**: `pageextension 50100 CustomerListExt extends "Customer List"`
2. **Layout Section**: Field additions in proper layout structure
3. **Actions Section**: *(not present - acceptable for simple extensions)*
4. **Triggers**: OnOpenPage trigger properly placed
5. **Global Variables**: *(not present - none required)*
6. **Methods**: *(not present - simple extension doesn't require custom methods)*

**Structure Compliance:**
- ✅ **Properties First**: Object-level properties would appear here (none needed)
- ✅ **Layout Before Actions**: Proper section ordering
- ✅ **Triggers After Object Constructs**: OnOpenPage trigger correctly positioned
- ✅ **Clean Organization**: No unnecessary sections included

### Field Definition Structure
The field addition demonstrates proper AL field structure:
```al
field(BalanceDue; Rec."Balance Due")
{
    ApplicationArea = All;
    Caption = 'Balance Due';
    ToolTip = 'Shows the outstanding balance amount for the customer';
}
```

**Analysis:**
- ✅ **Field Syntax**: Correct field(name; source) pattern
- ✅ **Properties Order**: ApplicationArea first (security), then display properties
- ✅ **Caption Property**: Provides user-friendly display name
- ✅ **ToolTip Property**: Includes helpful user guidance
- ✅ **ApplicationArea**: Properly set to `All` for demo purposes

## Summary Assessment

**Strengths:**
- Excellent adherence to Microsoft AL coding standards
- Proper file naming and object naming conventions
- Clean, readable code formatting with consistent indentation
- Good use of namespaces and modern AL features
- Well-structured build automation (though not AL code itself)

**Areas for Expansion (if project grows):**
- Consider adding company prefix for enterprise development
- Implement more complex object relationships to demonstrate broader AL patterns
- Add custom procedures to showcase method naming conventions
- Consider folder structure for organizing objects by business domain

The codebase demonstrates **exemplary AL coding standards** for an educational/demonstration project, making it an excellent reference for developers learning AL development practices.

---

**Navigation:**
- [← Previous: Project Overview](01_project_overview.md)
- [Next: Architecture Analysis →](03_architecture.md)
- [Back to Index ↑](index.md)
