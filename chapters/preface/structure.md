# Structure of the book

Testing software is a multifaceted activity, which requires developers to understand and apply a broad range of different techniques. This book is organised as follows:

* **Section 1: Getting started with software testing**
Why is software testing such a challenging task? Why can't we find all the bugs in a software system? How expensive and/or feasible would it be if a developer decides to test all the possible scenarios in a software system? In this section, we explain to the reader the so-called _principles of software testing_. Moreover, we introduce the reader to the idea of automating the test cases with the help of JUnit, the standard Java testing framework. JUnit (and later other tools such as Mockito and Selenium) are used throughout this book. Finally, we convince the reader that, to achieve high-quality software systems, developers have to rely on both testing and design techniques (in what we call the _developer testing workflow_).

* **Section 2: Testing techniques**
The main goal of software testing is to reveal bugs in the system under test. This section is entirely dedicated to techniques that aim at detecting those bugs as efficiently as possible. The chapters will cover specification-based techniques (i.e., deriving tests based on textual requirements of the system), structural techniques (i.e., deriving tests based on the structure of the source code), boundary testing (i.e., testing whether the system behaves correctly when inputs are near the boundaries of the input domain), model-based testing (i.e., deriving tests from more formal documentation, such as state machines or decision tables), and design-by-contracts and property-based testing (i.e., devising explicit contracts to methods and classes and ensuring that they behave correctly when these contracts are met).

* **Section 3: Pragmatic software testing**
Testing becomes more complicated once the software systems under test get more complicated. And, on top of that, given how fast companies ship their software today, software testing is now a tool in the developers' belt. In this section, we cover techniques that help developers in writing their tests more effectively. Moreover, we discuss what design and architectural decisions developers can take to ease the testing process (the so-called design for testability). Finally, given test cases are implemented as code, we discuss best practices on how to write and maintain them.

* **Section 4: Testing in context**
Context is king. In this chapter, we discuss some techniques and tools to test software systems in specific contexts, such as web applications and mobile applications. 

* **Section 5: Non-functional testing**
Non-functional requirements are extremely important in some software systems. In this section, we cover different testing techniques to ensure that the security and performance requirements of the systems are met.

* **Section 6: Intelligent testing**
Can machines also devise test cases? Up to this section, test cases were mostly devised by humans (and only later written as test code, so that the machine could run them). In this section, we discuss state-of-the-art ideas on how machines can also help developers in exploring systems and look out for crashes. We cover techniques such as mutation testing, fuzzing testing, and search-based software testing.

