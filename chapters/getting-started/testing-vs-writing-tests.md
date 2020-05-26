# Testing vs Writing Tests

**TL;DR: Testing is different from writing tests. Developers write tests as a a way to give them space to think and confidence for refactoring. Testing focuses on finding bugs. Both should be done.**

We are right now at a point where developers do know that they need to write automated tests. After all, ideas such as Kent Beck's [Extreme Programming](https://en.wikipedia.org/wiki/Extreme_programming) and [Test-Driven Development](https://sttp.site/chapters/pragmatic-testing/tdd.html), Michael Feather's on the [synergy between testing and design](https://medium.com/r/?url=https%3A%2F%2Fvimeo.com%2F15007792), Steve Freeman's and Nat Pryce's on [how to grow an Object-Oriented software guided by tests](https://medium.com/r/?url=https%3A%2F%2Fwww.amazon.de%2FGrowing-Object-Oriented-Software-Addison-Wesley-Signature%2Fdp%2F0321503627), DHH and Ruby on Rails on [making sure that a web framework comes with a testing framework](https://medium.com/r/?url=http%3A%2F%2Fguides.rubyonrails.org%2Ftesting.html), etc, really stuck.

These ideas stuck with me as well. I have been trying to write as many automated tests as I can for the software systems I work since 2007 (I can later tell the history of how traumatic my 2006 project was). In 2012, I thought I had enough experience with the topic, so I decided to [write a book about how I was practicing TDD](https://medium.com/r/?url=https%3A%2F%2Fwww.casadocodigo.com.br%2Fproducts%2Flivro-tdd) (unfortunately, only available in Brazilian Portuguese).
After many years of development and consultancy, I see developers using automated test code as a sort of _support net_. The tests enable them to clearly think about what they want to implement, and support them throughout the innumerous refactorings they apply.

In fact, research has shown quite a few times that doing TDD can improve your class design (see [Janzen](http://digitalcommons.calpoly.edu/cgi/viewcontent.cgi?article=1039&context=csse_fac), [Janzen and Saiedian](http://digitalcommons.calpoly.edu/cgi/viewcontent.cgi?article=1030&context=csse_fac), [George and Williams](https://www.semanticscholar.org/paper/An-Initial-Investigation-of-Test-Driven-Development-George-Williams/66869075d20858a2e9af144b2749a055c6b03177), [Langr](http://eisc.univalle.edu.co/materias/TPS/archivos/articulosPruebas/test_first_design.pdf), [Dogsa and Batic](https://link.springer.com/article/10.1007/s11219-011-9130-2), [Munir](https://pdfs.semanticscholar.org/16d4/2a1eaefb1f404f6da91b12d6c0e710dacb9d.pdf), [Moyaaed and Petersen](https://pdfs.semanticscholar.org/16d4/2a1eaefb1f404f6da91b12d6c0e710dacb9d.pdf), [myself](https://journal-bcs.springeropen.com/articles/10.1186/s13173-015-0034-z), among others). Recently, [Fucci et al.](https://arxiv.org/pdf/1611.05994.pdf) even argued that the important part is to write tests (and it doesn't matter whether it's before or after). This is also the perception of practitioners, where I quote a recent blog post from Feathers: _"That's the magic, and it's why unit testing works also. When you write unit tests, TDD-style or after your development, you scrutinize, you think, and often you prevent problems without even encountering a test failure."_


---

Writing automated tests is therefore something to be recommended.

Pragmatically speaking, I feel that, when using test code as a way to strengthen confidence, good weather tests are often enough. And indeed, there is no need for a lot of knowledge or theories to test good weather, but knowing how to make testing possible (developers talk a lot about designing for testability) and to use the best tools available (and developers indeed master tools like JUnit, Mockito, and Selenium).

What I argue is that, after implementing the production code (with all the support from the good weather test code), the next step should then be about testing it properly. Software testing is about finding many bugs; it is about exploring how your system behaves not only in good weather, but also in exceptional and corner cases.

I recently asked my 1st year CS students on what kinds of mistakes they have done in their programs so far, which have taught them that the testing is important. I got a huge list:

* Programs that don't work when a loop doesn't iterate (the loop condition was never evaluated to true, and the program crashed).
* Programs that don't work because they missed some last iteration (the famous off-by-one error).
* Programs that don't work when inputs are invalid, such as null, or do not conform to what's expected (e.g., a string that represents the name of a file to open containing an extra space at the beginning).
* Programs that don't work because the value is either out of boundaries or in the boundary. For example, if you have an if that expects a number to be greater than 10, what happens if the number is smaller than 10? Or precisely 10?
* Dependencies that are not there, e.g., your program reads from a file, but the file may not be there.
* Among others.

Regardless of your experience, I am sure you also have faced some of these bugs before. _But how often do developers actually explore and write such test cases?_
I feel not that much. (If you are an empirical software engineering researcher, this is a good question to answer).

[Robert Binder in his 2000 book](https://www.amazon.de/Testing-Object-Oriented-Systems-Addison-wesley-Technology/dp/0201809389) (p.45) makes a distinction between "fault-directed" versus" "conformance directed" testing:

* Fault directed: Intent to reveal faults through failures.
* Conformance directed: Intent to demonstrate conformance to required capabilities (e.g. Meets a user story, focus on good weather behavior).

I argue that a strong developer should test from both perspectives. They are complementary.

---

It is clear that, when it comes to software testing, [researchers and practitioners talk about different topics](https://ieeexplore.ieee.org/abstract/document/8048625/). Very good pragmatic books, like [Pragmatic Unit Testing in Java 8 with JUnit](https://pragprog.com/book/utj2/pragmatic-unit-testing-in-java-8-with-junit), have a strong focus on how to do test automation. While they provide good tips on what to test (the chapters on [CORRECT and RIGHT-BICEP](https://media.pragprog.com/titles/utj2/bicep.pdf) in the PragProg book is definitely interesting), they usually don't go beyond it.

On the other hand, software testing books from academia, my favorite being [_Software Testing Analysis_](https://www.amazon.com/Software-Testing-Analysis-Principles-Techniques/dp/0471455938) from Young and Pezzè, have a strong focus on theories and techniques on how to design test cases that explore as much as one can from the program under test. However, with not so many timely examples on how to apply these ideas, which is definitely a requirement for practitioners.

As a developer, if you want to take your testing to the next level, you should definitely get familiar with both perspectives. Some examples (but definitely not a complete list):

* Understand _domain testing_. Exploring the domain of the problem and its boundaries is still the best way to design good test cases.
* Making use of [structural testing](http://laser.cs.umass.edu/courses/cs521-621/papers/ZhuHallMay.pdf) as it was meant to be (and not simply trying to achieve a certain level of code coverage).
* Detecting whether some test suite is able to detect possible bugs. The idea of [mutation testing has being applied at Google](https://research.google.com/pubs/archive/46584.pdf).
* Deriving [models from your production system logs and build models](https://pure.tudelft.nl/portal/en/publications/an-experience-report-on-applying-passive-learning-in-a-largescale-payment-company(b463c54a-d69f-4db4-9fcc-cbeb6e2ddf09).html) that can be analysed by domain experts.
* Automatically generating tests (the famous example is [EvoSuite](https://pdfs.semanticscholar.org/216b/98bb3d9221d5f5d261864975612e4d0faaa6.pdf), which is able to generate tests for Java classes) or to automatically reproduce crashes. I myself worked on [automatically generating tests for SQL queries](https://pure.tudelft.nl/portal/en/publications/searchbased-test-data-generation-for-sql-queries(90a6431f-f78f-4ac3-bf87-c052cd9cd5d4).html).
* Several tools for testing web applications, like automatically exploring the web app looking for crashes as well as [finding crashes in REST APIs](https://github.com/EMResearch/EvoMaster/blob/master/docs/publications/2017_qrs.pdf). More can be found in this [web testing literature review](https://www.sciencedirect.com/science/article/pii/S0164121214000223).
* Property-based testing is also getting to practitioners by means of tools like ScalaCheck and [JQWik](https://jqwik.net).

---

Writing tests is different from testing. They both provide developers with different outcomes. The former gives confidence and support throughout development. The latter makes sure the software will really work in all cases. While they are both important, it's about time for both communities to get aligned:

* Developers to get more familiar with more advanced software testing techniques (which researchers have been providing). They are definitely a good addition to their seatbelts and will help them to better test their softwares.
* Educators to teach both perspectives. My perception is that universities teach testing techniques in an abstract way (developers need to learn how to use the tools!), while practitioners only teach how to use the automated tools (developers need to learn how to properly test!).
* Researchers to better understand how practitioners have been evolving the software testing field from their perspective as well as to better share their results, as developers do not read papers. [Research lingo is for researchers](https://twitter.com/mauricioaniche/status/997498070395949057).

_(An initial version of this text was published in [Medium](https://medium.com/@mauricioaniche/testing-vs-writing-tests-d817bffea6bc))._


