Title: "Entity Builder for Unit Tests"
Published: 2020-05-04
Tags:

- dotnet
- Tips
- unit testing

RedirectFrom: posts/2020-05-04-UnitTestEntityBuilder

---

If you find yourself needing to create an instance of a domain entity for unit testing, but having trouble getting round property or constructor accessability, using a builder is a great technique to get round this and provide a consistent, reusable method of creating the object for your tests.

<!--more-->

Typically you might find yourself creating opinionated constructors or getter only properties that will assert or support rules for an entity or business logic, but these can sometimes present a challenge when it comes to creating unit tests. Consider the following class:

```
public class Foo
{
  public enum StatusEnum
  {
    New = 0,
    Open = 1,
    Closed = 2
  }

  // Private constructor used by Entity Framework
  private Foo() { }

  // Used to create a new Foo
  public Foo(string name)
  {
    if (string.IsNullOrWhiteSpace(name)) throw new ArgumentException("Name must not be empty", nameof(name));
    this.Name = name;
    this.Status = StatusEnum.New;
  }

  public string Name { get; private set; }
  public StatusEnum Status { get; private set; }

  public void Close() {
    if (this.Status != StatusEnum.Open) throw new Exception($"{this.Name} must be open for it to be closed.");

    this.Status = StatusEnum.Closed;
  }
}
```

Here we have our Foo entity designed to assert a couple of things, firstly we can only set the name when creating the instance, and secondly we can only change the status to Closed if the status is currently Open. If we wanted to write a unit test around our `Close` method we might be tempted to change the accessability of our `Status` property, or even change the private constructor to allow us to create a usable entity in our test project, however both these actions might well lead to an API open to misuse.

A much better option would be to create a builder in our test project which can easily get round the constructor and property accessability and ensure some sort of consistency and reusability in our unit tests. Our builder for the class above might look a little like this:

```
public class FooBuilder
{
  private readonly Type entityType = typeof(Foo);
  private readonly Foo foo;

  public FooBuilder(string name)
  {
    var entity = Activator.CreateInstance(entityType, true) as Foo;
    foo = entity ?? throw new ArgumentNullException(nameof(entity));
    entityType.GetProperty(nameof(foo.Name)).SetValue(foo, name);
  }

  public FooBuilder WithStatus(StatusEnum status)
  {
    entityType.GetProperty(nameof(foo.Status)).SetValue(foo, status);
    return this;
  }

  public Foo Build()
  {
    return foo;
  }
}
```

We can now use this builder to create and bypass our assertions without compromising the design of our entity:

```
var testFoo = new FooBuilder("wibble")
  .WithStatus(StatusEnum.Open)
  .Build();
```

This is not fool proof and still open for misuse, but at least most of the damage will confined to your test projects so it's a much better option compared to 'compromising' your API design.
