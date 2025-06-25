// This file contains your Data Connector logic
[Version = "1.0.0"]
section pbiRESTapi;

uri = "https://api.powerbi.com/v1.0/myorg";

[DataSource.Kind = "pbiRESTapi", Publish = "pbiRESTapi.Publish"]
shared pbiRESTapi.Navigation = () =>
    let
        objects = #table(
            {"Name", "Key", "Data", "ItemKind", "ItemName", "IsLeaf"},
            {
                {
                    Extension.LoadString("Groups"),
                    "Groups",
                    pbiRESTapi.Groups(),
                    "Table",
                    "Table",
                    true
                },{
                    Extension.LoadString("AvailableFeatures"),
                    "Avaiable Features",
                    pbiRESTapi.AvailableFeatures(),
                    "Table",
                    "Table",
                    true
                }
            }
        ),
        Navigation = Table.ToNavigationTable(objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        Navigation;


[DataSource.Kind = "pbiRESTapi"]
shared pbiRESTapi.Groups = () =>
    let
        call_for_api = Json.Document(Web.Contents(uri, [RelativePath = "groups", Headers=[#"Content-Type"="application/json"]])),
        transformation = #table(
        type table [id = text, isReadOnly = logical, isOnDedicatedCapacity = logical, type = text, name = text],
        List.Transform(
            call_for_api[value]?,
            (row) =>
                {
                    row[id]?,
                    Logical.From(row[isReadOnly]?),
                    Logical.From(row[isOnDedicatedCapacity]?),
                    row[type]?,
                    row[name]?
                }
        )
    )
in
    transformation;

[DataSource.Kind = "pbiRESTapi"]
shared pbiRESTapi.AvailableFeatures = () =>
    let
        call_for_api = Json.Document(Web.Contents(uri, [RelativePath = "availableFeatures", Headers=[#"Content-Type"="application/json"]])),
        transformation = #table(
            type table [name = text, state = text, extendedState = text],
            List.Transform(call_for_api[features]?, (row) => {row[name]?, row[state]?, row[extendedState]?})
        )
    in
        transformation;

// Data Source Kind description
pbiRESTapi = [
    Authentication = [
        Aad = [
            AuthorizationUrl = "https://login.microsoftonline.com/common/oauth2/authorize",
            Resource = "https://analysis.windows.net/powerbi/api"
        ]
    ]
];

// Data Source UI publishing description
pbiRESTapi.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = {Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp")},
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = pbiRESTapi.Icons,
    SourceTypeImage = pbiRESTapi.Icons
];

pbiRESTapi.Icons = [
    Icon16 = {
        Extension.Contents("pbiRESTapi16.png"),
        Extension.Contents("pbiRESTapi20.png"),
        Extension.Contents("pbiRESTapi24.png"),
        Extension.Contents("pbiRESTapi32.png")
    },
    Icon32 = {
        Extension.Contents("pbiRESTapi32.png"),
        Extension.Contents("pbiRESTapi40.png"),
        Extension.Contents("pbiRESTapi48.png"),
        Extension.Contents("pbiRESTapi64.png")
    }
];

Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta [
            NavigationTable.NameColumn = nameColumn,
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn,
            Preview.DelayColumn = itemNameColumn,
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;