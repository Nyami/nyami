Title: "Solution Wide Project Settings"
Published: 2020-05-04
Tags:

- dotnet
- Tips
- sln
- proj
- productivity

---

When working with larger solutions in Visual Studio there often common properties you want to set across the board for all your project, for example `Copyright` or `TreatWarningsAsErrors`. It can be a little tedious to set these for all the projects, particularly for bigger solutions, and when you add new projects to your solution it's easily missed resulting in undesired differences between projects. A nice simple way to set common properties is to use `Directory.Build.props`.

<!--more-->

Simply create a new file, `Directory.Build.props`, at the root of your solution and populate it with the properties you wish to set, for example:

```xml
<Project>
  <PropertyGroup>
    <TreatWarningsAsErrors>True</TreatWarningsAsErrors>
    <Copyright>Douglas Cameron</Copyright>
  </PropertyGroup>
</Project>
```

Now all projects under this folder will take on these properties, and they can be overridden, or indeed expanded with another `Directory.Build.props` within any subfolder (for example if your unit tests are under a test folder, you could create properties pertaining to these projects there), or via the actual project file.

You could also this file to add common NuGet packages to all your projects, for example if you used [3rd party analyzers](https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview#third-party-analyzers) you could add these here along with any custom rules as required, however you will need to manage the version here and avoid using the NuGet package manager in Visual Studio as this will affect the actual project files.
