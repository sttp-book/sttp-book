# Software testing automation (with JUnit)

Before we dive into the different testing techniques, let us first get used
to software testing automation frameworks. In this book, we will use JUnit, as
all our code examples are written in Java. If you are using a different programming language in your daily work, note that testing frameworks in other languages offer similar functionalities.

We will now introduce an example program and then use it to demonstrate how to write JUnit tests. The code implemented in this chapter can be found at the `roman` package in the [code examples](https://github.com/sttp-book/code-examples/) repository.

> **Requirement: Roman numerals**
>
> Implement a program that receives a string as a parameter
> containing a roman number and then converts it to an integer.
>
> In roman numerals, letters represent values:
>
> * I = 1
> * V = 5
> * X = 10
> * L = 50
> * C = 100
> * D = 500
> * M = 1000
>
> Letters can be combined to form numbers.
> The letters should be ordered from the highest to the lowest value.
> For example `CCXVI` would be 216.
> 
> Some numbers need to make use of a subtractive notation to be represented.
> Example: 9 is `IX`, 40 is `XL`, 14 is `XIV`.


{% set video_id = "srJ91NRpT_w" %}
{% include "/includes/youtube.md" %}


A possible implementation for the _Roman Numerals_ requirement is as follows:

```java
package tudelft.roman;

import java.util.HashMap;
import java.util.Map;

public class RomanNumeral {
  private static Map<Character, Integer> map;

  static {
    map = new HashMap<>();
    map.put('I', 1);
    map.put('V', 5);
    map.put('X', 10);
    map.put('L', 50);
    map.put('C', 100);
    map.put('D', 500);
    map.put('M', 1000);
  }

  public int convert(String s) {
    int convertedNumber = 0;

    for (int i = 0; i < s.length(); i++) {
      int currentNumber = map.get(s.charAt(i));
      int next = i + 1 < s.length() ? map.get(s.charAt(i + 1)) : 0;

      if (currentNumber >= next) {
        convertedNumber += currentNumber;
      } else {
        convertedNumber -= currentNumber;
      }
    }

    return convertedNumber;
  }
}
```

With the implementation in hands, the next step is to devise
test cases for the program.
Use your experience as a developer to devise as many test cases as you can.
To get you started, a few examples: 

* T1 = Just one letter, e.g., C should equal 100
* T2 = Different letters combined, e.g., CLV = 155
* T3 = Subtractive notation, e.g., CM = 900

In future chapters, we will explore how to devise those test cases. The output
of that stage will often be similar to the one above: a test case number,
an explanation of what the test is about (we will later call it _class_ or _partition_),
and a concrete instance of input that exercises the program in that way, together
with the expected output.

Once you are done with the "manual task of devising test cases", you are ready to move on to the next section, which shows how to turn them into automated test cases using JUnit.

## The JUnit Framework

Testing frameworks enable us to write test cases in a way that they can be easily executed by the machine. In Java, the standard framework to write automated tests is JUnit, and its most recent version is 5.x.

The steps to create a JUnit class/test is often the following:

* Create a Java class under the directory `/src/test/java/roman/` (or whatever test directory your project structure uses). As a convention, the name of the test class is similar to the name of the class under test. For example, a class that tests the `RomanNumeral` class is often called `RomanNumeralTest`. In terms of package structure, the test class also inherits the same package as the class under test. In our case, `tudelft.roman`.

* For each test case we devise for the program/class, we write a test method. A JUnit test method returns `void` and is annotated with `@Test` (an annotation that comes from JUnit 5's `org.junit.jupiter.api.Test`). The name of the test method does not matter to JUnit, but it does matter to us. A best practice is to name the test after the case it tests. 

* The test method instantiates the class under test and invokes the method under test. The test method passes the previously defined input in the test case definition to the method/class. The test method then stores the result of the method call (e.g., in a variable).

* The test method asserts that the actual output matches the expected output. The expected output was defined during the test case definition phase. To check the outcome with the expected value, we use assertions. An assertion checks whether a certain expectation is met; if not, it throws an `AssertionError` and thereby causes the test to fail. A couple of useful assertions are:

  * `Assertions.assertEquals(expected, actual)`: Compares whether the expected and actual values are equal. The test fails otherwise. Be sure to pass the expected value as the first argument, and the actual value (the value that comes from the program under test) as the second argument.
    Otherwise the fail message of the test will not make sense.
  * `Assertions.assertTrue(condition)`: Passes if the condition evaluates to true, fails otherwise.
  * `Assertions.assertFalse(condition)`: Passes if the condition evaluates to false, fails otherwise.
  * More assertions and additional arguments can be found in [JUnit's documentation](https://junit.org/junit5/docs/current/api/org.junit.jupiter.api/org/junit/jupiter/api/Assertions.html). To make easy use of the assertions and to import them all in one go, you can use `import static org.junit.jupiter.api.Assertions.*;`.


The three test cases we have devised can be automated as follows:

```java
package tudelft.roman;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

public class RomanNumeralTest {

  @Test
  void convertSingleDigit() {
    RomanNumeral roman = new RomanNumeral();
    int result = roman.convert("C");

    assertEquals(100, result);
  }

  @Test
  void convertNumberWithDifferentDigits() {
    RomanNumeral roman = new RomanNumeral();
    int result = roman.convert("CCXVI");

    assertEquals(216, result);
  }

  @Test
  void convertNumberWithSubtractiveNotation() {
    RomanNumeral roman = new RomanNumeral();
    int result = roman.convert("XL");

    assertEquals(40, result);
  }
}
```

At this point, if you see other possible test cases (there are!), go ahead and implement them.


{% set video_id = "XS4-93Q4Zy8" %}
{% include "/includes/youtube.md" %}

## Test code engineering matters

In practice, developers write (and maintain!) thousands of test code lines. 
Taking care of the quality of test code is therefore of utmost importance.
Whenever possible, we will introduce you to some best practices in test
code engineering.

In the test code above, we create the `roman` object four times.
Having a fresh clean instance of an object for each test method is a good idea, as 
we do not want "objects that might be already dirty" (and thus, being the cause for the test to fail, and not because there was a bug in the code) in our test. 

However, having duplicated code is not desirable. The problem with duplicated test code
is the same as in production code: if there is a change to be made, the change has to be made
in all the points where the duplicated code exists.

In this example, we should try to isolate the line of code responsible for creating
the class under test.
In order to do so, we can use the `@BeforeEach` feature that JUnit provides.
JUnit runs methods that are annotated with `@BeforeEach` before every test method.
We therefore can instantiate the `roman` object inside a method annotated with `BeforeEach`.

Although you might be asking yourself: "But it is just a single line of code... Does it really matter?", remember that as test code becomes more complicated, the more important test code quality becomes.

The new test code would look as follows:

```java
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class RomanNumeralTest {
  
  private RomanNumeral roman;
  
  @BeforeEach
  void setup() {
    roman = new RomanNumeral();
  }

  @Test
  void convertSingleDigit() {
    int result = roman.convert("C");

    assertEquals(100, result);
  }

  @Test
  void convertNumberWithDifferentDigits() {
    int result = roman.convert("CCXVI");

    assertEquals(216, result);
  }

  @Test
  void convertNumberWithSubtractiveNotation() {
    int result = roman.convert("XL");

    assertEquals(40, result);
  }
}
```

Feel free to read more about [JUnit's annotations](https://junit.org/junit5/docs/current/user-guide/#writing-tests-annotations) in its documentation.

We discuss test code quality in a more systematic way in a future 
chapter.

## Tests and refactoring

A more experienced Java developer might be looking at our implementation of the
Roman Numeral problem and thinking that there are more elegant ways of implementing it.
That is indeed true. _Software refactoring_ is a constant activity in software
development. 

However, how can one refactor the code and still make sure it presents the same behaviour?
Without automated tests, that might be a costly activity. Developers would have to perform
manual tests after every single refactoring operation. Software refactoring activities benefit
from extensive automated test suites, as developers can refactor their code and, in a matter
of seconds or minutes, get a clear feedback from the tests.

See this new version of the `RomanNumeral` class, where we deeply refactored the code:

* We gave a better name to the method: we call it `asArabic()` now.
* We inlined the declaration of the Map, and used the `Map.of` utility method.
* We make use of an auxiliary array (`digits`) to get the current number inside the loop.
* We extracted a private method that decides whether it is a subtractive operation.
* We made use of the `var` keyword, as introduced in Java 10.

```java
public class RomanNumeral {
  private final static Map<Character, Integer> CHAR_TO_DIGIT = 
    Map.of('I', 1, 'V', 5, 'X', 10, 'L', 50, 'C', 100, 'D', 500, 'M', 1000);

  public int asArabic(String roman) {
    final var digits = roman
      .chars()
      .map(c -> CHAR_TO_DIGIT.get((char)c)).toArray();

    var result = 0;
    for(int i = 0; i < digits.length; i++) {
      final var currentNumber = digits[i];

      result += isSubtractive(digits, i, currentNumber) ? 
                  -currentNumber : 
                  currentNumber;
    }

    return result;
  }

  private static boolean isSubtractive(int[] digits, int i, int currentNumber) {
    return i + 1 < digits.length
        && currentNumber < digits[i + 1];
  }
}
```

The number of refactoring operations is not small. And experience shows us that a lot
of things can go wrong. Luckily, we now have an automated test suite that we can run and
get some feedback.

Let us also take the opportunity and improve our test code:

* Given that our goal was to isolate the single line of code that instantiated the class under test, instead of using the `@BeforeEach`, we now instantiate it directly in the class. JUnit creates a new instance of the test class before each test (again, as a way to help developers in avoiding test cases that fail due to previous test executions). This allows us to mark the field as `final`.
* We inlined the method call and the assertion. Now tests are written in a single line.
* We give test methods better names. It is common to rename test methods; the more we understand the problem, the more we can give good names to the test cases.
* We devised one more test case and added it to the test suite.

```java
public class RomanNumeralTest {
  /*
  JUnit creates a new instance of the class before each test,
  so test setup can be assigned as instance fields.
  This has the advantage that references can be made final
  */
  final private RomanNumeral roman = new RomanNumeral();

  @Test
  public void singleNumber() {
      Assertions.assertEquals(1, roman.asArabic("I"));
  }

  @Test
  public void numberWithManyDigits() {
      Assertions.assertEquals(8, roman.asArabic("VIII"));
  }

  @Test
  public void numberWithSubtractiveNotation() {
      Assertions.assertEquals(4, roman.asArabic("IV"));
  }

  @Test
  public void numberWithAndWithoutSubtractiveNotation() {
      Assertions.assertEquals(44, roman.asArabic("XLIV"));
  }
}

```

Lessons to be learned: 

* Get to know your testing framework. 
* Never stop refactoring your production code.
* Never stop refactoring your test code.

## Advantages of test automation

Having an automated test suite brings several advantages to software
development teams. Automated test suites:

* **Are less prone to obvious mistakes.** Developers who perform manual testing several times a day might make mistakes, e.g., by forgetting to execute a test case, by mistakenly marking a test as passed when the software actually exhibited faulty behaviour, etc.

* **Execute tests faster than developers.** The machine can run test cases way faster than developers can. Just imagine more complicated scenarios where the developers would have to type long sequences of inputs, verify the output at several different parts of the system. An automated test runs and gives feedback orders of magnitude faster than developers.

* **Brings confidence during refactoring.** As we just saw in the example, automated test suites enables developers to refactor their code more constantly. After all, developers know that they have a safety net; if something goes wrong, the test will fail.

Clearly, at first, one might argue that writing test code might feel like a loss in productivity. 
After all, developers now have to not only write production code, but also test code.
Developers now have to not only maintain production code, but also maintain test code.
 _This could not be further from the truth_.
 Once you master the tools and techniques, formalising test cases as JUnit methods
will actually save you time; imagine how many times you have executed the same 
manual test over and over. How much time have you lost by doing 
the same task repeatedly? 

Studies have shown that developers who write tests spend less time debugging their systems when compared to developers who do not (Janzen), that the
impact in productivity is not as significant as one would think (Maximilien and Williams), 
and that bugs
are fixed faster (Lui and Chen). Truth be told: 
these experiments compared teams using Test-Driven Development (TDD) against teams not
using TDD, and not the existence of a test suite per se. Still, the presence of test code
is the remarking characteristic that emerges from TDD. Nevertheless, as a society,
we might not need more evidence on the benefits of test automation. If we look around,
from small and big companies to big open source projects, they all rely on extensive
test suites to ensure quality. **Testing (and test automation) pays off.**

## Exercises

**Exercise 1.**
Implement the `RomanNumeral` class. Then, write as many tests as you
can for it, using JUnit.

For now, do not worry about how to derive test cases. Just follow
your intuition. 

**Exercise 2.**
Choose a problem from [CodingBat](https://codingbat.com/java/Logic-2). Solve it.
Then, write as many tests as you
can for it, using JUnit.

For now, do not worry about how to derive test cases. Just follow
your intuition. 


## References

* Pragmatic Unit Testing in Java 8 with Junit. Langr, Hunt, and Thomas. Pragmatic Programmers, 2015.

* JUnit's manual: https://junit.org/junit5/docs/current/user-guide/.

* JUnit's manual, Annotations: https://junit.org/junit5/docs/current/user-guide/#writing-tests-annotations.


* Janzen, D. S. (2005, October). Software architecture improvement through test-driven development. In Companion to the 20th annual ACM SIGPLAN conference on Object-oriented programming, systems, languages, and applications (pp. 240-241).

* Maximilien, E. M., & Williams, L. (2003, May). Assessing test-driven development at IBM. In 25th International Conference on Software Engineering, 2003. Proceedings. (pp. 564-569). IEEE.

* Lui, K. M., & Chan, K. C. (2004, June). Test driven development and software process improvement in china. In International Conference on Extreme Programming and Agile Processes in Software Engineering (pp. 219-222). Springer, Berlin, Heidelberg.
