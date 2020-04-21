# Mock Objects

While testing single units is simpler than testing entire systems, we still face challenges when unit testing classes that depend on other classes or on external infrastructure.

As an example, consider an application in which all SQL-related code has been encapsulated in an `InvoiceDAO` class. Other parts of the system that depend on this `InvoiceDAO` class, then also depend (directly or indirectly) on a database. We therefore also have a dependency on the database when we write tests for those other parts, even though our focus might not even be the database part of the system. As we saw before, this can incur higher testing costs.

In other words: **we want to unit test a component A, that depends on another component B. The dependency on component B increases the costs of unit testing A.**

This is where a **mock object** comes in handy. The idea is that we will create an object that will mimic the behaviour of component B ("it looks like B, but it is not B"). Given that we have full control over what this "mock component B" does, we can design it in such a way that unit testing A becomes less costly. In our example above, suppose that A is a plain Java class and B is a Data Access Object (and thus, it communicates with the database). If we simulate B for example by returning a hard-coded list of two elements whenever the `findAllInvoices()` method is called, instead of going to the database, we remove the need for a database when testing A. 
If this seems too abstract, the source code we show later in this chapter offers more clarification.

The use of objects that simulate the behaviour of other objects has advantages:

* Firstly we have **more control**. We can easily tell these objects what to do, without the need for complicated setups. If we want a method to throw an exception, we just tell the mock method to throw it; there is no need for complicated setups to "force" the dependency to throw the exception. Similarly, if we want a method that returns a Calendar object representing a date in 2009, we just tell the mock method to do it; there is no need to complicate your OS in order to make it go back in time. Note how hard it usually is to "force" a class to throw an exception, or to "force" a class to return a fake date. This effort is close to zero when we simulate the dependencies with mock objects. 

* Simulations are also **faster**. Imagine a dependency that communicates with a webservice or a database. A method in one of these classes might take a few seconds to process. On the other hand, if we simulate the dependency, it will no longer need to communicate with a database or with a webservice anymore and wait for a response; the simulation will simply return what it was configured to return, and it will cost nothing in terms of time.  

**Simulating dependencies is therefore a widely used technique in software testing, mainly to increase testability.**

You might have noted that, although the title of this chapter is "mock objects", we have been using the word "simulation". As you will see in the remainder of this chapter, you may need different types of "simulation objects", according to your problem. Such objects are also known as "test doubles".

Meszaros, in his book, defines five different types: dummy objects, fake objects, stubs, spies, and mocks:

* **Dummy objects**: Objects that are passed to the class under test, but are never really used. This is common in business applications, where in many cases you need to fill a long list of parameters, but the test only exercises a few of them. Think of a unit test for a `Customer` class. Maybe this class depends on several other classes (`Address`, `Last Order`, etc). But a specific test case A wants to exercise the "last order business rule", and does not care much about which Address this Customer has. In this case, a tester would then set up a dummy Address object and pass it to the Customer class.

* **Fake objects**: Fake objects have real working implementations of the class they simulate. However, they usually do the same task in a much simpler way. Imagine a fake database class that uses an array list instead of a real database.

* **Stubs**: Stubs provide hard-coded answers to the calls that are performed during the test. 
Stubs do not actually have a working implementation, as fake objects do. In the examples above, where we used the word "simulation", we were actually talking about stub objects. Stubs do not know what to do if the test calls a method for which it was not programmed and/or set up. 

* **Spies**: As the name suggests, spies "spy" a dependency. It wraps itself around the object and observes its behaviour. Strictly speaking it does not actually simulate the object, but rather just delegates all interactions to the underlying object while recording information about these interactions. Imagine you just need to know how many times a method X is called in a dependency: that is when a spy would come in handy.

* **Mocks**: Mock objects act like stubs that are pre-configured ahead of time to know what kind of interactions should occur with them. For example, imagine a mock object that is configured as follows: method A should be called twice and, for the first call it should return "1", and for the second call it should throw an exception, while method B should never be called.

In the rest of this chapter, we introduce the reader to Mockito, a popular mocking framework in Java. Although Mockito has "mock" in the name, Mockito can be used for stubbing and spying as well. We also show, by means of a few examples, how simulations can help developers in writing unit tests more effectively.

{% hint style='tip' %}
You can read more about the history of Mock Objects at http://www.mockobjects.com.
{% endhint %}

## Mockito

One of the most popular Java mocking/stubbing frameworks is Mockito ([mockito.org](https://site.mockito.org)). Mockito has a very simple API. Developers can set up stubs and/or define expectations in mock objects with just a few lines of code.

The most important methods one needs to know from Mockito are:

- `mock(<class>)`: creates a mock object/stub of a given class. The class can be retrieved from any class by `<ClassName>.class`.
- `when(<mock>.<method>).thenReturn(<value>)`: defines the behaviour when the given method is called on the mock. In this case `<value>` will be returned.
- `verify(<mock>).<method>`: asserts that the mock object was exercised in the expected way for the given method.

Mockito is an extensive framework and we will only cover part of it in this chapter. To learn more, take a look at its [documentation](https://javadoc.io/page/org.mockito/mockito-core/latest/org/mockito/Mockito.html).

## Stubbing

Let us learn how to use Mockito and setup stubs with a practical example.

> **Requirement: Low value invoices**
>
> The program must return all the issued invoices with values smaller than 100. The collection of invoices can be found in our database.

The following is a possible implementation of this requirement. Note that the
`IssuedInvoices` is a class responsible for retrieving all the invoices from the database.

```java
import java.util.List;
import static java.util.stream.Collectors.toList;

public class InvoiceFilter {

  public List<Invoice> lowValueInvoices() {
    final var issuedInvoices = new IssuedInvoices();
    try {
      return issuedInvoices.all().stream()
              .filter(invoice -> invoice.value < 100)
              .collect(toList());
    } finally {
      issuedInvoices.close();
    }
  }

}
```


Without stubbing the `IssueInvoices` class, the `InvoiceFilter` test would need to also handle the database (making the unit testing more expensive). Note how the tests need to open and close the connection (see the `open()` and `closeDao()` methods) and save invoices to the database (see the many calls to `invoices.save()` in the `filterInvoices` test).

```java
public class InvoiceFilterTest {
  private IssuedInvoices invoices;

  @BeforeEach public void open() {
    invoices = new IssuedInvoices();
  }

  @AfterEach public void closeDao() {
    if (invoices != null) invoices.close();
  }

  @Test
  void filterInvoices() {
    final var mauricio = new Invoice("Mauricio", 20);
    final var steve = new Invoice("Steve", 99);
    final var arie = new Invoice("Arie", 300);

    invoices.save(mauricio);
    invoices.save(steve);
    invoices.save(arie);

    final InvoiceFilter filter = new InvoiceFilter();

    assertThat(filter.lowValueInvoices()).containsExactlyInAnyOrder(mauricio, steve);
  }

}
```

This test is not even complete. We also need to reset the database after every test. Otherwise, the test will fail in its second run, as there will now be four invoices with an amount smaller than 100 stored in the database! Remember that the database stores data permanently. So far, we never had to "clean our mess" in test code, as all the objects we created were always stored in-memory only.

{% hint style='tip'%}
Did you notice the `assertThat...containsExactlyInAnyOrder` assertion we used? This ensures that the list contains exactly the objects we pass, and in any order.

Such assertions do not come with JUnit 5. These assertions are part of the [AssertJ](https://joel-costigliola.github.io/assertj/) project. AssertJ is a fluent assertions API for Java, giving us several interesting assertions that are especially useful when dealing with lists or complex objects. We recommend you get familiar with it!
{% endhint %}

{% set video_id = "0WY7IWbANd8" %}
{% include "/includes/youtube.md" %}

Let us now re-write the test. This time we will stub the `IssuedInvoices` class.

For that to happen, we first need to make sure the stub can be "injected" into the `InvoiceFilter` class. If you look at the previous implementation of the `InvoiceFilter` class, you will notice that the class instantiates the `IssuedInvoices` class on its own. If we are to use a stub, the class should allow the stub to be injected.

It suffices to pass the dependency to the constructor, instead of instantiating it directly:


```java
import java.util.List;
import static java.util.stream.Collectors.toList;

public class InvoiceFilter {

  final IssuedInvoices issuedInvoices;

  public InvoiceFilter(IssuedInvoices issuedInvoices) {
    this.issuedInvoices = issuedInvoices;
  }
  public List<Invoice> lowValueInvoices() {
      return issuedInvoices.all().stream()
              .filter(invoice -> invoice.value < 100)
              .collect(toList());
  }

}
```

Let us now stub `IssuedInvoices`. Note that now our test does not need to do anything that is related to databases. The full control of the stub enables us to try different cases (even exceptional ones) very quickly:

```java
import static java.util.Arrays.asList;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

public class InvoiceFilterTest {
    private final IssuedInvoices invoices = Mockito.mock(IssuedInvoices.class);
    private final InvoiceFilter filter = new InvoiceFilter(issuedInvoices);

    @Test
    void filterInvoices() {
      final var mauricio = new Invoice("Mauricio", 20);
      final var steve = new Invoice("Steve", 99);
      final var arie = new Invoice("Arie", 300);

      when(issuedInvoices.all()).thenReturn(asList(mauricio, arie, steve));

      assertThat(filter.lowValueInvoices()).containsExactlyInAnyOrder(mauricio, steve);
    }

}
```

Note how we setup the stub, using Mockito's `when` method. In this example, we tell the stub to return a list containing `mauricio`, `arie`, and `steve` (the three invoices we instantiate as part of the test case). The test then invokes the method under test, `filter.lowValueInvoices()`. As a consequence, the method under test invokes `issuedInvoices.all()`. However, at this point, `issuedInvoices` is actually a stub that returns the list with the three invoices. The method under test continues its execution, returns a new list with only the two invoices that are below 100, causing the assertion to pass.

Note that, besides making the test easier to write, the use of stubs also made the test class more cohesive. The `InvoiceFilterTest` only tests the `InvoiceFilter` class. It does not test the usage of the `IssueInvoices` class. Clearly, `IssueInvoices` deserves to be tested, but in another place, and by means of an integration test.

Note that a cohesive test has less chances of failing because of something else. In the old version, the `filterInvoices` test could fail because of a bug in the `InvoiceFilter` class or because of a bug in the `IssuedInvoices` class. The new tests can now only fail because of a bug in the `InvoiceFilter` class, and never because of `IssuedInvoices`. This is handy, as a developer will spend less time debugging in case this test starts to fail.

Our new approach for testing `InvoiceFilter` is faster, easier to write, and more cohesive.

{% set video_id = "kptTWbeLZ3E" %}
{% include "/includes/youtube.md" %}

{% set video_id = "baunKy04deM" %}
{% include "/includes/youtube.md" %}


> From a developer's perspective, the use of stubs enables them to develop their software, "without caring too much about external details". Imagine a developer working on this "Low value invoices" requirement. The developer knows that the invoices will come from the database. However, while developing the main logic of the requirement (i.e. the filtering logic), the developer "does not care about the database"; they only care about the list of invoices that will come from it.
> 
> In other words, the developer only cares about the existence of a method that returns all the existing invoices. In object-oriented languages, that can be represented by means of an interface:
> 
> ```java
> public interface IssuedInvoices {
>  List<Invoice> all();
>  void save(Invoice inv);
>}
>```
>
> Having such an interface, the developer can then proceed to the `InvoiceFilter` and develop it completely. After all, its implementation never depended on a database, but solely on the issued invoices. Look at it again:
> 
> ```java
> public class InvoiceFilter {
> 
>   final IssuedInvoices issuedInvoices;
> 
>   public InvoiceFilter(IssuedInvoices issuedInvoices) {
>     this.issuedInvoices = issuedInvoices;
>   }
>   public List<Invoice> lowValueInvoices() {
>       return issuedInvoices.all().stream()
>               .filter(invoice -> invoice.value < 100)
>               .collect(toList());
>   }
> }
> ```
> 
> Once the `InvoiceFilter` and all its tests are done, the developer can then focus on finally implementing the `IssuedInvoices` class and its integration tests.
> 
> Hence, once you get used to this way of developing, you will notice how your code will become easier to test. We will talk more about design for testability in future chapters.


## Mocks and expectations

Suppose our system has a new requirement:

> **Requirement: Send low valued invoices to SAP**
>
> All low valued invoices should be sent to our SAP system.
> SAP offers a /sendInvoice webservice that receives invoices.

Let us follow the idea of using test doubles to facilitate the development of our production and test code. To that aim, let us create a `SAP` interface that represents the communication with SAP:

```java
public interface SAP {
  void send(Invoice invoice);
}
```

We now need a class that will coordinate the process: retrieve the low valued invoices from the `InvoiceFilter`and pass them to the `SAP` service. Let us create a new `SAPInvoiceSender` class:

```java
public class SAPInvoiceSender {

  private final InvoiceFilter filter;
  private final SAP sap;

  public SAPInvoiceSender(InvoiceFilter filter, SAP sap) {
    this.filter = filter;
    this.sap = sap;
  }

  public void sendLowValuedInvoices() {
    filter
      .lowValueInvoices()
      .forEach(invoice -> sap.send(invoice));
  }
}
```

Let us now test the `SAPInvoiceSender` class.

Note that, for this test, we now mock the `InvoiceFilter` class. After all, for the `SAPInvoiceSender`, `InvoiceFilter` class is "just a class that returns a list of invoices". As it is not the goal of the current test to test the filter itself, we should mock this class, in order to facilitate the testing of the method under test.

After the execution of the method under test (`sendLowValuedInvoices()`), we 
should expect that the `SAP` mock received `mauricio`'s, `steve`'s, and `arie`s invoices. For that, we use Mockito's `verify()` method:

```java
public class SAPInvoiceSenderTest {

  private static final InvoiceFilter filter = mock(InvoiceFilter.class);
  private static final SAP sap = mock(SAP.class);
  private static final SAPInvoiceSender sender = new SAPInvoiceSender(filter, sap);

  @Test
  void sendToSap() {
    final var mauricio = new Invoice("Mauricio", 20);
    final var steve = new Invoice("Steve", 99);
    final var arie = new Invoice("Arie", 300);

    when(filter.lowValueInvoices()).thenReturn(asList(mauricio, steve, arie));

    sender.sendLowValuedInvoices();

    verify(sap).send(mauricio);
    verify(sap).send(steve);
    verify(sap).send(arie);
  }
}
```

Note how we defined the expectations of the mock object. We "knew" exactly how the `InvoiceFilter` class had to interact with the mock. When the test is executed, Mockito will check whether these expectations were met, and fail the test if they were not. (If you want to test it, simply comment out the `forEach...` line in the `sendLowValuedInvoices` and see the test failing).

This example illustrates the main difference between stubbing and mocking. Stubbing means simply returning hard-coded values for a given method call. Mocking means not only defining what methods do, but also explicitly defining how the interactions with the mock should be.

Mockito actually enables us to define even more specific expectations. For example, see the expectations below:

```java
verify(sap, times(3)).send(any(Invoice.class));
verify(sap, times(1)).send(mauricio);
verify(sap, times(1)).send(steve);
verify(sap, times(1)).send(arie);
```

These expectations are more restrictive than the ones we had before.
We now expect the SAP mock to have its `send` method invoked precisely three times (for any given `Invoice`). We then expect the `send` method to called once for the `mauricio` invoice, once for the `steve` invoice, and once for the `arie` invoice. We point the reader to Mockito's manual for more details on how to configure expectations.

> You might be asking yourself now: _Why did you not put this new SAP sending functionality inside of the existing `InvoiceFilter` class_?
> 
> If we were do it, the `lowValueInvoices` method would then be both a "command" and a "query". By "query", we mean that the method returns data to the caller while with "command", we mean that the method also performs an action in the system. Mixing both concepts in a single method is not a good idea, as it may confuse developers who will eventually call this method. How would they know this method had some extra side-effect, besides just returning the list of invoices?
> 
> If you want to read more about this, search for _Command-Query Separation_, or CQS, a concept devised by Bertrand Meyer.


## How to stub static methods (or with APIs you do not control)

Imagine the following requirement:

> **Requirement: Christmas Discount**
>
> The program gives a 15% discount on the total amount of an order if the current date is Christmas day. Otherwise there is no discount.

A possible implementation for this requirement is as follows:

```java
public class ChristmasDiscount {

public double applyDiscount(double amount) {
    Calendar today = Calendar.getInstance();

    double discountPercentage = 0;
    boolean isChristmas = today.get(Calendar.DAY_OF_MONTH) == 25 &&
          today.get(Calendar.MONTH) == Calendar.DECEMBER;

    if(isChristmas)
      discountPercentage = 0.15;

    return amount - (amount * discountPercentage);
  }

}
```

The implementation is quite straightforward. And given the characteristics of the class, unit testing seems to be a perfect fit for testing it. The question is: _how can we write unit tests for it?_ To test both cases (i.e. Christmas/not Christmas), we need to be able to control/stub the `Calendar` class, so that it returns the dates we want.

We can then ask a more specific question: _how can we stub the Calendar API?_

You might have noted that the call to `Calendar.getInstance()` is a static call. Mockito does not allow us to stub static methods (although some other more magical mock frameworks do). Static calls are indeed _enemies of testability_, as they do not allow for easy stubbing.

In such cases, a pragmatic solution is to create an abstraction on top of the static call. The abstraction encapsulates the "not-so-easy-to-be-stubbed" method, and offers an "easy-to-be-stubbed" method to the rest of the program. For this particular
case, a `Clock` abstraction can do the job:

```java
import java.util.Calendar;

public interface Clock {
    Calendar now();
}
```

With this interface, we can follow the same approach as before. Let us inject `Clock` to the `ChristmasDiscount` class:

```java
import java.util.Calendar;

public class ChristmasDiscount {

  private final Clock clock;

  public ChristmasDiscount(Clock clock) {
    this.clock = clock;
  }

  public double applyDiscount(double rawAmount) {
    Calendar today = clock.now();

    double discountPercentage = 0;
    boolean isChristmas = today.get(Calendar.DAY_OF_MONTH) == 25 &&
          today.get(Calendar.MONTH) == Calendar.DECEMBER;

    if(isChristmas)
      discountPercentage = 0.15;

    return rawAmount - (rawAmount * discountPercentage);
  }
}
```

With `Clock` being an interface, we can stub it the way we want and/or need:

```java
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import java.util.Calendar;
import java.util.GregorianCalendar;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

public class ChristmasDiscountTest {

    private final Clock clock = Mockito.mock(Clock.class);
    private final ChristmasDiscount cd = new ChristmasDiscount(clock);

    @Test
    public void christmas() {
      Calendar christmas = new GregorianCalendar(2015, Calendar.DECEMBER, 25);
      when(clock.now()).thenReturn(christmas);

      double finalValue = cd.applyDiscount(100.0);
      assertEquals(85.0, finalValue, 0.0001);
    }

    @Test
    public void notChristmas() {
      Calendar christmas = new GregorianCalendar(2015, Calendar.JANUARY, 25);
      when(clock.now()).thenReturn(christmas);

      double finalValue = cd.applyDiscount(100.0);
      assertEquals(100.0, finalValue, 0.0001);
    }
}
```

Note again that we were able to develop the main logic of the requirement without depending on the concrete implementation of `Clock`. For completeness, let us implement `Clock`:

```java
public class DefaultClock implements Clock {
    @Override
    public Calendar now() {
      return Calendar.getInstance();
    }
}
```

Creating abstractions on top of dependencies that you do not own, as a way to gain more control, is a common technique among developers.

One might ask: _Won't that increase the overall complexity of my system? After all, it requires maintaining another abstraction?_ Yes. There is more complexity when we add new abstractions in our software, and that is what we are doing here. However, the point is: does the ease in testing the system that we get from adding this abstraction compensate for the cost of the increased complexity? Often, the answer is _yes, it does pay off_.


## When to mock/stub?

Mocks and stubs are a useful tool when it comes to ease the process of writing unit tests. However, as expected *mocking too much* might also be problem. We do not want to mock a dependency that should not be mocked. Imagine you are testing class A, which depends on a class B. Should we mock/stub B?

Pragmatically, developers often mock/stub the following types of dependencies:

* **Dependencies that are too slow**: If the dependency is too slow, for any reason, it might be a good idea to simulate that dependency.

* **Dependencies that communicate with external infrastructure**: If the dependency talks to (external) infrastructure, it might be too complex to be set up. Consider stubbing it.

* **Hard to simulate cases**: If we want to force the dependency to behave in a hard-to-simulate way, mocks/stubs can help. A common example is when we would like the dependency to throw an exception. Forcing an exception in the real dependency might be tricky, but easy to do in a stub/mock.

On the other hand, developers tend not to mock/stub:

* **Entities**. An entity is a simple class that mirrors a collection in a database, while instances of this class mirror the entries of that collection. In Java we tend to call these POJOs (Plain Old Java Objects), as they mostly consist of fields only. In business systems, it is quite common that entities depend on other entities, e.g. a `Order` depends on `OrderItem`. When testing `Order`, developers tend not to stub `OrderItem`. The reason is that `OrderItem` is probably also a well-contained class that is easy to set up. Mocking it would take more time than the actual implementation would take. Exceptions can be made for heavy entities.

* **Native libraries and utility methods**. It is not common to mock/stub libraries that come with our programming language and utility methods. For example, why would one mock `ArrayList` or a call to `String.format`? As shown with the `Calendar` example above, any library or utility methods that harm testability can be abstracted away.

Ultimately, remember that whenever you mock, you reduce the reality of the test. It is up to you to understand this trade-off.

## Exercises

The code implemented in this chapter can be found at the `invoice`, `invoicestubbed`, and `invoicesap` packages in the [code examples](https://github.com/sttp-book/code-examples/) repository.


**Exercise 1.**
See the following class:

```java
public class OrderDeliveryBatch {

  public void runBatch() {

    OrderDao dao = new OrderDao();
    DeliveryStartProcess delivery = new DeliveryStartProcess();

    List<Order> orders = dao.paidButNotDelivered();

    for (Order order : orders) {
      delivery.start(order);

      if (order.isInternational()) {
        order.setDeliveryDate("5 days from now");
      } else {
       order.setDeliveryDate("2 days from now");
      }
    }
  }
}

class OrderDao {
  // accesses a database
}

class DeliveryStartProcess {
  // communicates with a third-party webservice
}
```

Which of the following Mockito lines would never appear in a test for the `OrderDeliveryBatch` class?

1. `OrderDao dao = Mockito.mock(OrderDao.class);`
2. `Mockito.verify(delivery).start(order);` (assume `order` is an instance of `Order`)
3. `Mockito.when(dao.paidButNotDelivered()).thenReturn(list);` (assume `dao` is an instance of `OrderDao` and `list` is an instance of `List<Order>`)
4. `OrderDeliveryBatch batch = Mockito.mock(OrderDeliveryBatch.class);`


**Exercise 2.**
You are testing a system that triggers advanced events based on complex combinations of Boolean external conditions relating to the weather (outside temperature, amount of rain, wind, ...). 
The system has been designed cleanly and consists of a set of co-operating classes that each have a single responsibility. You create a decision table for this logic, and decide to test it using mocks. Which is a valid test strategy?


1. You use mocks to support observing the external conditions.
2. You create mock objects to represent each variant you need to test.
3. You use mocks to control the external conditions and to observe the event being triggered.
4. You use mocks to control the triggered events.






**Exercise 3.**
Below, we show the `InvoiceFilter` class. This class is responsible for returning the invoices for an amount that is smaller than 100.0. It makes use of the InvoiceDAO class, which is responsible for communication with the database.

```java
public class InvoiceFilter {

    private InvoiceDao invoiceDao;

    public InvoiceFilter(InvoiceDao invoiceDao) {
        this.invoiceDao = invoiceDao;
    }

    public List<Invoice> filter() {
        List<Invoice> filtered = new ArrayList<>();
        List<Invoice> allInvoices = invoiceDao.all();

        for(Invoice inv : allInvoices) {
            if(inv.getValue() < 100.0)
                filtered.add(inv);
        }

        return filtered;
    }
}
```

Which of the following statements is **false** about this class?


1. Integration tests would help us achieve a 100% branch coverage, which is not possible solely via unit tests.
2. Its implementation allows for dependency injection, which enables mocking.
3. It is possible to write completely isolated unit tests for it by, e.g. using mocks.
4. The InvoiceDao class (a direct dependency of the InvoiceFilter) itself should be tested by means of integration tests.


**Exercise 4.**
Class A depends on a static method in another class B. If you want to test class A, which of the following two action(s) should you apply to do this properly?

1. Mock class B to control the u of the methods in class B.
2. Refactor class A, so the outcome of the method of class B is now used as an parameter.

1. Only approach 1.
2. Neither.
3. Only approach 2.
1. Both.

**Exercise 5.**
Referring to the previous chapter, apply boundary testing techniques to the `InvoiceFilter` example discussed in this chapter.

## References


* Fowler, Martin. Mocks aren't stubs. https://martinfowler.com/articles/mocksArentStubs.html

* Meszaros, G. (2007). xUnit test patterns: Refactoring test code. Pearson Education.

* Mockito's website: https://site.mockito.org

* Lee Houghton: TestDouble: Don't mock types you don't own: https://github.com/testdouble/contributing-tests/wiki/Don%27t-mock-what-you-don%27t-own. Last access on March, 2020.

* Spadini, Davide, Maurício Aniche, Magiel Bruntink, and Alberto Bacchelli. "Mock objects for testing java systems." Empirical Software Engineering 24, no. 3 (2019): 1461-1498.

* Freeman, S., & Pryce, N. (2009). Growing object-oriented software, guided by tests. Pearson Education.
