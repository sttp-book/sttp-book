# Intelligent testing

Up to this point, _automation_ meant the _automation of the text execution_. Once we manually devised the test cases, we wrote them down as JUnit tests, which were executed by the machine. 

While we studied several techniques to design test cases in a systematic manner, they all required some human effort. Our computers, however, can help a great deal in designing test cases. This is exactly what we are going to discuss in the following chapters.

We are going to work smarter rather than harder, and take a look at different testing techniques that perform software testing in an intelligent way:

- We first discuss **static testing**. In other words, how we can leverage program analysis to detect functional bugs and security vulnerabilities.

- We discuss **mutation testing**. Mutation testing helps us in measuring the fault capability detection of our test suites. After all, a test suite capable of detecting most of the bugs is better than a test suite that is only able to detect a few bugs.

- We discuss **fuzz testing**, where we will test the correctness of a program by automatically providing a (large number of) unexpected inputs. Fuzz testing is a common technique among security testers.

- Finally, in the **search-based testing** chapter, we will see how artificial intelligence or, more specifically, search algorithms, can help us in automatically devise test cases that fully cover the class under test.
