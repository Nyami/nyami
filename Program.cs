using Statiq.App;
using Statiq.Common;
using Statiq.Web;

await Bootstrapper
        .Factory
        .CreateWeb(args)
        .DeployToGitHubPages(
                "Nyami",
                "nyami.github.io",
                Config.FromSetting<string>("GITHUB_TOKEN"))
        .RunAsync();