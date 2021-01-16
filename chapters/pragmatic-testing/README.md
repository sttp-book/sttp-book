# Section 3: Pragmatic testing

While software testing is an essential skill for every developer and often leads to a much higher quality end product, some systems are written in such ways that simple testing becomes virtually impossible. More often than not, the difficulties in testing a system often leads to testing being neglected.

The idea behind this section on pragmatic testing is realizing that software is highly variable, and that different components need different techniques and/or resources to be tested. 

In this section, we present the various ways you can test your system and, more importantly, try to guide you in determining which parts require the most attention, what alternative ways there are to write and test them, and how to divide your testing resources among them. We also talk about the maintenance of your test suite as time passes and the software grows to larger and larger proportions.

We will discuss:

- **3.1 The Testing pyramid**: The various levels of testing and how much effort should be distributed amongst them.
- **3.2 Mock Objects**: How to use mock (mimic) objects to ease the testability of some components.
- **3.3 Design for Testability**: How to design and build a software system in a way that increases its testability.
- **3.4 Test-Driven Development**: The idea of writing test code before the production code in order to make use of the design feedback they can provide.
- **3.5 Test Code Quality and Engineering**: Best practices in test code engineering, guiding principles for developers, well-known test smells, tips on making test more readable, and flaky tests.
