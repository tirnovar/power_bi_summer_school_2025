// This file contains your Data Connector logic
[Version = "1.0.0"]
section newsAPI;

api_uri = "https://newsapi.org/v2";
key = "66019fdbe7fd418caf1dd91179c0fd3e";

[DataSource.Kind="newsAPI", Publish="newsAPI.Publish"]
shared newsAPI.Navigation = () as table =>
    let
        objects = #table(
            {"Name", "Key", "Data", "ItemKind", "ItemName", "IsLeaf"},
            {
                {
                    Extension.LoadString("TopHeadlines"),
                    "TopHeadlines",
                    TopHeadlines(),
                    "Table",
                    "Table",
                    true
                }
            }
        ),
        Navigation = Table.ToNavigationTable(objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        Navigation;

// Functions that will be implemented in Navigation
TopHeadlines = () as table =>
    let
        apiKey = Extension.CurrentCredential()[Key],
        Source = Json.Document(Web.Contents(api_uri,
            [
                RelativePath = "top-headlines",
                Headers = [
                    #"X-Api-Key" = apiKey,
                    #"Content-Type" = "application/json"
                ],
                Query = [
                    country = "us"
                ]
            ]))[articles],
    output = #table(type table[Source = record, Author = text, Title = text, Description = text, Url = text, UrlToImage = text, PublishedAt = datetime, content = text],List.Transform(Source, (row)=> {row[source]?,row[author]?,row[title]?,row[description]?,row[url]?,row[urlToImage]?,DateTime.From(row[publishedAt]?),row[content]?}))
in
    output;

// Data Source Kind description
newsAPI = [
    Authentication = [
        Key = []
        // UsernamePassword = [],
        // Windows = [],
        // Anonymous = []
    ]
];

// Data Source UI publishing description
newsAPI.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = newsAPI.Icons,
    SourceTypeImage = newsAPI.Icons
];

newsAPI.Icons = [
    Icon16 = { Extension.Contents("newsAPI16.png"), Extension.Contents("newsAPI20.png"), Extension.Contents("newsAPI24.png"), Extension.Contents("newsAPI32.png") },
    Icon32 = { Extension.Contents("newsAPI32.png"), Extension.Contents("newsAPI40.png"), Extension.Contents("newsAPI48.png"), Extension.Contents("newsAPI64.png") }
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