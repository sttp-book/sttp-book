# 2020 Midterm preparation

Welcome to CSE 1110 midterm.

You are free to:

* Consult your personal notes, labwork answers, and source code you have written throughout the course
* Visit our lecture notes in https://sttp.site
* Use Google (or any search engine) to search for documentation of the frameworks we use or classes under test.
* Use WebLab's code editor or IntelliJ or any other IDE to write your code. We even provide you [an IntelliJ project to get started](https://sttp.site/chapters/appendix/resources/2020-midterm-skeleton.zip). However, your final answer must be delivered in WebLab. Make sure your tests are passing and everything compiles in WebLab.
* Use any tool to draw CFGs, state machines, and transition trees. You are also allowed to draw it manually and upload a picture. Just make sure it’s legible enough.

* [Endterm skeleton](https://sttp.site/chapters/appendix/resources/2020-endterm-skeleton.zip).

You must not:

* Ask questions to any other person. All the knowledge should come from you.
* Ask any other person to do the exam for you.
* Use Google (or any search engine) to look for the answers of the exercises. More specifically, you must not look for or copy existing test suites of the program you will test.

You have 3 hours to finish the exam.

We wish you good luck!


## Picking a program to test

We will now randomly select a program for you to test. This will be the program you should use for the next exercises. 

An overall overview of what you will do with it:

1. Devise test cases using domain testing (i.e., specification testing, equivalence partitioning, and boundary analysis). 
2. Write JUnit test cases based on the tests you devised.
3. Draw a Control-Flow Graph and use structural testing to complement your previously designed test suite.
4. Reflect on pre-, post-, and class invariants of the method under test.

You are free to:

1. Use Google to understand more about how the method is being used in the wild.

You are not free to:

1. Look at possible existing test code that this method has. The answers should come completely from you.

Tip: 

1. Copy your program under test somewhere to your computer. This way, you won't need to keep going back to the exercise to see it!
1. Pay attention to the name of the package, class, and method (including its parameters) you should test.

Good luck!



--- 

Method under test `deleteWhitespace(final String str)` from class `org.apache.commons.lang3.StringUtils`.

Source code of the entire class: https://github.com/apache/commons-lang/tree/e0b474c0d015f89a52c4cf8866fa157dd89e7d1c/src/main/java/org/apache/commons/lang3/StringUtils.java#L1564

Snippet of the method you should test:

```java
/**
 * <p>Deletes all whitespaces from a String as defined by
 * {@link Character#isWhitespace(char)}.</p>
 *
 *
 * @param str  the String to delete whitespace from, may be null
 * @return the String without whitespaces, {@code null} if null String input
 */
public static String deleteWhitespace(final String str) {
    if (isEmpty(str)) {
        return str;
    }
    final int sz = str.length();
    final char[] chs = new char[sz];
    int count = 0;
    for (int i = 0; i < sz; i++) {
        if (!Character.isWhitespace(str.charAt(i))) {
            chs[count++] = str.charAt(i);
        }
    }
    if (count == sz) {
        return str;
    }
    return new String(chs, 0, count);
}

``` 

---

## Exercise: Domain testing

You should now devise test cases for the program in hands:

* Make use of domain testing/specification-based techniques to derive partitions
* Make use of boundary testing techniques to explore the boundaries

Your answer should be as complete/clear as possible. It should contain:

- A domain analysis of the requirements. Make it explicit what input and output variables you see. Do they have some dependency relationship you had to take into account?
- How you partitioned the input domain. List each partition, and explain why you think this partition is worth a test. If you see independent partitions per input variable, list them separately.
- List any boundaries you see among the partitions. 
- Think of a strategy to derive the test cases. Are you testing all the combinations? Or did you apply any heuristic to reduce the number of test cases?
- List the final test cases. Each test case should have a number, input values, and expected output. Example: `T1 = (10, 20) -> true`, to indicate that test 1 uses 10 and 20 as inputs and the expected output is true.

Note that the method under test comes from a real-world open source system and has been already battle-tested. It does not contain bugs (at least, none that we know of). Nevertheless, your task is to devise the best test suite possible to ensure that future maintenance will not introduce a bug in this implementation.

Some example structure to help you in answering this exercise:

```
## Variables:

* a, explain
* b, explain

## Dependencies:

I see some dependency, explain ...

## Equivalent partitioning and boundary analysis:

* variable A:
  * partition 1
  * partition 2

* variable B:
  * partition 3
  * partition 4

* (a, b)
  * partition 5
  * partition 6

* Boundaries
  * boundary 1: explanation
  * boundary 2: explanation

## Strategy:

* Combine everything ...
* Total number of tests = 3

## Test cases:

* T1 = ...
* T2 = ...
* T3 = ...
```

Tips: 

* Copy the final test cases you devised somewhere to your machine, because you will write JUnit tests for them later in this exam.
* If you want to build a Markdown table, you might use this website to help you: https://www.tablesgenerator.com/markdown_tables


## Exercise: Control-flow graph

Now that you are done with domain testing, it is time to do some _structural testing_ to complement the existing test cases. Your first task is to **draw the control-flow graph (CFG)** of the method. 

You are free to:

- Use any program to draw the CFG.
- Draw it manually and take a picture.

Upload your answer here. You have to stick to common image formats (.jpg, .png, .pdf). Images should not be larger than 3 MB.


## Exercise: Structural testing

Does your test suite achieve 100% **branch + condition coverage (i.e., full condition coverage)**?

If it does not, what is its current branch + condition coverage? What test are you missing? Now, it is a good time to go back to the previous exercises and identify which partitions and/or boundaries you have missed! Feel free to update your answer there too!

If you had achieved 100% branch + condition coverage even before performing structural testing, why do you think structural testing didn't add value to your testing process?


## Exercise: JUnit code

Automate the test cases you devised. Write them as JUnit5 test cases.

The class is already included in your environment (both in WebLab and in the IntelliJ package we have provided you before). Simply import the class and use the method.

If you missed the link to the IntelliJ project, [download it from here now](resources/2020-midterm-skeleton.zip).

You should:

* Write your test code in the _Test_ tab.
* Link your test code with the test cases you created in the previous exercise. Adding comments (e.g., `// test case 1`) is a good solution.
* Write beautiful test code. We will judge your answer on readability. Make sure you have no duplicated code in your tests. 

You are free to:

* Code your tests in the IDE, and solely paste it here.

Tips:

* **Pay attention to the name of class and method you should test, including the package it comes from! There might be methods with similar names in the environment. Make sure you test the right one!**

* Make sure your code compiles before submitting.

* Do not change the name of the test class you see in the tab. WebLab won't find your class, if you rename it.

## Exercise: Contracts

Based on what you learned from the requirements, implementation, and testing the program, discuss:

1. Pre-conditions
2. Post-conditions
3. Class invariants

Your answer should also offer an example of the `assert` instruction you would write it in the implementation.

If you do not see a pre-condition, post-condition, or class invariant, explicitly say so (and explain why not).

## Picking a state machine

We will now randomly give you a description of a state machine. In the following exercises, you will:

* Draw the state machine
* Derive a transition tree
* Explore sneaky paths

---

- The machine begins in state **C**.

- When the machine is at state **A** and event **T2** is invoked, then the machine proceeds to state **B**.

- When the machine is at state **C** and reaction **T2** occurs, then the machine proceeds to state **D**.

- When the machine is at state **C** and operation **T4** is triggered, then the machine enters state **A**.

- When the machine is at state **D** and event **T3** is invoked, then the machine enters state **D**.

- When the machine is in state **D** and reaction **T1** is invoked, then the machine enters state **A**.


---


## Exercise: Drawing a state machine

Draw the state machine to the requirement you received.

You are free to:
- Use any program to draw the state machine.
- Draw it manually and take a picture.

Upload your answer here. You have to stick to common image formats (.jpg, .png, .pdf). Images should not be larger than 3 MB.
 
## Exercise: Transition tree

It is time to test the state machine. Given the state machine you just devised, build a **transition tree**.

You are free to:
- Use any program to draw the Transition tree.
- Draw it manually and take a picture.

Upload your answer here. You have to stick to common image formats (.jpg, .png, .pdf). Images should not be larger than 3 MB.

## Exercise: Sneaky paths

As a tester, you might feel the need of testing sneaky paths (or at least, to think about them).

What sneaky paths do you see in the state machine? List them all.

You may use the following notation:

```
There are X sneaky paths:

* for state A: T1, Tx, ...
* for state B: T1, Tx, ...
* for state ...
...
```

