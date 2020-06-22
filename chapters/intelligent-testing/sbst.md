# Search-based software testing

Imagine a computer program that looks at your code implementation and, based on what it sees, it automatically generates (JUnit) test cases that achieve 100% branch coverage. If this sounds like sci-fi to you, you should know it is not. In fact, automated test case generation tools are getting better by the day.

In this chapter, we will explore how it works. More specifically, we will discuss random and search-based test case generation. Finally, we will show you some tools. Note that _search-based software testing_ is a complex topic and requires an entire book on it. Here, we only illustrate the main ideas behind it.

## Random test case generation

Suppose you have the following `Triangle` program that identifies the type of the triangle, given the length of each side:

```java
public class Triangle {

    private final int a, b, c;

    enum TriangleType {
        EQUILATERAL, ISOSCELES, SCALENE
    }

    public Triangle(int a, int b, int c) {
        this.a = a;
        this.b = b;
        this.c = c;
    }

    // https://www.geeksforgeeks.org/program-to-find-the-type-of-triangle-from-the-given-coordinates/
    public TriangleType classify(int a, int b, int c) {
        if (a == b && b == c)
            return TriangleType.EQUILATERAL;
        else if (a == b || b == c)
            return TriangleType.ISOSCELES;
        else
            return TriangleType.SCALENE;
    }
}
```

For a program that automatically generate test cases, all it needs to do is:

1. Instantiate the class under test.
1. If the constructor has parameters, pass random values to it.
1. Invoke the method under test.
1. If the method has parameters, pass random values to it.
1. If the method returns a value, store it.
1. Check the output produced by the program and use it to write the assertion.
1. Measure the achieved (branch) coverage.
1. Repeat the procedure until the entire budget (e.g. a timeout) is consumed.

An example of a randomly generated test would be:

```java
@Test
void t1() {
    Triangle t = new Triangle(5, 7, 10);
    Triangle.TriangleType type = t.classify();
    assertThat(type).isEqualTo(Triangle.TriangleType.SCALENE);
}
```

Suppose the tool has a budget of 10 minutes, and stops afterwards. After 10 minutes, the tool might have generated hundreds (or even thousands) of test cases like that. Given that inputs are generated randomly, it is probable that the generated tests cover many branches of the program. 

A well-known tool (at least within the academic community) for Java programs that works precisely as described above is [Randoop](https://randoop.github.io/randoop/). According to its own manual: _Randoop can be used for two purposes: to find bugs in your program, and to create regression tests to warn you if you change your program's behavior in the future._ You can see the output of Randoop for the `Triangle` class here: https://github.com/sttp-book/code-examples/blob/master/src/test/java/tudelft/sbst/RegressionTest0.java.

## Search-based software testing

As you can imagine, randomly generating test cases might not work well (i.e. achieve high coverage) for complicated programs. Imagine that a specific branch of the program can only be achieved by a very specific input. Chances are that, randomly, that specific input will never be generated. Therefore, the questions is: _can we do better than random test case generation?_

One idea is to model the problem of "finding test cases" as an optimization problem. We will not go into details of what an optimization problem is, but let us use the `Triangle` as a case study again:

1. Suppose we are targeting the `classify()` method, and, more specifically, the `if (a == b || b == c)` branch.
1. Let us generate a set of random tests for the `classify()` method, similarly to what we have done above. Suppose the generated tests were T1=(`a=2`, `b=5`, `c=9`), T2=(`a=2`, `b=3`, `c=8`), up to T50.
1. Each of the randomly generated test cases would reach a different branch. If the target branch is exercised, the program simply returns the solution test case. If not, the program then analyzes the test cases in hands and how far they are from being a solution. If we look at T1, we see that, for `a==b`, we would need +3 in `a` or -3 in `b`; for `b==c`, we would need +4 in `b`, or -4 in `c`. If we look at T2, for `a==b`, we need +1 in `a`, or -1 in `b`. Note that T2 is almost there, but not yet! Also note that T2 is closer to be the test we are looking for than T1. Let us call _fitness_ the distance that the test is from being a solution.
1. The best test cases, i.e. the test cases closest to exercising the target branch, are then used to generate the "next generation" of test cases. That can be achieved by simple mutations in the values, e.g. adding a +1 in some of the inputs, and by crossover, e.g. getting the value of `a` from T1 and combining with the values of `b` and `c` of T2. 
1. The new test cases are then re-evaluated, i.e. their fitness is calculated. If a solution is found, the program stops. If not, it continues the search until the budget is exhausted.

Note that, little by little (or, after hundreds or even thousands of generations), the test cases get closer and closer to the target branch. For readers familiar with genetic algorithms, this is exactly what is going on here.

Clearly, there are several - theoretical and engineering - challenges to make all of this happen. And that is what software engineering researchers have been researching for many years in an area that is now known as _search-based software testing_. Note that search-based test case generation approaches are definitely more efficient than random generation, as it is able to use its budget more wisely! 

The most popular tool for search-based automated test case generation is [EvoSuite](http://www.evosuite.org).  

{% hint style='tip' %}
Currently, EvoSuite only works with Java 8 programs. Given that our code-examples use Java 11, we cannot easily run it there. EvoSuite developers are working hard to support newer versions of Java.
{% endhint %}

## The oracle problem

Determining whether the program produces the correct output for a given input is a hard problem. The problem has even a specific name: _the oracle problem_. 

Given that tools such as Randoop and EvoSuite cannot really know what the correct output is, it uses the output that the program gives as assertions. In this sense, tests that are produced by these tools do not reveal the functional bugs one would manually find. 

Nevertheless, we can assume other properties of the system that tools like EvoSuite can use to find a bug. For example, we can suppose that, whenever a given input makes a method to throw an Exception, that is a bug. Or whenever the system takes more than a specific number of seconds to respond, that is a bug! See [a list of errors that Randoop looks for](https://randoop.github.io/randoop/manual/index.html#kinds_of_errors): contracts over Object's equals(), hashCode(), clone(), toString(), Comparable's compare() and compareTo(), and repOk() to check the internal representation of the object (similarly to what we discussed in the design-by-contracts chapter).

## Automated test case generation in practice

Automated test case generation tools are getting more and more popular in industry. Facebook, for example, has been working on [Sapienz](https://engineering.fb.com/developer-tools/sapienz-intelligent-automated-software-testing-at-scale/), a search-based tool that looks for bugs/crashes in their mobile apps.

You can imagine such tools being plugged in continuous integration or nightly builds. Once the tool finds a crash, it reports back to developers, who then debug, fix the problem, and add the test case to the test suite of the program to ensure regressions will not happen. Automated test case generation tools are an interesting and complementary testing technique.

## Exercises

1. Run Randoop in any of the classes of our code examples repository. Check the `run-randoop.sh`.

## References

* Pacheco, Carlos, and Michael D. Ernst. "Randoop: feedback-directed random testing for Java." In Companion to the 22nd ACM SIGPLAN conference on Object-oriented programming systems and applications companion, pp. 815-816. 2007.

* Fraser, Gordon, and Andrea Arcuri. "Evosuite: automatic test suite generation for object-oriented software." In Proceedings of the 19th ACM SIGSOFT symposium and the 13th European conference on Foundations of software engineering, pp. 416-419. 2011.

* Mao, Ke. Sapienz: Intelligent automated software testing at scale. https://engineering.fb.com/developer-tools/sapienz-intelligent-automated-software-testing-at-scale/
