Title: "VueJs and ASP.NET Core - Part 3"
Published: 2019-06-11
Tags:

- aspnet
- dotnet
- VueJs

Image: 'images/VueLogo.png'
RedirectFrom: posts/2019-06-11-VueWithAspNetPart3

---

In parts [1](/posts/2019-05-10-VueWithAspNetPart1) and [2](/posts/2019-05-21-VueWithAspNetPart2) we looked at the experience of creating a new Angular app and some of the differences compared to what's required for Vue. We then went on to create middleware to add support for running the Vue CLI within our ASP.NET application, and then a new project enabling us to successfully run the Vue CLI in development and have the ability to package everything together when publishing our app. In this final part we are going to create a new project template allowing us a quick start for future projects.

<!--more-->

## Creating a Template

Newer versions of the .NET SDK has really simplified template creation, rather than detailing the whole experience here you are probably best referring to the [official documentation](https://docs.microsoft.com/en-us/dotnet/core/tutorials/create-custom-template) however here is an overview of what I've done with a few handy pointers.

1. Create an empty project based on the webapi template
2. Added the package created in Part 2 using `Install-Package Nyami.AspNetCore.VueCliServices`
3. Created a ClientApp using the Vue CLI
4. Added the custom targets into the project file
5. Created the template configuration described [here](https://docs.microsoft.com/en-us/dotnet/core/tutorials/create-custom-template#create-a-template-from-a-project)
   1. When creating the template specify `sourceName`, this should match your root namespace and project file name, when a project is created from the template this will be replaced with the name
   2. `preferNameDirectory` was set to `true`, if no name is provided when the project is created the folder name will be used as the default name
6. Made some minor changes to the wiring everything up in a more realistic way
   1. Place holders for config
   2. Add a call to the API from the Vue component
7. Created nuspec file
   1. Ensure the generated files (bin, obj, node_modules etc) were excluded from the package
8. Published to NuGet

This template can be pulled down from NuGet and installed using the command `dotnet new -i Nyami.AspNetCore.Vue.Template`, once installed you can create a new project using `dotnet new vue`.

## Summary

There are a number of ways to get Vue.js and ASP.NET working together but this approach to works really well allowing you to get up and running with minimal effort and take advantage of Vue's CLI along side Visual Studio's developer experience. I'm not expecting either packages to get a lot of use, they were mainly proving the concept, but if you end up using them and have problems or questions just reach out to me.
