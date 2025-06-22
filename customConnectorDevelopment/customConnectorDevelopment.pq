// This file contains your Data Connector logic
[Version = "1.0.0"]
section customConnectorDevelopment;

[DataSource.Kind="customConnectorDevelopment", Publish="customConnectorDevelopment.Publish"]
shared customConnectorDevelopment.Contents = (optional message as text) =>
    let
        _message = if (message <> null) then message else "(no message)",
        a = "Hello from customConnectorDevelopment: " & _message
    in
        a;

// Data Source Kind description
customConnectorDevelopment = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Anonymous = []
    ]
];

// Data Source UI publishing description
customConnectorDevelopment.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = customConnectorDevelopment.Icons,
    SourceTypeImage = customConnectorDevelopment.Icons
];

customConnectorDevelopment.Icons = [
    Icon16 = { Extension.Contents("customConnectorDevelopment16.png"), Extension.Contents("customConnectorDevelopment20.png"), Extension.Contents("customConnectorDevelopment24.png"), Extension.Contents("customConnectorDevelopment32.png") },
    Icon32 = { Extension.Contents("customConnectorDevelopment32.png"), Extension.Contents("customConnectorDevelopment40.png"), Extension.Contents("customConnectorDevelopment48.png"), Extension.Contents("customConnectorDevelopment64.png") }
];
