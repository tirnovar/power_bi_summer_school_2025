// This file contains your Data Connector logic
[Version = "1.0.0"]
section newsAPI;

[DataSource.Kind="newsAPI", Publish="newsAPI.Publish"]
shared newsAPI.Contents = (optional message as text) =>
    let
        _message = if (message <> null) then message else "(no message)",
        a = "Hello from newsAPI: " & _message
    in
        a;

// Data Source Kind description
newsAPI = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Anonymous = []
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
