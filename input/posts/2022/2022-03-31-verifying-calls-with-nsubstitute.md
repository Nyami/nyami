Title: Verifying calls with NSubstitute
Published: 2022-03-31
Tags:

- unit testing
- tips
- NSubstitute

---

This one came up recently so I thought I would do a post for my future self, so I have something to come back to. Being a conscientious developer [^1] I was creating unit tests and I found a situation where I wanted to verify the call to a method was the expected call, in this case the functionality being tested was creating an object and then calling a repository to persist this, I needed to check the object being persisted was as I expected.

<!--more-->

Here is a rather simplified example of what we want to test:

```CSharp
class MyThing {
    readonly IFoo foo;
    public MyThing(IFoo foo) {
        this.foo = foo;
    }

    public async Task<bool> DoTheThing(int howManyTimes) {
        var x = new List<int>();
        for (int i = 1; i <= howManyTimes; i++) {
            x.Add(i);
        }

        foo.DoSomething(x);
        return await Task.FromResult(true);
    }
}

public interface IFoo {
    void DoSomething(IList<int> list);
}
```

Using NSubstitute we can create a mock for IFoo using `NSubstitute.Substitute.For<IFoo>()`, and now this can be used to verify calls using `Received()`:

```CSharp
// Arrange
var foo = NSubstitute.Substitute.For<IFoo>();

// Act
var sut = new MyThing(foo);
await sut.DoTheThing(3);

// Assert
foo.Received().DoSomething(Arg.Is<IList<int>>(l => l.Count() == 3));
foo.Received().DoSomething(Arg.Is<IList<int>>(l => l.First() == 1));
foo.Received().DoSomething(Arg.Is<IList<int>>(l => l.Last() == 3));
```

We could alternatively pass in a function that could do some more complex checks, eg:

```CSharp
Func<IList<int>, bool> expectedResult = (list) => { return false;};
foo.Received().DoSomething(Arg.Is<IList<int>>(l => expectedResult(l)));
```

or we could even capture the arguments used using `Do` by setting this up during our arrangement:

```CSharp
IList<int> captured = null!;
foo.When(substitute => substitute.DoSomething(Arg.Any<IList<int>>())).Do(info => captured = info.ArgAt<IList<int>>(0));
```

NSubstitute can do a whole lot more and you could really go to town with some of the functionality, if you are not familiar with it I would encourage you to check it out - https://nsubstitute.github.io/

[^1]: I do try most of the time
