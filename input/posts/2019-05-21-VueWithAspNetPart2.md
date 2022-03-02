Title: "VueJs and ASP.NET Core - Part 2"
Published: 2019-05-21
Tags:

- aspnet
- dotnet
- VueJs

Image: 'images/VueLogo.png'
RedirectFrom: posts/2019-05-21-VueWithAspNetPart2

---

In [Part 1](/posts/2019-05-10-VueWithAspNetPart1) we looked at the Angular project template with ASP.NET Core and its pretty much what we want to achieve for VueJs. In this part we'll dig a little deeper into [Microsoft.AspNetCore.SpaServices](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.spaservices?view=aspnetcore-2.2), specifically [Microsoft.AspNetCore.SpaServices.AngularCli](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.spaservices.angularcli?view=aspnetcore-2.2) and look to take inspiration for our Vue solution.

<!--more-->

## vue create

Let's start out by trying to use the template created for Angular and swap out the ClientApp for our VueJs app and see what happens.
First we'll create our VueJs application, to do this we'll use the [Vue CLI](https://cli.vuejs.org/), I've used npm to install this as a global tool (`npm install -g @vue/cli`), so it just a case of typing ` vue create hello-world`, where hello-world is the name of your project, at a suitable location in your favourite command prompt. You'll then be prompted a present, I opted for manually selecting feature and chose:

1. Babel, TypeScript, Linter/Formatter
2. Yes to Use class-style component syntax
3. Yes to Use Babel alongside TypeScript for auto-detected polyfills
4. TSLint as linter/formatter config
5. Lint on save
6. Config in dedicated config files

We can have a look at our newly created site if we navigate into the folder and perform an `npm install` before running `npm run serve`, nothing exciting but it should all work.

## dotnet new

Next, we'll create an ASP.NET app using the Angular project template, again, at a suitable location in your favourite command prompt, type `dotnet new angular`. We can open the project and run this in Visual Studio, and as if by magic we have an Angular app running from our ASP.NET project. If we take a look at the build output we should be able to see that an 'npm install' was initiated, this was from the additional target 'DebugEnsureNodeEnv’ in our project file, and if you look though the output for “ASP.NET Core Web Server” you should see that 'ng serve' was called, this call was initiated by the `spa.UseAngularCliServer(npmScript: "start")` call in our startup.cs.

## bait and switch

Now let's replace the Angular ClientApp folder with the contents from the VueJs app created above, and the change the npmScript called by [spa.UseAngularCliServer](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.spaservices.angularcli.angularclimiddlewareextensions.useangularcliserver?view=aspnetcore-2.2) in Startup.cs from "start" to "serve" and see what happens when we run the ASP.NET app.

## fail

Hmmmm.... not much, just the following exception:

```
TimeoutException: The Angular CLI process did not start listening for requests within the timeout period of 50 seconds.
```

But if we take another look at the outputs, we can see that our project has installed the npm packages and has actually started our Vue application on a random port, it would appear that the middleware just hasn't hooked everything up. Thankfully Microsoft has open sourced ASP.NET Core and much of the supporting packages so it doesn’t take much to rummage around the source code for [AngularCliMiddleware](https://github.com/aspnet/AspNetCore/tree/master/src/Middleware/SpaServices.Extensions/src/AngularCli) to realise that the magic to hook everything up is simply a regular expression looking for the confirmation from the Angular CLI output.

## VueCliMiddleware

So let's create our own middleware for Vue, looking though the source code it should be just a case of cloning the AngularCliMiddleware along with the internal supporting classes (unless of course you want to get creative with reflection) and use an appropriate regular expression to capture the Vue CLI start up.

1. Create a new, empty class lib project
2. Add a package reference to [Microsoft.AspNetCore.SpaServices.Extensions (2.2.0)](https://www.nuget.org/packages/Microsoft.AspNetCore.SpaServices.Extensions/2.2.0)
3. Copy AngularCliBuilder.cs, AngularCliMiddleware.cs and AngularCliMiddlewareExtensions.cs and supporting internal classes from https://github.com/aspnet/AspNetCore
4. Rename all the things
5. Replace openBrowserLine Regex with a suitable Vue alternative, I went for `" - Local: (http\\S+)"`

You can now reference this project in any project created from the Angular template after swapping out the Angular ClientApp with you Vue ClientApp and simply change the `spa.UseAngularCliServer(npmScript: "start")` with `spa.UseVueCliServer(npmScript: "serve");`

## Here's one I made earlier

You can check out the version I knocked up [here](https://github.com/Nyami/AspNetCore.VueCliServices), this has also been uploaded to [NuGet](https://www.nuget.org/packages/Nyami.AspNetCore.VueCliServices) so you can get started by pulling this into your own project via the package manager UI or the package manager console using `Install-Package Nyami.AspNetCore.VueCliServices`.

In the [next part](/posts/2019-06-11-VueWithAspNetPart3) we'll take a look at creating a project template to get us up and running even quicker.
