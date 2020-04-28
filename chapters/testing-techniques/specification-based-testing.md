# Specification-Based Testing

In this chapter, we explore **specification-based testing** techniques. These use the *requirements* of the program (often written as text; think of user stories and/or UML use cases) as input for testing.

In simple terms, we devise a set
of inputs, where each input tackles one part (or *partition*)
of the program.

Given that specification-based techniques require no knowledge
of how the software inside the “box” is structured
(i.e., it does not matter if it is developed in Java or Python and concrete implementation details [such as usage of a particular data structure] are not of importance), these techniques are also referred to
as **black box testing**.


## Partitioning the input space

Programs are usually too complex to be tested with just a single test case.
There are different cases in which the program is executed 
and its execution often depends on various factors, such as the input
to the program.

Let's use a small program as an example. The specification below talks about a program that decides whether a given year is a leap year or not. 

> **Requirement: Leap year**
>
>Given a specific year as an input, the program should return *true* if 
>the provided year is a leap year and *false* if it is not.
>
>A year is a leap year if:
>
>- the year is divisible by 4;
>- and the year is not divisible by 100;
>- except when the year is divisible by 400 (because then it is still a leap year)

To find a good set of test cases, often referred to as a *test suite*,
we split the program into *classes*.
In other words, we divide the input space of
the program in such a way that:
1) Each class is different, i.e. it is unique, where
no two partitions represent/exercise the same behaviour;
2) We can easily verify whether the behaviour for a given input is correct or not.


By looking at the requirements above, we can derive the
following classes/partitions:

* Year is divisible by 4, but not divisible by 100 = `leap year, TRUE`
* Year is divisible by 4, divisible by 100, divisible by 400 = `leap year, TRUE`
* Not divisible by 4 = `not leap year, FALSE`
* Divisible by 4, divisible by 100, but not divisible by 400 = `not leap year, FALSE`

Note how each class above exercises the program in different ways.


{% set video_id = "kSLbxmXcPPI" %}
{% include "/includes/youtube.md" %}



## Equivalence partitioning

The partitions above are not test cases that we can implement directly because
each partition might be instantiated by an infinite number of inputs. For example,
for the partition "year not divisible by 4", there are infinitely many numbers
that are not divisible by 4 which we could use as concrete inputs to the program.
So how do we know which concrete input to instantiate for each of the partitions?

As we discussed earlier, each partition exercises the program in a certain way.
In other words, all input values from one specific partition will make the program
behave in the same way.
Therefore, any input we select should give us the same result.
We assume that, if the program behaves correctly for one given input,
it will work correctly for all other inputs from that class.
This idea of inputs being equivalent to each other
is called **equivalence partitioning**.
Thus, it does not matter which precise input we select and one test case per
partition will be enough.

Let’s now write some JUnit tests for the leap year problem. Remember that the name of a test method
in JUnit can be anything. It is good to name your test method after the 
partition that the method tests.

{% hint style='tip' %}
We discuss more about test code quality and best practices in writing test code in
a future chapter.
{% endhint %}

The _Leap Year_ specification has been implemented by a developer in the following way:

```java
public class LeapYear {

  public boolean isLeapYear(int year) {
    if (year % 400 == 0)
      return true;
    if (year % 100 == 0)
      return false;

    return year % 4 == 0;
  }
}
```

With the classes we devised above, we have 4 test cases in total (i.e., one test case
for each class/partition).
As any input can be used for a given partition,
the following inputs will be used for the partitions:

- 2016, divisible by 4, not divisible by 100.
- 2000, divisible by 4, also divisible by 100 and by 400.
- 39, not divisible by 4.
- 1900, divisible by 4 and 100, not by 400.

Implementing this using JUnit gives the following code for the tests:

```java
public class LeapYearTests {

  private LeapYear leapYear;

  @BeforeEach
  public void setup() {
    leapYear = new LeapYear();
  }

  @Test
  public void leapYearsNotCenturialTest() {
    boolean leap = leapYear.isLeapYear(2016);
    assertTrue(leap);
  }

  @Test
  public void leapYearsCenturialTest() {
    boolean leap = leapYear.isLeapYear(2000);
    assertTrue(leap);
  }

  @Test
  public void nonLeapYearsTest() {
    boolean leap = leapYear.isLeapYear(39);
    assertFalse(leap);
  }

  @Test
  public void nonLeapYearsCenturialTest() {
    boolean leap = leapYear.isLeapYear(1900);
    assertFalse(leap);
  }
}
```

Note that each test method covers one of the partitions and the naming of the method refers to the partition it covers.

For those who are learning JUnit: Note that the `setup` method is executed 
before each test, thanks to the `BeforeEach` annotation.
For each test, it creates a new `LeapYear` object.
This object is then used by the tests to execute the method under test.
In each test we first determine the result of the method.
After the method returns a value, we assert that this is the expected value.

{% set video_id = "mXmFiiifwaE" %}
{% include "/includes/youtube.md" %}


## Category-Partition Method

So far we have derived partitions by just looking at the specification of the program.
We basically used our experience and knowledge to derive the test cases.
In this chapter, we will discuss a more systematic way of deriving these partitions: the **Category-Partition** method.

The method provides us with a systematic way of deriving test cases, based on the characteristics of the input parameters. It also reduces the number of tests to a feasible number.

We now set out the steps of this method and then we illustrate the process with an example.

1. Identify the parameters, or the input of the program. For example, the parameters your classes and methods receive.
2. Derive characteristics of each parameter. For example, an `int year` should be a positive integer number between 0 and infinite. 
      - Some of these characteristics can be found directly in the specification of the program.
      - Others might not be found from specifications. For example, an input cannot be `null` if the method does not handle that well.

3. Add constraints in order to minimise the test suite.
      - Identify invalid combinations. For some characteristics it might not be possible to combine them with other characteristics.
      - Exceptional behaviour does not always have to be combined with all the different values of the other inputs. For example, trying a single `null` input might be enough to test that corner case.

4. Generate combinations of the input values. These are the test cases.

Let's apply the technique in the following program:

> **Requirement: Christmas discount**
> 
> The system should give a 25% discount on the cart when it is Christmas.
> The method has two input parameters: the total price of the products in the cart, and the date.
> When it is not Christmas it just returns the original price; otherwise it applies the discount.

Following the category-partition method:

1. We have two parameters:
      - The current date
      - The total price

2. Now for each parameter we define the characteristics as:
      - Based on the requirements, the only important characteristic is that the date can be either Christmas or not.
      - The price can be a positive number, or in certain circumstances it may be 0. Technically the price can also be a negative number. This is an exceptional case, as you cannot pay a negative amount.

3. The number of characteristics and parameters is not too large in this case. As the negative price is an exceptional case, we can test this with just one combination, instead of with a date that is Christmas and a date that is not Christmas.

4. We combine the other characteristics to get the following test cases:
      - Positive price on Christmas
      - Positive price not on Christmas
      - Price of 0 on Christmas
      - Price of 0 not on Christmas
      - Negative price on Christmas

Now we can implement these test cases.
Each of the test cases corresponds to one of the partitions that we want to test.

{% set video_id = "frzRmafsPBk" %}
{% include "/includes/youtube.md" %}

## Walking example

> **Requirement: Chocolate bars**
>
> A package stores a certain number of chocolate bars in kilos.
> A package is composed of small bars (1 kilo each) and big bars (5 kilos each).
>
> Assume that the package is always filled with the maximum number of big bars possible, return the number of small bars required to complete the package. 
> Return -1 if it is not possible to fill the package completely.
>
> The input of the program is: the number of available small bars, the number of available big bars, and the total number of kilos of the package.

A possible implementation for this program is as follows:

```java
public class ChocolateBars {

    public static final int CANNOT_PACK_BAG = -1;

    public int calculate(int small, int big, int total) {
        int maxBigBoxes = total / 5;
        int bigBoxesWeCanUse = Math.min(maxBigBoxes, big);
        total -= (bigBoxesWeCanUse * 5);

        if(small <= total)
            return CANNOT_PACK_BAG;
        return total;

    }
}
```

In this requirement, the partitions are less clear and it is essential to understand the problem fully
in order to derive the partitions.

One way to perform the analysis is to consider how the input variables affect the output variables. We observe that:

* There are three input variables: _number of small bars_, _number of big bars_, _number of kilos in a package_. They are all integers and values can range from 0 to infinite.
* Given a valid _number of kilos in a package_, the outcome is then based on the _number of big bars_ and _number of small bars_. This means we can not analyse each variable separately, but only together.

We derive the following classes / partitions:

* **Need only small bars**. A solution that only uses small bars (and does not use big bars).
* **Need only big bars**. A solution that only uses the big bars (and does not use small bars).
* **Need small + big bars**. A solution that has to use both small and big bars.
* **Not enough bars**. A case in which it is impossible, because there are not enough bars.

We also derive an invalid class:

* **Not from the specs**: An exceptional case (e.g., negative numbers in any of the inputs).

For each of these classes, we can devise five concrete test cases:

* **Need only small bars**. small = 4, big = 2, total = 3
* **Need only big bars**. small = 5, big = 3, total = 10
* **Need small + big bars**. small = 5, big = 3, total = 17
* **Not enough bars**. small = 1, big = 1, total = 10
* **Not from the specs**: small = -1, big = -1, total = -1

In JUnit code:

```java
public class ChocolateBarsTest {
    private final ChocolateBars bars = new ChocolateBars();

    @Test
    void notEnoughBars() {
        assertEquals(-1, bars.calculate(1, 1, 10));
    }

    @Test
    void onlyBigBars() {
        assertEquals(0, bars.calculate(5, 3, 10));
    }

    @Test
    void bigAndSmallBars() {
        assertEquals(2, bars.calculate(5, 3, 17));
    }

    @Test
    void onlySmallBars() {
        assertEquals(3, bars.calculate(4, 2, 3));
    }

    @Test
    void invalidValues() {
      assertEquals(-1, bars.calculate(-1, -1, -1));
    }
}
```

This example shows a case where deriving good test cases becomes more challenging due to the
specifications being complex.

{% hint style='tip' %}
If you know some advanced features of JUnit, you might be wondering why we did not use, e.g., Parameterized Tests. We will refactor this test code in a future chapter.
{% endhint %}

{% set video_id = "T8caAUwgquQ" %}
{% include "/includes/youtube.md" %}



## Random testing vs specification-based testing

One might think: but what if, instead of looking at the requirements,
a tester just keeps giving random inputs to the program?
**Random testing** is indeed a popular black-box technique where programs are tested by generating random inputs. 

Although random testing can definitely help us in finding bugs, it is not an effective way to find bugs in a large input space. 
Developers/testers use their experience and knowledge of the program to test trouble-prone areas more effectively.
However, they generate a limited number of tests in a specific time period such as a day,
while computers can generate millions of tests in the same period of time.
A combination of random testing and partition testing is therefore the most beneficial.

{% hint style='tip' %}
In future chapters, fuzzing testing and AI-based testing will be discussed, with information
about automated random testing.
{% endhint %}

## Exercises

**Exercise 1.**
What is an Equivalence Partition?


1. A group of results that is produced by one method
2. A group of results that is produced by one input passed into different methods
3. A group of inputs that all make a method behave in the same way
4. A group of inputs that gives exactly the same output in every method

**Exercise 2.**
We have a program called FizzBuzz.
It does the following:
> Given an integer `n`, return the string form of the number followed by `"!"`.
> If the number is divisible by 3 use `"Fizz"` instead of the number,
> and if the number is divisible by 5 use `"Buzz"` instead of the number,
> and if the number is divisible by both 3 and 5, use `"FizzBuzz"`

Examples:
* The integer 3 yields `"Fizz!"`
* The integer 4 yields `"4!"`
* The integer 5 yields `"Buzz!"`
* The integer 15 yields `"FizzBuzz"`

A novice tester is trying hard to devise as many tests as she can for
the FizzBuzz method.
She came up with the following tests:

- T1 = 15
- T2 = 30
- T3 = 8
- T4 = 6
- T5 = 25

Which of these tests can be removed while keeping a good test suite?

Which concept can we use to determine the tests that can be removed?

**Exercise 3.**
See a slightly modified version of the HashMap's `put` method Javadoc below. (Source code [here](http://developer.classpath.org/doc/java/util/HashMap-source.html)).

```java
/**
 * Puts the supplied value into the Map,
 * mapped by the supplied key.
 * If the key is already in the map, its
 * value will be replaced by the new value.
 *
 * NOTE: Nulls are not accepted as keys;
 *  a RuntimeException is thrown when key is null.
 *
 * @param key the key used to locate the value
 * @param value the value to be stored in the HashMap
 * @return the prior mapping of the key, or null if there was none.
 */
public V put(K key, V value) {
  // implementation here
}
```

Apply the category/partition method.
What are the minimal and most suitable partitions?

**Exercise 4.**
Zip codes in country X are always composed of 4 numbers + 2 letters, e.g., `2628CD`.
Numbers are in the range `[1000, 4000]`.
Letters are in the range `[C, M]`.

Consider a program that receives two inputs: an integer (for the 4 numbers) and a string (for the 2 letters), and returns `true` (valid zip code) or `false` (invalid zip code).

The boundaries for this program appear to be straightforward:
- Anything below 1000 -> invalid
- [1000, 4000] -> valid
- Anything above 4000 -> invalid
- [A, B] -> invalid
- [C, M] -> valid
- [N, Z] -> invalid

Based on what you as a tester *assume* about the program, which invalid cases can you come up with?
Describe these invalid cases and how they might exercise the program based on your assumptions.

**Exercise 5.**
See a slightly modified version of the HashSet's `add()` Javadoc below.
Apply the category/partition method. What are the **minimal and most suitable partitions** for the `e` input parameter? 

```java
/**
 * Adds the specified element to this set if it 
 * is not already present.
 * If this set already contains the element, 
 * the call leaves the set unchanged
 * and returns false.
 *
 * If the specified element is NULL, the call leaves the
 * set unchanged and returns false.
 *
 * @param e element to be added to this set
 * @return true if this set did not already contain 
 *   the specified element
 */
public boolean add(E e) {
    // implementation here
}
```


**Exercise 6.**
Which of the following statements **is false** about applying the category/partition method in the Java method below?

```java
/**
 * Puts the supplied value into the Map, 
 * mapped by the supplied key.
 * If the key is already in the map, its
 * value will be replaced by the new value.
 *
 * NOTE: Nulls are not accepted as keys; 
 *  a RuntimeException is thrown when key is null.
 *
 * @param key the key used to locate the value
 * @param value the value to be stored in the HashMap
 * @return the prior mapping of the key, 
 *  or null if there was none.
 */
public V put(K key, V value) {
  // implementation here
}
```


1. The specification does not specify any details about the `value` input parameter, and thus, experience should be used to partition it, e.g., `value` being null and not null.

2. The number of tests generated by the category/partition method can grow quickly, as the chosen partitions for each category are later combined one-by-one. This is not a practical problem to the `put()` method because the number of categories and their partitions is small.

3. In an object-oriented language, besides using the method's input parameters to explore partitions, we should also consider the internal state of the object (i.e., the class's attributes), as it can also affect the behaviour of the method.

4. With the information in hands, it is not possible to perform the category/partition method, as the source code is required for the last step of the category/partition method: adding constraints.


**Exercise 7.**
Consider a `find` program that finds occurrences of a pattern in a file, the program has the following syntax:

```
find <pattern> <file>
```

A tester, after reading the specs and following the Category-Partition method, devised the following test specification:


* **Pattern size:** empty, single character, many characters, longer than any line in the file.
* **Quoting:** pattern is quoted, pattern is not quoted, pattern is improperly quoted.
* **File name:** good file name, no file name with this name, omitted.
* **Occurrences in the file:** none, exactly one, more than one.
* **Occurrences in a single line, assuming line contains the pattern:** one, more than one.

However, the number of combinations is too high now. What actions could we take to reduce the number of combinations?

**Exercise 8.**
What test cases should be created when taking both the partition of the input parameters and the internal state of the object into account?

```java
/**
 * Adds the specified element to this set if it 
 * is not already present.
 * If this set already contains the element, 
 * the call leaves the set unchanged
 * and returns false.
 *
 * If the specified element is NULL, the call leaves the
 * set unchanged and returns false.
 *
 * If the method isFull of the calling object returns true,
 * the call leaves the set unchanged and return false.
 *
 * @param e element to be added to this set
 * @return true if this set did not already contain 
 *   the specified element
 */
public boolean add(E e) {
    // implementation here
}
```



## References

* Graham, D., Van Veenendaal, E., & Evans, I. (2008). Foundations of software testing: ISTQB certification. Cengage Learning EMEA. Chapter 4.

* Pezzè, M., & Young, M. (2008). Software testing and analysis: process, principles, and techniques. John Wiley & Sons. Chapter 10.

* Ostrand, T. J., & Balcer, M. J. (1988). The category-partition method for specifying and generating functional tests. Communications of the ACM, 31(6), 676-686.

* Pacheco, C., & Ernst, M. D. (2007, October). Randoop: feedback-directed random testing for Java. In Companion to the 22nd ACM SIGPLAN conference on Object-oriented programming systems and applications companion (pp. 815-816).

