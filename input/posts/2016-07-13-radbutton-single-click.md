Title: "RadButton Single Click"
Published: 2016-07-13 21:55:47 +0100
Tags:
- ASP.NET
- Telerik
- Tips
- Web
RedirectFrom: blog/2016/07/13/radbutton-single-click/index.html
---
A great and easy way to avoid the double-bounce issue and prevent getting duplicate entries etc is to use the [SingleClick](http://demos.telerik.com/aspnet-ajax/button/examples/singleclick/defaultcs.aspx) property of the RadButton.

```
<telerik:RadButton runat="server" ID="btnSend" Text="Send" OnClick="btnSend_Click" SingleClick="true" SingleClickText="Sending...">
</telerik:RadButton>
```

I've no idea how I've not encountered this RadButton setting before now, saves wiring up custom OnClientClick events...