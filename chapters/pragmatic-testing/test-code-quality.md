# Test code quality and engineering

You probably noticed that, once _test infected_, 
the amount of JUnit code that a software development team writes and maintain
is quite significant. In practice,
test code bases tend to grow quickly. Empirically, we have been observing
that Lehman's laws of evolution also apply to test code: code tends to rot, unless
one actively works against it. Therefore,
as with production code, **developers have to put extra effort 
into making high-quality test code bases, so that these can be maintained and developed in a
sustainable way**.

In this chapter, we address the following best practices in test code engineering:

* A set of principles that should guide developers when writing test code.
For these, we discuss both the FIRST principles (from the Pragmatic Unit Testing book),
as well as the recent Test Desiderata (proposed by Kent Beck).
* A set of well-known test smells that might emerge in test code.
* Some tips on how to make tests more readable.
* What flaky tests are and their possible causes.


## The FIRST properties

In the Pragmatic Unit Testing book, the authors discuss the "FIRST Properties of Good Tests".
FIRST is an acronym for fast, isolated, repeatable, self-validating, and timely:

- **Fast**: 
Tests are the safety net of a developer. Whenever developers perform any maintenance
or evolution in the source code, they use the feedback of the test suite to understand
whether the system is still working as expected. 
The faster the developer gets feedback from their test code, the better. 
Slower test suites force developers to simply run the tests less often,
making them less effective. Therefore, good tests are fast.
There is no hard line that separates slow from fast tests. It is fundamental to apply common sense.
Once you are facing a slow test, you may consider to:
    - Make use of mocks/stubs to replace slower components that are part of the test
    - Re-design the production code so that slower pieces of code can be tested separately from fast pieces of code
    - Move slower tests to a different test suite, one that developers may run less often. 
    It is not uncommon to see developers having sets of unit tests that run fast and all day long,
	and sets of slower integration and system tests that run once or twice a day on the Continuous Integration server. 


- **Isolated**: Tests should be as cohesive, as independent, and as isolated as possible. 
Ideally, a single test method should test just a single functionality or behaviour of the system.
Fat tests (or, as the test smells community calls them, eager tests) which test
multiple functionalities are often complex in terms of implementation. Complex test code reduces
the ability of developers to understand at a glance what is being tested, and makes future maintenance
harder. If you are facing such a test, break it into multiple smaller tests. Simpler and shorter
code is always better.

	Moreover, tests should not depend on other tests to run. The result of a test should be the
	same, whether the test is executed in isolation or together with the rest of the test suite.
	It is not uncommon to see cases where for example test B only works if test A is executed first.
	This is often the case when test B relies on the work of test A to set up the environment
	for it. Such tests become highly unreliable.
	In such cases, refactor the test code so that the tests
	are responsible for setting up the whole environment they need. If tests A and B depend on
	similar resources, make sure they can share the same code, so that you avoid duplicating
	code. JUnit's `@BeforeEach` or `@BeforeAll` methods can become handy. Make sure
	that your tests "clean up their messes", e.g., by deleting any possible files they created
	on the disk, or cleaning up values they inserted into a database.


- **Repeatable**: A repeatable test is a test that gives the same result, no matter how many times it is executed.
Developers tend to lose their trust in tests that present flaky behaviour (i.e., it sometimes passes, and sometimes fails without any changes in the system and/or in the test code).
Flaky tests can happen for different reasons, and some of the causes can be tricky
to identify. (Companies have reported extreme examples where a test presented flaky behaviour
only once in a month.) Common causes are dependencies on external resources, not waiting long
enough for an external resource to finish its task, and concurrency.


- **Self-validating**: 
The tests should validate/assert the result themselves. This might seem an unnecessary
principle to mention. However, it is not uncommon for developers to make mistakes and not write
any assertions in a test, causing the test to always pass. In other more complex cases,
writing the assertions or, in other words, verifying the expected behaviour, might not be possible.
In cases where observing the outcome of behaviour is not easily achievable, we suggest
the developer to refactor the class or method under test to increase its observability (revisit
our chapter on design for testability).


- **Timely**: 
Developers should be _test infected_. They should write and run tests as often
as possible. While less technical than the other principles in this list, changing
the behaviour of development teams towards writing automated test code can still be challenging.

	Leaving the test phase to the very end of the development process, as commonly done
	in the past, can result in
	unnecessary costs. After all, at that point, the system might be simply too hard to test.
	Moreover, as we have seen, tests serve as a safety net for developers. Developing large
	complex systems without such a net is highly unproductive and likely to fail.

{% set video_id = "5wLrj-cr9Cs" %}
{% include "/includes/youtube.md" %}


## Test Desiderata

Kent Beck, the "creator" of Test-Driven Development (and author of the 
["Test-Driven Development: By Example"](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530) book), recently wrote a list of twelve
properties that good tests have (the [test desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3)). 

The following list comes directly from his blog post. Note how some of these properties
are also part of the FIRST properties.

* [Isolated](https://www.youtube.com/watch?v=HApI2cspQus): tests should return the same results regardless of the order in which they are run.
* [Composable](https://www.youtube.com/watch?v=Wf3WXYaMt8E): if tests are isolated, then I can run 1 or 10 or 100 or 1,000,000 and get the same results.
* [Fast](https://www.youtube.com/watch?v=L0dZ7MmW6xc): tests should run quickly.
* [Inspiring](https://www.youtube.com/watch?v=2Q1O8XBVbZQ): passing the tests should inspire confidence.
* [Writable](https://www.youtube.com/watch?v=CAttTEUE9HM): tests should be cheap to write relative to the cost of the code being tested.
* [Readable](https://www.youtube.com/watch?v=bDaFPACTjj8): tests should be comprehensible for their readers, and it should be clear why they were written.
* [Behavioural](https://www.youtube.com/watch?v=5LOdKDqdWYU): tests should be sensitive to changes in the behaviour of the code under test. If the behaviour changes, the test result should change.
* [Structure-insensitive](https://www.youtube.com/watch?v=bvRRbWbQwDU): tests should not change their result if the structure of the code changes.
* [Automated](https://www.youtube.com/watch?v=YQlmP08dj6g): tests should run without human intervention.
* [Specific](https://www.youtube.com/watch?v=8lTfrCtPPNE): if a test fails, the cause of the failure should be obvious.
* [Deterministic](https://www.youtube.com/watch?v=PwWyp-wpFiw): if nothing changes, the test result should not change.
* [Predictive](https://www.youtube.com/watch?v=7o5qxxx7SmI): if the tests all pass, then the code under test should be suitable for production.

For more interested readers, watch [Kent Beck talking about it in an open talk](https://www.youtube.com/watch?v=lXTwxMxNx-Y).


## Test code smells

Now that we have covered some best practices, let us look at the other
side of the coin: **test code smells**.

The term _code smell_ is a well-known term that indicates possible symptoms that might
indicate deeper problems in the source code of the system. 
Some well-known examples are *Long Method*, *Long Class*, or *God Class*.
A number of research papers show us that code smells hinder the comprehensibility and the maintainability of software systems.

While the term has long been applied to production code, given
the rise of test code, our community has been developing catalogues of smells that
are now specific to test code.
Research has also shown that test smells are prevalent in real life and, unsurprisingly, 
often have a negative impact on the maintenance and comprehensibility of the test suite.

We discuss below several of the well-known test smells. A more comprehensive
list can be found in the xUnit Test Patterns book, by Meszaros.


**Code Duplication**: 
It is not surprising that code duplication can also happen in test code, 
as it is very common in production code.
Tests are often similar in structure. You may have noticed it in several of the code
examples throughout this book. We even made use of parameterised tests
to reduce some of the duplication.
A less attentive developer might end up writing duplicated code 
(copying and pasting often happens in real life) instead of putting
some effort into implementing a better solution. 

Duplicated code can reduce the productivity of software testers.
After all, if there is a need for a change in a duplicated piece of code, a developer
will have to apply the same change in all the places where the code was duplicated. 
In practice, it is easy to forget one of these places, which causes one to end up with 
problematic test code.
Note that the effects are similar to the effects of code duplication in production code.

We advise developers to refactor their test code ruthlessly. The extraction of a duplicated piece of
code to private methods or external classes is often a good solution for the problem.

**Assertion Roulette**:
Assertions are the first thing a developer looks at when a test is failing.
Assertions, have to communicate clearly what is going wrong with the component
under test. 
The test smell emerges when it is hard to understand the 
assertions themselves, or why they are failing.

There are several reasons for this smell to happen. Some features or business rules
are so complex that they require a complex set of assertions to ensure their behaviour.
In these situations, developers end up writing complex assert instructions that are not easy to
understand. To help with such cases, we recommend developers to:

1. Write customised assert instructions that abstract away part of the complexity of the assertion code itself.
2. Write code comments that explain quickly and in natural language what those assertions are about. (This mainly applies when the assertions are not self-explanatory.)

Interestingly, a common best practice that is often found in the test best practice literature is the "one assertion per method" strategy. While forcing developers to have a single assertion per test method is too extremist, the idea of minimising the number of assertions in a test method is valid.

Note that a high number of simple assertions in a single test can be as harmful as a complex
set of assertions. In such cases, we provide a similar recommendation: write a customised
assertion instruction to abstract away the need for long sequences of assertions.

Empirically, we also observe that the number of assertions in a test is often large, because
developers tend to write more than one test case in a single test method. We have done
this in this book too (see the boundary testing chapter, where we test both sides of the boundary
in a single test method). However, parsimony is fundamental. Splitting up a large test method
that contains multiple test cases can reduce the cognitive load required by the developer
to understand it.


**Resource Optimism**:
Resource optimism happens when a test assumes that a necessary resource (e.g., a database) is readily available at the start of its execution. 
This is related to the _isolated_ principle of the FIRST principles and of Beck's test desiderata.

To avoid resource optimism, a test should not assume that the resource is already in the correct state. The test should be the one responsible for setting up the state itself. 
This can mean that the test is the one responsible for populating a database, for writing the required files in the disk, or for starting up a Tomcat server. (This set up might require complex code, and developers
should also do their best effort in abstracting way such complexity by, e.g., moving such 
code to other classes, like `DatabaseInitialization` or `TomcatLoader`, allowing the
test code to focus on the test cases themselves).

Similarly, another incarnation of the resource optimism smell happens
when the test assumes that the resource is available all the time.
Imagine a test method that interacts with a webservice,
which might be down for reasons we do not control.

To avoid this test smell, developers have two options:

1. Avoid using external resources, by using stubs and mocks.
2. If the test cannot avoid using the external dependency, make it robust enough.
Make your test suite skip that test when the resource is unavailable, and provide a message explaining why that was the case. This seems counterintuitive, but again, remember
that developers trust their test suites. Having a single test failing for the wrong reasons
makes developers lose their confidence in the entire test suite.

In addition to changing the tests, developers must make sure 
that the environments where the tests are executed have the required resources available.
Continuous integration tools like Jenkins, CircleCI, and Travis can help developers in 
making sure that tests are being run in the correct environment.



**Test Run War**:
The war is an analogy for when two tests are "fighting" over the same resources.
One can observe a test run war when tests start to fail as soon as more than one developer
run their test suites.
Imagine a test suite that uses a centralised database. When developer A runs the test, the test changes the state of the database. At the same time, 
developer B runs the same test, which also uses the same database. 
Both tests are now using the same database at the same time. 
This unexpected situation may cause the test to fail.

_Isolation_ is key to avoid this test smell. In the example of a centralised database,
one solution would be to make sure that each developer has their own instance of a database. That would
avoid the fight over the same resource. (Related to this example, also see the chapter on database testing.)


**General Fixture**:
A fixture is the set of input values that will be used to exercise the component under test.
Fixtures are set up in the _arrange_ part of the test, which was discussed in a previous chapter.
As you may have noticed, fixtures are the "stars" of the test method, as they derive
naturally from the test cases we devised using any of the techniques we have discussed.

When testing more complex components, developers may need to make use of several
different fixtures: one for each partition they want to exercise. These fixtures can
then become complex. 
And to make the situation worse, while tests are different from each other, their fixtures
might have some intersection. 

Given this possible intersection amongst the different fixtures, as well as the difficulty
with building these complex entities and fixtures, a less attentive developer
could decide to declare a "large" fixture that works for many different tests. 
Each test would then use a small part of this large fixture. 

While this approach might work and the tests might correctly implement the test cases,
they are hard to maintain. Once a test fails, developers who try
to understand the cause of the failure, will face a large fixture that is not totally
relevant for them. In practice, the developer would have to manually
"filter out" parts of the fixture that are not really exercised by the failing test.
That is an unnecessary cost.
Making sure that the fixture of a test is as specific and cohesive as possible helps
developers to comprehend the essence of a test (which is often highly relevant when
the test starts to fail).

Build patterns, with the focus of building test data, 
can help developers in avoiding such a smell. More specifically, 
the **[Test Data Builder](http://www.natpryce.com/articles/000714.html)** pattern is
often used in test code of enterprise applications (we give an example
of a Test Data Builder later in this chapter). Such applications
often have to deal with the creation of complex sets of interrelated 
business entities, which can easily
lead developers to write general fixtures.

**Indirect tests** and **eager tests**:
Tests should be as cohesive and as focused as possible. A testing class `ATest` that aims at testing
class `A` should solely focus on testing class `A`. Even if it depends on class
`B`, requiring `ATest` to instantiate `B`, `ATest` should focus on exercising `A` and `A` only.
The smell emerges when a test class focuses its efforts on testing many classes
at once. 

Less cohesive tests lead to less productivity. How do developers know where tests for a given class `B` 
are? If test classes focus on more than a single class, tests for `B` could be anywhere.
Developers would have to look for them. 
It is also expected that, without proper care, tests for a single class would live in
many other test classes, e.g., tests for `B` might exist in `ATest`, `BTest`, `CTest`, etc.

Tests, and more specifically, unit test classes and methods, should have a clear focus.
They should test a single unit. If they have to depend on other classes, the use of
mocks and stubs can help the developer in isolating that test and avoid _indirect
testing_. If the use of mocks and stubs is not possible, make sure that assertions
focus on the real class under test, and that failures caused by dependencies (and not 
by the class under test) are clearly indicated in the outcome of the test method.

Similar to what we discussed when talking about the excessive number of assertions
in a single test, avoiding _eager tests_, or tests that exercise more than a unique
behaviour of the component is also best practice. Test methods that exercise multiple
behaviours at once tend to be overly long and complex, making it harder for developers
to comprehend them quickly.

**Sensitive Equality**:
Good assertions are fundamental in test cases. A bad assertion may cause a test
to not fail when it should. However, a bad assertion may also cause a test _to fail
when it should not_.
Engineering a good assertion statement is challenging. Even more so when components
produce fragile outputs, i.e., outputs that tend to change often. 
Test code should be as resilient as possible to the implementation details
of the component under test. Assertions should also not be oversensitive to internal changes. 

Imagine a class `Item` that represents an item in a shopping cart. 
An item is composed of a name, a quantity, and an individual price. The final price
of the item is the multiplication of its quantity per its individual price.
The class has the following implementation:

```java
import java.math.BigDecimal;

public class Item {

	private final String name;
	private final int qty;
	private final BigDecimal individualPrice;

	public Item(String name, int qty, BigDecimal individualPrice) {
		this.name = name;
		this.qty = qty;
		this.individualPrice = individualPrice;
	}

	// getters ...

	public BigDecimal finalAmount() {
		return individualPrice.multiply(new BigDecimal(qty));
	}

	@Override
	public String toString() {
		return "Product " + name + " times" + qty + " = " + finalAmount();
	}
}
```

Suppose now that a less attentive developer writes the following test to exercise
the `finalAmount` behaviour:

```java
public class ItemTest {

	@Test
	void qtyTimesIndividualPrice() {
		var item = new Item("Playstation IV with 64 GB and super wi-fi",
				3,
				new BigDecimal("599.99"));

		// this is too sensitive!
		Assertions.assertEquals("Product Playstation IV with 64 GB " +
				"and super wi-fi times " + 3 + " = 1799.97", item.toString());
	}
}
```

The test above does exercise the calculation of the final amount. However,
one can see that the developer took a shortcut. She decided to assert the overall
behaviour by making use of the `toString` method of the class. Maybe because
the developer felt that this assertion was stricter, as it asserts not only
the final price, but also the name of the product and its quantity. 

While this seems to work at first,
this assertion is sensitive to changes in the implementation of the `toString`. 

Clearly,
the tester only wants the test to fail if the `finalAmount` method changes, and not if the
`toString` method changes. That is not what happens. Suppose that another developer
decided to shorten the length of the outcome of the `toString`:

```java
@Override
public String toString() {
	return "Product " + name.substring(0, Math.min(11, name.length())) + 
	  " times " + qty + " = " + finalAmount();
}
```

Suddenly, our `qtyTimesIndividualPrice` test fails:

```
org.opentest4j.AssertionFailedError: 
Expected :Product Playstation IV with 64 GB and super wi-fi times 3 = 1799.97
Actual   :Product Playstatio times 3 = 1799.97
```

A better assertion for this would be to assert precisely what is wanted from that behaviour.
In this case, assert that the final amount of the item is correctly calculated. Then the 
implementation for the test would be better like this:

```java
@Test
void qtyTimesIndividualPrice_lessSensitiveAssertion() {
	var item = new Item("Playstation IV with 64 GB and super wi-fi",
			3,
			new BigDecimal("599.99"));

	Assertions.assertEquals(new BigDecimal("1799.97"), item.finalAmount());
}

```

Remember our discussion regarding design for testability. It may be better to 
create a method with the sole purpose of facilitating the test (or, in this case, the assertion)
rather than having to rely on sensitive assertions that will possibly break the test
for the wrong reason in the future.

**Inappropriate assertions**: Having the proper assertions makes a huge
difference between a good and a bad test case. While we have discussed how to derive
good test cases (and therefore also good assertions), choosing the right implementation strategy
for writing the assertion can affect the maintenance of the test in the long run.
The wrong choice of an assertion instruction may give developers less information
about the failure, making the debugging process more difficult.

Imagine an implementation of a `Cart` that receives products
to be inserted into it. 
Products cannot be repeated. 
A simple implementation could be:

```java
public class Cart {
	private final Set<String> items = new HashSet<>();

	public void add(String product) {
		items.add(product);
	}

	public int numberOfItems() {
		return items.size();
	}
}
```

Now, a developer decided to test the `numberOfItems` behaviour. He then wrote the following
test cases:

```java
public class CartTest {
	private final Cart cart = new Cart();

	@Test
	void numberOfItems() {
		cart.add("Playstation");
		cart.add("Big TV");

		assertTrue(cart.numberOfItems() == 2);
	}

	@Test
	void ignoreDuplicatedEntries() {
		cart.add("Playstation");
		cart.add("Big TV");
		cart.add("Playstation");

		assertTrue(cart.numberOfItems() == 2);
	}
}
```

Note that the less attentive developer opted for an `assertTrue`. While the test
works as expected, if it ever fails (which we can easily force by replacing the Set for a List
in the `Cart` implementation), the assertion error message will be something like this:

```
org.opentest4j.AssertionFailedError: 
Expected :<true> 
Actual   :<false>
```

The error message does not explicitly show the difference in the values. In this
simple example, it may not seem very important, but with more 
complicated test cases, a developer would have to add some debugging
code (`System.out.println`s) to print the actual value that was produced by the method.

The test could help the developer by giving as much information as possible. With that aim,
choosing the right assertions is important, as they tend to give more information. 
In this case, the use of an `assertEquals` is a better fit:

```java
@Test
void numberOfItems() {
	cart.add("Playstation");
	cart.add("Big TV");

	// assertTrue(cart.numberOfItems() == 2);
	assertEquals(2, cart.numberOfItems());
}
```

Libraries such as AssertJ, besides making the assertions more legible, also
help us in providing better error messages. Suppose our `Cart` class now has an 
`allItems()` method that returns all items that were previously stored in this cart:

```java
public Set<String> allItems() {
	return Collections.unmodifiableSet(items);
}
```

Asserting the outcome of this method using plain old JUnit assertions would look
like the following:

```java
@Test
void allItems() {
	cart.add("Playstation");
	cart.add("Big TV");

	var items = cart.allItems();

	assertTrue(items.contains("Playstation"));
	assertTrue(items.contains("Big TV"));
}
```

AssertJ enables us to not only write assertions about the items, 
but also about the structure of the set itself.
In the following example, we use a single assertion to make sure 
the set _only_ contains two specific items.
The method `containsExactlyInAnyOrder()` does exactly what its name says:

```java
@Test
void allItems() {
	cart.add("Playstation");
	cart.add("Big TV");

	var items = cart.allItems();

	assertThat(items).containsExactlyInAnyOrder("Playstation", "Big TV");
}
```

We therefore recommend that developers choose wisely how to write the assertion statements.
A good assertion clearly reveals its reason for failing, is legible, and is as specific
and insensitive as possible.


**Mystery Guest**: Integration tests often rely on external 
dependencies. These dependencies, or "guests", can be things like databases, 
files on the disk, or webservices. 
While such dependencies are unavoidable in these types of tests, making them explicit
in the test code may help developers in cases where these tests suddenly start to fail.
A test that makes use of a guest, but hides it from the developer (making it 
a "mystery guest") is simply harder to comprehend.

Make sure your test gives proper error messages, differentiating between a fail in the
expected behaviour and a fail due to a problem in the guest. Having assertions dedicated
to ensuring that the guest is in the right state before running the tests is often
the remedy that is applied to this smell.

{% set video_id = "QE-L818PDjA" %}
{% include "/includes/youtube.md" %}

{% set video_id = "DLfeGM84bzg" %}
{% include "/includes/youtube.md" %}


## Test code readability

We have discussed several test code best practices and smells. In many situations,
we have argued for the need of comprehensible, i.e., easy to read, test code.

We reinforce the fact that it 
is crucial that the developers can understand the test code easily.
**We need readable and understandable test code.** 
Note that "readability" is one of the test desiderata we mentioned above.

In the following subsections we provide advice on how to write readable test code.

### Test structure
As you have seen earlier, tests all follow the same structure: the Arrange, Act and Assert
structure.
When **these three parts are clearly separated, it is easier for a developer to see what is happening in the test**.
Your tests should make sure that a developer can identify these parts quickly and get the answers to the following questions: Where is the fixture? Where is the behaviour/method under test? 
Where are the assertions?

### Comprehensibility of the information
Test code is full of information, i.e., the input values that will be provided
to the class under test, how the information flows up to the method under test, 
how the output comes back from the exercise behaviour, and what the expected outcomes are.

Often we have to deal with complex data structures and information, which makes 
the test code also complex.
In such cases, **we should make sure that the (meaning of the) 
important information present in a test is easy to understand.**

Giving descriptive names to the information in the test code is helpful with this.
Let us illustrate this in the example below.
Suppose we have written a test for an `Invoice` class, which calculates the tax for
that invoice.

```java
public class Invoice {

	private final BigDecimal value;
	private final String country;
	private final CustomerType customerType;

	public Invoice(BigDecimal value, String country, CustomerType customerType) {
		this.value = value;
		this.country = country;
		this.customerType = customerType;
	}

	public BigDecimal calculate() {
		double ratio = 0.1;

		// some business rule here to calculate the ratio
		// depending on the value, company/person, country ...

		return value.multiply(new BigDecimal(ratio));
	}
}
```

Not-so-clear test code for the `calculate()` method could look like this:

```java
@Test
void test1() {
	var invoice = new Invoice(new BigDecimal("2500"), "NL", CustomerType.COMPANY);
	var v = invoice.calculate();
	assertEquals(250, v.doubleValue(), 0.0001);
}
```

Note how, at first glance, it may be hard to understand what all the information 
in the code means. It may require some extra effort to understand what
this invoice looks like. Imagine a real entity from a real enterprise system: an `Invoice`
class might have dozens of attributes. The name of the test as well as the name of
the cryptic variable `v` do not clearly explain what they mean. For developers less fluent
in JUnit, it may also be hard to understand what the 0.0001 means (it mitigates floating-point errors by making sure that both numbers are equal within the given delta).

A better version of this test method could be:

```java
@Test
void taxesForCompanies() {
	var invoice = new InvoiceBuilder()
			.asCompany()
			.withCountry("NL")
			.withAValueOf("2500")
			.build();

	var calculatedValue = invoice.calculate();

	assertThat(calculatedValue).isCloseTo(new BigDecimal("250"), within(new BigDecimal("0.001")));
} 
```

The usage of the `InvoiceBuilder` (the implementation of which we will show shortly) clearly expresses what
this invoice is about: it is an invoice for a company (as clearly stated by the `asCompany()` 
method), "NL" is the country of that invoice, and the invoice has a value of 2500. The
result of the behaviour now goes to a variable whose name says it all (`calculatedValue`). 
The assertion then explicitly mentions that, given this is a float number, the best we can do
is to compare whether they are close enough.

The `InvoiceBuilder` is an example of an implementation of a **Test Data Builder**, the design
pattern we mentioned before. The builder helps developers in creating fixtures, by providing
them with a clear and expressive API. The use of fluent interfaces 
(e.g., `asCompany().withAValueOf()...`) is also a common implementation choice.
In terms of its implementation, the `InvoiceBuilder` is simply
a Java class. The trick that allows methods to be chained is to return the class itself
in the methods (note that methods return `this`).

```java
public class InvoiceBuilder {

	private String country = "NL";
	private CustomerType customerType = CustomerType.PERSON;
	private BigDecimal value = new BigDecimal("500.0");

	public InvoiceBuilder withCountry(String country) {
		this.country = country;
		return this;
	}

	public InvoiceBuilder asCompany() {
		this.customerType = CustomerType.COMPANY;
		return this;
	}

	public InvoiceBuilder withAValueOf(String value) {
		this.value = new BigDecimal(value);
		return this;
	}

	public Invoice build() {
		return new Invoice(value, country, customerType);
	}
}
``` 

Developers should feel free to customise their builders as much as they want. A common
trick is to make the builder build a "common" version of the class, without requiring
the call to all the setup methods. A developer can then write:

```java
var invoice = new InvoiceBuilder().build();
```

In such a case, the `build` method, without any setup, will always build an invoice
for a person, with a value of 500.0, and having NL as country (see the initialised
values in the `InvoiceBuilder`). 

Other developers may write several shortcut methods that build other
"common" fixtures for the class. In the following example,
the `anyCompany()` method returns an Invoice that belongs to a company (and the
default value for the other fields). 
The `anyUS()` method builds an Invoice for someone in the US:

```java
public Invoice anyCompany() {
	return new Invoice(value, country, CustomerType.COMPANY);
}

public Invoice anyUS() {
	return new Invoice(value, "US", customerType);
}
```

Note how test data builders can help developers to avoid general fixtures.
Given that the builder makes it easier to build complex objects, developers may not
feel the need to rely so much on a general fixture.

Introducing test data builders, making good use of variable names to explain the meaning
of the information, having clear assertions, and (although not exemplified here) adding
comments in cases where code is not expressive enough will help developers in better
comprehending test code.


{% set video_id = "RlqLCUl2b0g" %}
{% include "/includes/youtube.md" %}

## Flaky tests

Flaky tests (or _erratic tests_, as Meszaros calls them in his book)
are tests that present "flaky" behaviour: 
they sometimes pass and sometimes fail, even though
developers have not performed any changes in their software systems.

Such tests have a negative impact on the productivity of software development teams.
It is hard to know whether a flaky test is failing because the behaviour
is buggy, or because it is simply flaky. Little by little, the excessive
presence of flaky tests can make developers lose confidence in their test
suites. Such lack of confidence might lead them to deploy their
systems even though the tests are failing (after all, they might be broken just because
of flakiness, and not because the system is misbehaving).

The prevalence and consequential impact of flaky tests in the software development
world has been increasing over time. Companies like Google and Facebook as well
as software engineering researchers have been
working extensively on automated ways to detect and fix flaky tests.


Flaky tests can have many causes, of which we can name these:

* A test can be flaky because it **depends on external and/or shared resources**.
For example, when we need a database to run our tests, 
any of the following things can happen:
    - Sometimes the test passes, because the database is available.
    - Sometimes it fails, because the database is not available.
    - Sometimes the test passes because the database is clean and ready for that test.
    - Sometimes the test fails because the same test was being run by the next developer and the database was not in a clean state.

* The tests can be flaky due to improper time-outs.
This is a common cause in web testing.
Suppose a test has to wait for something to happen in the system, e.g., a request
coming back from a webservice, which is then displayed in some HTML element.
If the web application is a bit slower than normal, the test might fail, just
because "it did not wait long enough".

* Tests can be flaky due to a possible hidden interaction between different
test methods.
Suppose that test A somehow influences the result of test B, 
possibly causing it to fail.

As you may have noticed, some of these causes 
correspond to scenarios we described when discussing the test smells 
and emphasise again how important the quality of test code is.

{% hint style='tip' %}
If you want to find the exact cause of a flaky test, 
the author of the XUnit Test Patterns book has made a whole decision table.
You can find it in the book or on Gerard Meszaros' website [here](http://xunitpatterns.com/Erratic%20Test.html).
Using the decision table you can find a probable cause for the flakiness of your test.

We list several interesting research papers on flaky tests, their impact on software testing, and current state-of-the-art detection tools in our references section.
{% endhint %}


{% set video_id = "-OQgBMSBL5c" %}
{% include "/includes/youtube.md" %}






## Exercises

**Exercise 1.**
Jeanette just heard that two tests are behaving strangely as when executed in isolation, both of them pass, but when executed together, they fail. Which one of the following **is not** the cause of this?

1. Both tests are very slow.
2. They depend upon the same external resources.
3. The execution order of the tests matters.
4. They do not perform a clean-up operation after execution.


**Exercise 2.**
RepoDriller is a project that extracts information from Git repositories. Its integration tests use lots of real Git repositories (that are created solely for the purpose of the test), each one with a different characteristic, e.g., one repository contains a merge commit, another repository contains a revert operation, etc.

Its tests look like this:

```java
@Test
public void test01() {

  // arrange: specific repo
  String path = "test-repos/git-4";

  // act
  TestVisitor visitor = new TestVisitor();
  new RepositoryMining()
  .in(GitRepository.singleProject(path))
  .through(Commits.all())
  .process(visitor)
  .mine();
  
  // assert
  Assert.assertEquals(3, visitor.getVisitedHashes().size());
  Assert.assertTrue(visitor.getVisitedHashes().get(2).equals("b8c2"));
  Assert.assertTrue(visitor.getVisitedHashes().get(1).equals("375d"));
  Assert.assertTrue(visitor.getVisitedHashes().get(0).equals("a1b6"));
}
```


Which test smell does this piece of code _might_ suffer from?

1. Mystery guest.
2. Condition logic in test.
3. General fixture.
4. Flaky test.


**Exercise 3.**
In the code below, we present the source code of an automated test.


```java
@Test
public void flightMileage() {
  // setup fixture
  // exercise constructor
  Flight newFlight = new Flight(validFlightNumber);
  // verify constructed object
  assertEquals(validFlightNumber, newFlight.number);
  assertEquals("", newFlight.airlineCode);
  assertNull(newFlight.airline);
  // setup mileage
  newFlight.setMileage(1122);
  // exercise mileage translator
  int actualKilometres = newFlight.getMileageAsKm();    
  // verify results
  int expectedKilometres = 1810;
  assertEquals(expectedKilometres, actualKilometres);
  // now try it with a canceled flight
  newFlight.cancel();
  boolean flightCanceledStatus = newFlight.isCancelled();
  assertFalse(flightCanceledStatus);
}
```

However, Joe, our new test specialist, believes this test is smelly and that it can be improved.
Which of the following should be Joe's main concern?

  
1. The test contains code that may or may not be executed, making the test less readable.
2. It is hard to tell which of several assertions within the same test method will cause a test failure.
3. The test depends on external resources and has nondeterministic results depending on when/where it is run.
4. The test reader is not able to see the cause and effect between fixture and verification logic because part of it is done outside the test method.



**Exercise 4.**
Look at the test code below. What is the most likely test code smell that this piece of code presents?

```java
@Test
void test1() {
  // webservice that communicates with the bank
  BankWebService bank = new BankWebService();

  User user = new User("d.bergkamp", "nl123");
  bank.authenticate(user);
  Thread.sleep(5000); // sleep for 5 seconds

  double balance = bank.getBalance();
  Thread.sleep(2000);

  Payment bill = new Payment();
  bill.setOrigin(user);
  bill.setValue(150.0);
  bill.setDescription("Energy bill");
  bill.setCode("YHG45LT");

  bank.pay(bill);
  Thread.sleep(5000);

  double newBalance = bank.getBalance();
  Thread.sleep(2000);
  
  // new balance should be previous balance - 150
  Assertions.assertEquals(newBalance, balance - 150);
}
```

1. Flaky test.
2. Test code duplication.
3. Obscure test.
4. Long method.



**Exercise 5.**
In the code below, we show an actual test from Apache Commons Lang, a very popular open source Java library. This test focuses on the static `random()` method, which is responsible for generating random characters. An interesting detail in this test is the comment: *Will fail randomly about 1 in 1000 times.*

```java
/**
 * Test homogeneity of random strings generated --
 * i.e., test that characters show up with expected frequencies
 * in generated strings.  Will fail randomly about 1 in 1000 times.
 * Repeated failures indicate a problem.
 */
@Test
public void testRandomStringUtilsHomog() {
    final String set = "abc";
    final char[] chars = set.toCharArray();
    String gen = "";
    final int[] counts = {0,0,0};
    final int[] expected = {200,200,200};
    for (int i = 0; i< 100; i++) {
       gen = RandomStringUtils.random(6,chars);
       for (int j = 0; j < 6; j++) {
           switch (gen.charAt(j)) {
               case 'a': {counts[0]++; break;}
               case 'b': {counts[1]++; break;}
               case 'c': {counts[2]++; break;}
               default: {fail("generated character not in set");}
           }
       }
    }
    // Perform chi-square test with df = 3-1 = 2, testing at .001 level
    assertTrue("test homogeneity -- will fail about 1 in 1000 times",
        chiSquare(expected,counts) < 13.82);
}
```

Which one of the following **is incorrect** about the test?

1. The test is flaky because of the randomness that exists in generating characters.
2. The test checks for invalidly generated characters, and that characters are picked in the same proportion.
3. The method being static has nothing to do with its flakiness.
4. To avoid the flakiness, a developer should have mocked the random function. 



## References

Test code best practices:

- Chapter 5 of Pragmatic Unit Testing in Java 8 with Junit. Langr, Hunt, and Thomas. Pragmatic Programmers, 2015.
- Meszaros, G. (2007). xUnit test patterns: Refactoring test code. Pearson Education.

Empirical studies:

- Pryce, N. Test Data Builders: an alternative to the Object Mother pattern. http://natpryce.com/articles/000714.html. Last accessed in March, 2020.
- Bavota, G., Qusef, A., Oliveto, R., De Lucia, A., & Binkley, D. (2012, September). An empirical analysis of the distribution of unit test smells and their impact on software maintenance. In 2012 28th IEEE International Conference on Software Maintenance (ICSM) (pp. 56-65). IEEE.

Flaky tests:

- Luo, Q., Hariri, F., Eloussi, L., & Marinov, D. (2014, November). An empirical analysis of flaky tests. In Proceedings of the 22nd ACM SIGSOFT International Symposium on Foundations of Software Engineering (pp. 643-653). ACM. 
Authors' version: [http://mir.cs.illinois.edu/~eloussi2/publications/fse14.pdf](http://mir.cs.illinois.edu/~eloussi2/publications/fse14.pdf)
- Bell, J., Legunsen, O., Hilton, M., Eloussi, L., Yung, T., & Marinov, D. (2018, May). DeFlaker: automatically detecting flaky tests. In Proceedings of the 40th International Conference on Software Engineering (pp. 433-444). ACM. 
Authors' version: [http://mir.cs.illinois.edu/legunsen/pubs/BellETAL18DeFlaker.pdf](http://mir.cs.illinois.edu/legunsen/pubs/BellETAL18DeFlaker.pdf)
- Lam, W., Oei, R., Shi, A., Marinov, D., & Xie, T. (2019, April). iDFlakies: A Framework for Detecting and Partially Classifying Flaky Tests. In 2019 12th IEEE Conference on Software Testing, Validation and Verification (ICST) (pp. 312-322). IEEE. 
Authors' version: [http://taoxie.cs.illinois.edu/publications/icst19-idflakies.pdf](http://taoxie.cs.illinois.edu/publications/icst19-idflakies.pdf)
- Listfield, J. Where do our flaky tests come from?  
Link: [https://testing.googleblog.com/2017/04/where-do-our-flaky-tests-come-from.html](https://testing.googleblog.com/2017/04/where-do-our-flaky-tests-come-from.html), 2017.
- Micco, J. Flaky tests at Google and How We Mitigate Them.  
Link: [https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html](https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html), 2017.
- Fowler, M. Eradicating Non-Determinism in Tests. Link: [https://martinfowler.com/articles/nonDeterminism.html](https://martinfowler.com/articles/nonDeterminism.html), 2011.
