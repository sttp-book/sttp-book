# Pragmatic testing

While software testing is an essential skill for every developer and often leads to a much higher quality end product, some systems are written in such ways that simple testing becomes virtually impossible which often leads to testing being neglected.

The idea behind pragmatic testing is realizing that software is highly variable and different systems (even different parts of systems) need different techniques and resources to be tested and that software more often then not needs to be written with "testability" in mind because it might end up almost untestable if not paid attention to.

In this section, we present the various ways you can test your system and, more importantly, try to guide you in determining which parts require the most attention, what alternative ways there are to write and test them and how to divide your testing resources among them. We also talk about the maintenance of your test suite as time passes and the software grows to larger and larger proportion.

We will discuss:

- **The Testing pyramid**: The various levels of testing and how effort should be distributed amongst them.
- **Mock Objects**: How to use mock (mimic) objects to ease the testability of some components.
- **Design for Testability**: How to design and build a software system in a way that increases its testability.
- **Test-Driven Development**: The idea of writing test code before the production code in order to make use of the design feedback they can provide.
- **Test Code Quality and Engineering**: Best practices in test code engineering, guiding principles for developers, well-known test smells, tips on making test more readable, and flaky tests.
