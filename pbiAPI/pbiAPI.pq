// This file contains your Data Connector logic
[Version = "1.0.0"]
section pbiAPI;

[DataSource.Kind="pbiAPI", Publish="pbiAPI.Publish"]
shared pbiAPI.Contents = (optional message as text) =>
    let
        _message = if (message <> null) then message else "(no message)",
        a = "Hello from pbiAPI: " & _message
    in
        a;

// Data Source Kind description
pbiAPI = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Anonymous = []
    ]
];

// Data Source UI publishing description
pbiAPI.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = pbiAPI.Icons,
    SourceTypeImage = pbiAPI.Icons
];

pbiAPI.Icons = [
    Icon16 = { Extension.Contents("pbiAPI16.png"), Extension.Contents("pbiAPI20.png"), Extension.Contents("pbiAPI24.png"), Extension.Contents("pbiAPI32.png") },
    Icon32 = { Extension.Contents("pbiAPI32.png"), Extension.Contents("pbiAPI40.png"), Extension.Contents("pbiAPI48.png"), Extension.Contents("pbiAPI64.png") }
];
