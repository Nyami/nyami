Title: "VueJs and ASP.NET Core - Part 1"
Published: 2019-05-10
Tags:
- aspnet
- dotnet
- VueJs
Image: 'images/VueLogo.png'
---

Whilst it’s relatively easy to [find and follow a guide]( http://lmgtfy.com/?q=asp.net+core+2+with+vue) to get up and running with Vue and ASP.NET Core, you’ll probably find there are a number techniques, methods, and opinions and there isn’t really the ‘first class’ support and 'simple' method of getting started as there is with Angular. In the following series of posts we’ll take a look at repurposing and using some of Microsoft’s SpaServices to create better support for Vue.js within your new ASP.NET Core project.

<!--more-->

## dotnet new angular ##

Before we get started creating our own stuff for Vue lets look at creating an Angular project using the [Microsoft's template](https://www.nuget.org/packages/Microsoft.DotNet.Web.Spa.ProjectTemplates/) and see what it gives us.

Assuming you have the [.NET Core SDK](https://dotnet.microsoft.com/download) installed (tested with 2.2), at a location of your choosing, drop to your prefered terminal and type `dotnet new angular`. We now have a fairly sparse, and if you've worked with ASP.NET, familiar, project created. Let's break it down a little:

- ClientApp folder - a Hello World Angular app
- Controllers folder - contains a simple api to 'fetch' weather data
- Pages folder - not much here, just the Error page (MVC)
- Properties folder - launchsettings used for debug/development
- wwwroot folder - static assets for the side
- appsettings.json - application setting, appsettings.development.json allows for development time settings
- Foo.csproj - the aspnet project file, more information below
- Program.cs - application entry point
- Startup.cs - Configures services and application request pipeline

If you want to learn more about ASP.NET Core apps the [official documentation](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/?view=aspnetcore-2.2) is the best place to head.

## Startup.cs ##

As with most ASP.NET applications the magic is coordinated in Startup.cs, there are typically two main parts, `ConfigureServices`, where we configure and register services required by our application, and `Configure`, where we configure the request handling pipeline. If you open Startup.cs you'll see the template has added some SPA related code to each of these methods.

In the first block of code, as well as adding MVC configuration, it adds configuration telling the middleware where to expect to find the files for the SPA application.

``` csharp
// This method gets called by the runtime. Use this method to add services to the container.
public void ConfigureServices(IServiceCollection services)
    {
    services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

    // In production, the Angular files will be served from this directory
    services.AddSpaStaticFiles(configuration =>
    {
        configuration.RootPath = "ClientApp/dist";
    });
}
```

In this next block we can see there are two points of interest for our application, `app.UseSpaStaticFiles()`, which uses the configuration above to serve the static files for the SPA and `app.UseSpa` which will return the default SPA page for any unhandled requests, its important this is the last middleware in our pipeline as it essentially acts as a 'catch all' on the assumption the route will be matched by our client side app. You can also see that when in development there is a call `spa.UseAngularCliServer(npmScript: "start")`, this will call the npm script specified, wait for it to start successfully, and will 'proxy' calls in to the webpack web server started, and is what we'll go on to replicate for our Vue implementaion.

``` csharp
public void Configure(IApplicationBuilder app, IHostingEnvironment env)
{
    // Code removed for brevity

    app.UseSpaStaticFiles();

    app.UseMvc(routes => {
        //Code removed for brevity
    });

    app.UseSpa(spa =>
    {
        // To learn more about options for serving an Angular SPA from ASP.NET Core,
        // see https://go.microsoft.com/fwlink/?linkid=864501

        spa.Options.SourcePath = "ClientApp";

        if (env.IsDevelopment())
        {
            spa.UseAngularCliServer(npmScript: "start");
        }
    });
}
```

## .csproj file ##

The project file has a couple of extra targets when compared to a vanilla MVC project file, these are used to assert that npm has been installed when the project is being built and another target is used to add our Angular application to the published output. The project also ensures the ClientApp folder is not handled as part of the default build and publish behaviour.

## But what about Vue? ##

Looking at what Microsoft's template provides this is the exact experience we are hoping to achieve but for Vue. There are really two parts to the Angular and ASP.NET Core story, the SPA middleware that hooks up Webpack at development time and serves the SPA’s static files, and the template getting us up and running ensuring a consistent experience. In the next part we'll take a look at the middleware and see how far it can take us for Vue.