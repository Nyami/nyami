Title: "Custom HTTP Verb"
Published: 2019-03-03
Tags:
- aspnet
- dotnet
---

There are server reasons you might look to implement a custom HTTP Verb in you ASP.NET application, and thankfully with ASP.NET Core it’s incredibly simple.

<!--more-->

Here is a nice simple example of a WEBDAV inspired SEARCH verb, potentially useful if you’re encountering limitations of GET and obviously cant have a GET with body, or want to have consistent verb for whatever reason.

```
public class HttpSearchAttribute : HttpMethodAttribute {

        private static readonly IEnumerable<string> SupportedMethods = new[] { "SEARCH" };

        public HttpSearchAttribute() : base(SupportedMethods) {
        }

        public HttpSearchAttribute(string template) : base(SupportedMethods, template) {
            if (string.IsNullOrWhiteSpace(template)) {
                throw new ArgumentNullException(nameof(template));
            }
        }
    }
```

A fully working, simple example is located over at [GitHub](https://github.com/Nyami/WebApiSearchMethod)