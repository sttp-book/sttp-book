# Fuzz testing

Fuzzing is a popular dynamic testing technique used for automatically generating complex test cases. 
Fuzzers bombard the System Under Test (SUT) with randomly generated inputs in the hope to cause crashes. 
A crash can either originate from *failing assertions*, *memory leaks*, or *improper error handling*. 
Fuzzing has been successful in discovering [unknown bugs](https://lcamtuf.coredump.cx/afl/) in software.

{% hint style='tip' %}
Note that fuzzing cannot identify flaws that do not trigger a crash.
{% endhint %}

**Random fuzzing** is the most primitive type of fuzzing, where the SUT is considered as a completely black box, with no assumptions about the type and format of the input. 
It can be used for exploratory purposes, but it takes a long time to generate any meaningful test cases. 
In practice, most software takes some form of _structured input_ that is pre-specified, so we can exploit that knowledge to build more efficient fuzzers.


There are two ways of generating fuzzing test cases:

1. **Mutation-based Fuzzing** creates permutations from example inputs to be given as testing inputs to the SUT. These mutations can be anything ranging from *replacing characters* to *appending characters*. Since mutation-based fuzzing does not consider the specifications of the input format, the resulting mutants may not always be valid inputs. However, it still generates better test cases than the purely random case. _ZZuf_ is a popular mutation-based application fuzzer that uses random bit flipping. _American Fuzzy Lop (AFL)_ is a fast and efficient security fuzzer that uses genetic algorithms to increase code coverage and find better test cases.

2. **Generation-based Fuzzing**, also known as *Protocol fuzzing*, takes the file format and protocol specification of the SUT into account when generating test cases. Generative fuzzers take a data model as input that specifies the input format, and the fuzzer generates test cases that only alter the values while conforming to the specified format. For example, for an application that takes `JPEG` files as input, a generative fuzzer would fuzz the image pixel values while keeping the `JPEG` file format intact. _PeachFuzzer_ is an example of a generative fuzzer.

Compared to mutative fuzzers, generative fuzzers are _less generalisable_ and _more difficult to set up_ because they require input format specifications. 
However, they produce higher-quality test cases and result in better code coverage.


## Maximising code coverage

One of the challenges of effective software testing is to generate test cases that not only _maximise the code coverage, but do so in a way that tests for a wide range of possible values_. 
Fuzzing helps achieve this goal by generating wildly diverse test cases. 
For example, [this blog post by Regehr](https://blog.regehr.org/archives/896) describes the use of fuzzing in order to optimally test an ADT implementation.

We want the fuzzer to generate these test cases in a reasonable time.
There are various ways in which we achieve maximal code coverage in less time:

1. Multiple tools
2. Telemetry as heuristics
3. Symbolic execution


### Multiple tools
A simple yet effective way to maximise code coverage is to use multiple fuzzing tools. 
Each fuzzer performs mutations in a different way, so they can be run together to cover different parts of the search space in parallel. 
For example, using a combination of a mutative and generative fuzzer can help to generate diverse test cases while also ensuring valid inputs.

### Telemetry as heuristics
If the code structure is known (i.e., in a white-box setting), telemetry about code coverage can help constrain the applied mutations. 
For example, for the `if` statement in the following code snippet, a heuristic based on ***branch coverage*** requires 3 test cases to fully cover it, while one based on ***statement coverage*** requires 2 test cases. 
Using branch coverage ensures that all three branches are tested at least once. 
Such heuristics can be used to select only those mutations that increase code coverage.

```java
public String func(int a, int b){
    a = a + b;
    b = a - b;
    String str = "No";
    if (a > 2)
        str = "Yes!";
    else if (b < 100)
        str = "Maybe!";
    return str;
}
```

### Symbolic execution
We can specify the potential values of variables that allow the program to reach a desired path, using so-called **symbolic variables**. 
We assign symbolic values to these variables rather than explicitly enumerating each possible value.

We can then construct the formula of a **path predicate** that answers this question: 
_Given the path constraints, is there any input that satisfies the path predicate?_. 
We then only fuzz the values that satisfy these constraints. 
A popular tool for symbolic execution is _Z3_. 
It is a combinatorial solver that, when given path constraints, can find all combinations of values that satisfy the constraints. 
The output of _Z3_ can be given as an input to a generative or mutative fuzzer to optimally test various code paths of the SUT.

The path predicate for the `else if` branch in the previous code snippet will be: $$((N+M \leq 2) \& (N < 100))$$. The procedure to derive it is as follows:

1. `a` and  `b` are converted into symbolic variables, such that their values are: $$a=N$$ and $$b=M$$.

1. The assignment statements change the values of `a` and `b` into $$a = N+M$$ and $$b = (N+M) - M = N$$.

1. The path constraint for the `if` branch is $$(N+M > 2)$$, so the constraint for the other branches will be its inverse: $$(N+M \leq 2)$$.

1. The path constraint for the `else if` branch is $$(N < 100)$$.

1. Hence, the final path predicate for the `else if` branch is the combination of the two: $$(N+M \leq 2) \& (N < 100)$$


Note that it is not always possible to determine the potential values of a variable because of the *halting problem* — answering whether a loop terminates with certainty is an undecidable problem. So, for a code snippet given below, Symbolic execution may give an imprecise answer.

```java
public void func(int a, boolean b){
    a = 2;
    while (b == true) {
        // some logic
    }
    a = 100;
}
```

{% hint style='tip' %}
For interested readers, we recommend the "fuzzing book": [https://www.fuzzingbook.org](https://www.fuzzingbook.org)!
{% endhint %}

## References

* Fuzzing for bug hunting. https://www.welcometothejungle.com/en/articles/btc-fuzzing-bugs
