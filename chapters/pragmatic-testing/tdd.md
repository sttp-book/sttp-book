# Test-Driven Development

So far in this book, our approach to testing has been the following: we wrote the production code first, and after that we moved on to writing the tests.
One disadvantage of this approach is that this creates a delay before we have tests, causing us to miss the "design feedback" that our tests can give us.

Test-Driven Development (TDD) proposes the opposite: to write the tests before the production code.

In this chapter, we will:
1. Introduce the reader to the TDD cycle.
1. Discuss the advantages of TDD.
1. Discuss whether developers should adhere 100% to TDD.

## The TDD cycle

The TDD cycle is illustrated in the diagram below:

![Test Driven Development Cycle](img/tdd/tdd_cycle.svg)

With a given requirement, we start by thinking of test cases. 
Often the simplest test case we can think of will take us a step further in implementing this requirement.
We try to answer the question: what is the next input we want our code to be able to handle, and what output should it give?
We then write the corresponding test.
The test will probably fail, as we have not written the production code yet.
With this failing test, we write the production code that makes the test pass.
In doing this, the aim is to write the simplest production code that makes the test pass.
Once this is achieved, it is time to refactor the code we have written. This is because, when focusing on making the test
pass, we might have ignored the quality of our production code.
We then repeat the process from the beginning. We stop once we are satisfied with our implementation and
the requirement is met.

## Advantages of TDD

TDD has several advantages:

* **By creating the test first, we also look at the requirements first.**
This makes us write the code for the specific problem that it is supposed to solve.
In turn, this prevents us from writing unnecessary code.

* **We can control our pace of writing production code.**
Once we have a failing test, our goal is clear: to make the test pass.
With the test that we create, we can control the pace we follow when writing the production code.
If we are confident about how to solve the problem, we can make a big step by creating a complicated test.
However, if we are not sure how to tackle the problem, we can break it into smaller parts and start by creating tests for these and then proceed with the other parts.

* **The tests are derived from the requirements.**
Therefore, we know that, when the tests pass, the code does what it is supposed to do.
If we write tests using code that has already been written, the tests might pass but the code might not be doing the right thing.
The tests also show us how easy it is to use the class we just made.
We are using the class directly in the tests so we know immediately when we can improve something.

* **Testable code from the beginning.**
Creating the tests first makes us think about the way to test the classes before implementing them. After all, we need testable classes from the beginning, if we start from the test code. Because TDD forces developers to change how they design their code, it improves the testability, and more specifically also the controllability of our code. We already talked about the importance of this aspect when creating automated tests. Controllable code will be easier to test, resulting in improved code quality. 

* **Quick feedback on the code that we are writing.**
Instead of writing a lot of code and then a lot of tests, i.e. getting a lot of feedback at once after a long period of time, we create a test and then write a small piece of code for that test.
It becomes easier to identify new problems as they arise, because they relate to the small amount of code that was added last.
In addition, if we want to change something, it will be easier to do on a relatively small amount of code.

* **Baby steps**: TDD encourages developers to work in small (baby) steps: first define the smallest possible functionality, then write the simplest code that makes the test green, and carry out one refactoring at a time.

* **Feedback on design**. The properties of the tests we write can indicate certain types of problems in the code.
This is why Test-Driven Development is sometimes called *Test-Driven Design*. We discussed design for testability in
a previous chapter. You might get information about the quality of your design by looking at the tests during the writing process.
For example, too many tests for just one class can indicate that the class has too many functionalities and that it should be split up into more classes.
If we need too many mocks inside of the tests, the class might be too coupled, i.e. it needs too many other classes to function.
If it is very complex to set everything up for the test, we may have to think about the pre-conditions that the class uses.
Maybe there are too many pre-conditions or maybe some are not necessary.
All of this can be observed in the tests, while doing TDD.
It is good to think about design early on as it is easier to change the design of a class at the beginning of the development, rather than a few months later.


## Should I do TDD 100% of the time?

Given all these advantages, should we use TDD 100% of time?
There is, of course, no universal answer. While some research shows the advantages of TDD, others throw more doubt on it.

Our pragmatic suggestion is:

* You should use TDD when you do not know how to design and/or architect a part of the system. TDD might help you to explore
different design decisions.

* You should use TDD when you are dealing with a complex problem, a problem in which you lack experience. If you are facing a
new challenging implementation, TDD might help you in taking a step back and learn on the way. The use of baby steps might
help you to start slowly, to learn more about the requirement, and to get up to speed once you are more familiar with the problem.

* You should not use TDD when you are familiar with the problem, or the design decisions are clear in your mind.
If there is "nothing to be learned or explored", TDD might not really afford any significant benefit. However, we note that, even if you
are not doing TDD, you should write tests in a timely manner. Do not leave it for the end of the day or the end of a sprint.
Write them together with the production code, so that the growing automated test suite will give you more and more confidence 
about the code.

## TDD in practice

James Shore created a series of 200 impressive videos where he uses TDD to build an entire "real-world" project from scratch. You can see it in his Youtube playlist, _Let's Play: Test-Driven Development_: https://www.youtube.com/playlist?list=PL0CCC6BD6AFF097B1. While he created these videos in 2012, they are still relevant and highly recommended.

{% hint style='tip' %}
We recommend readers to watch at least the first 3-5 episodes to get a sense of what TDD is about. 
{% endhint %}

## Exercises


**Exercise 1.**
We have the following skeleton for a diagram illustrating the Test Driven Development cycle.
What words/sentences should be at the numbers?

![Test Driven Development exercise skeleton](img/tdd/exercises/tdd_skeleton.svg)

(Try to answer the question without scrolling up!)





**Exercise 2.**
Remember the `RomanNumeral` problem?


> **The Roman Numeral problem**
>
> It is our goal to implement a program that receives a string 
> as a parameter containing a roman number and then 
> converts it to an integer.
>
> In roman numeral, letters represent values:
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
> For example we make 6 by using $$5 + 1 = 6$$ and 
> have the roman number "VI".
> Example: 7 is "VII", 11 is "XI" and 101 is "CI".
> Some numbers need to make use of a subtractive notation 
> to be represented.
> For example we make 40 not by "XXXX", but 
> instead we use $$50 - 10 = 40$$ and have the roman number "XL".
> Other examples: 9 is "XI", 40 is "XL", 14 is "XIV".
> 
> The letters should be ordered from the highest to the lowest value.
> The values of each individual letter is added together.
> Unless the subtractive notation is used in which a letter 
> with a lower value is placed in front of a letter with a higher value.
>
> Combining both these principles we could give our 
> method "MDCCCXLII" and it should return 1842.

Implement this program. Practise TDD!


**Exercise 3.**
Which of the following **is the least important** reason to do Test-Driven Development?

1. As a consequence of the practice of TDD, software systems get tested completely.
2. TDD practitioners use the feedback from the test code as a design hint.
3. The practice of TDD enables developers to have steady, incremental progress throughout the development of a feature.
4. The use of mock objects helps developers to understand the relationships between objects.



**Exercise 4.**
TDD has become a really popular practice among developers. According to them, TDD has several benefits. Which of the following statements 
**is not** considered a benefit which results from the practice of TDD?

*Note:* We are looking from the perspective of developers, which may not always match the results of empirical research.

1. Better team integration. Writing tests is a social activity and makes the team more aware of their code quality. 

2. Baby steps. Developers can take smaller steps whenever they feel this is necessary.

3. Refactoring. The cycle prompts developers to improve their code constantly.

4. Design for testability. Developers are "forced" to write testable code from the beginning.




## References

* Beck, K. (2003). Test-driven development: by example. Addison-Wesley Professional.

* Martin R (2006) Agile principles, patterns, and practices in C#. 1st edition. Prentice Hall, Upper Saddle River.

* Steve Freeman, Nat Pryce (2009) Growing object-oriented software, Guided by Tests. 1st edition. Addison-Wesley Professional, Boston, USA.

* Astels D (2003) Test-driven development: a practical guide. 2nd edition. Prentice Hall.

* Janzen D, Saiedian H (2005) Test-driven development concepts, taxonomy, and future direction. Computer 38(9): 43–50. doi:10.1109/MC.2005.314.

* Beck K (2001) Aim, fire. IEEE Softw 18: 87–89. doi:10.1109/52.951502.

* Feathers M (2007) The deep synergy between testability and good design. https://web.archive.org/web/20071012000838/http://michaelfeathers.typepad.com/michael_feathers_blog/2007/09/the-deep-synerg.html.
