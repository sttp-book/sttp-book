# Test-Driven Development

So far in this book, our approach to testing has been the following: we wrote the production code first, and after that we moved on to writing the tests.
One disadvantage of this approach is that this creates a delay before we have tests, causing us to miss the "design feedback" that our tests can give us.

Test-Driven Development (TDD) proposes the opposite: to write the tests before the production code.

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

* The properties of the tests we write can **indicate certain types of problems in the code**.
This is why Test-Driven Development is sometimes called *Test-Driven Design*. We discussed design for testability in
a previous chapter. You might get information about the quality of your design by looking at the tests during the writing process.
For example, too many tests for just one class can indicate that the class has too many functionalities and that it should be split up into more classes.
If we need too many mocks inside of the tests, the class might be too coupled, i.e. it needs too many other classes to function.
If it is very complex to set everything up for the test, we may have to think about the pre-conditions that the class uses.
Maybe there are too many pre-conditions or maybe some are not necessary.
All of this can be observed in the tests, while doing TDD.

It is good to think about design early on as it is easier to change the design of a class at the beginning of the development, rather than a few months later.

## TDD from the trenches

In the following sections, 
we discuss some insights into TDD, directly from developers we have talked to.

### TDD does not lead to better design on its own

Participants stated that the practice of TDD did not change their class design during the experiment. The main justification was that their experience and previous knowledge regarding object-orientation and design principles guided them during class design. They also stated that a developer with no knowledge in object-oriented design would not create a good class design just by practising TDD or writing unit tests.

The participants gave two good examples reinforcing the point. One of them said that he made use of a design pattern he learned a few days before. Another participant mentioned that his studies on SOLID principles helped him during the exercises.

The only participant who had never practised TDD before stated that he did not feel any improvement in the class design when practising the technique. Curiously, this participant said that he considered TDD a design technique. It somehow indicates that the popularity of the effects of TDD in class design is high. This opinion was slightly different from that of experienced participants, who stated that TDD was not only about design, but also about testing.

Even though TDD might not *directly* lead to good class design, all participants said that TDD has positive effects on class design. Many of them mentioned the difficulty of trying to stop using TDD or thinking about tests, which can be a reason for not seeing significant differences in terms of design quality in code produced with and without TDD.

"When you are about to implement something, you end up thinking about the tests that you’ll do. It is hard to stop thinking about tests while writing code!. As soon as you get used to it, you just don’t know any other way to write code..."

According to the participants, TDD can help during class design process, but in order to succeed, the developer should have experience in software development. In fact, most participants stated that their class designs were based on their experiences and past learning processes. In their opinion, the best option was to combine TDD with experience.

### Baby steps and simplicity

TDD encourages developers to work in small (baby) steps: first define the smallest possible functionality, then write the simplest code that makes the test green, and carry out one refactoring at a time.

In the interviews, participants commented about this. One of them mentioned that, when not writing tests, a developer thinks about the whole class design and creates a more complex structure than needed.

One of the participants said using baby steps helps him to think better about his class design:

"Because we start to think of the small and not the whole. When I do TDD, I write a simple rule (...), and then I write the method. If the test passes, it passes! As you go step by step, the architecture gets nice. (...) I used to think about the whole (...). I think our brains work better when you think small. If you think big, it is clear, at least for me, that you will end up forgetting something."

### Refactoring confidence

Participants stated that, during the process of class design, they change their minds constantly. This is because there is only limited knowledge about the problem, and about how the class should be built. This was the point that was most often brought up by the participants. According to them, an intrinsic advantage of TDD is the generated test suite. It allows developers to change their minds and refactor the whole class design safely. Confidence, according to them, is an important factor when changing class design or implementation.

"It gives me the opportunity to learn along the way and make things differently. (…). The test gives you confidence."

A participant mentioned an experience when TDD had a significant impact. According to him, he changed his mind about the class design many times and trusted the test suite to guarantee the expected behaviour.

### A safe space to think

One of the participants said tests are like draft paper, on which they can try different approaches and change their minds about it frequently. According to them, when starting with the tests, developers are, for the first time, using their own class. It makes developers look for a better and clearer way to invoke the class behaviour, and facilitate its use:

"Tests help you on that. They are a draft for you to try to model it the best way you can. If you had to model the class only once, it is like if you have only one chance. Or if you make it wrong, fixing it would take a lot of work. The idea of you having tests and thinking about them, it is like if you have an empty draft sheet, on which you can put and remove stuff because that stuff doesn’t even exist."

We asked about their reasons for not thinking on the class design even when they were not practising TDD or writing tests. They replied that when a developer does not practise TDD, they get too focused on the code they are writing, and therefore end up not thinking about the class design they were creating. They believe tests make them think about how the class being created will interact with the other classes and about how easy it is to use.

One of the participants was even more precise in his statement. According to him, developers who do not practise TDD end up not using OOP well because they do not think about the design of the class they are building. TDD forces developers to slow down, allowing them to think better about what they are doing.

### Rapid feedback

Participants also commented that one difference they perceived when they practised TDD was the constant feedback. In traditional testing, the time between the production code writing and test code writing is too long. When practising TDD, developers are forced to write the test first, and so receive feedback from a test sooner.

One participant commented that, from the tests, developers are able to review the code they are designing. As the tests are done constantly, developers think continuously about the code and its quality:

*"When you write the test, you soon perceive what you don’t like in it (...). You don’t perceive that until you start using tests."*

Reducing the time between the code writing and test writing also helps developers to create code that solves the given problem effectively. According to the participants, in traditional testing, developers write too much code before actually knowing if it works.

### The search for testability

Maybe the main reason that the practice of TDD helps developers in their class design is the constant search for testability. When we start by writing the tests, the production code is testable by necessity.

When it is not easy to test a specific piece of code, developers understand it as a class design smell. When this happens, developers usually try to refactor the code to make it easier to test. One participant applies the rule that if it is hard to test, the code needs improvement.

Feathers [7] raised this point: the harder it is to write the test, the higher the likelihood that there is a problem in the class design. According to him, there is a strong correlation between a highly testable class and a good class design. If developers are looking for testability, they end up creating good class design. At the same time, if they are looking for good class design, they end up writing testable code.

During the interviews, many participants also mentioned patterns that made (and make) them think about possible design problems in the classes they build. As an example, they told us that when they feel the need to write many different unit tests for a single method, this may be a sign of a non-cohesive method. They also said that when a developer feels the need to write a big scenario for a single class or method, it is possible to infer that this need emerges in classes dealing with too many objects or containing too many responsibilities, and thus, it is not cohesive. They also mentioned how they detect coupling issues. According to them, the abusive use of mocking objects indicates that the class under testing has coupling issues.

### What did we learn from it?

The first interesting myth contested by the participants was the idea that the practice of TDD would lead developers towards a better design by itself. As they explained, the previous experience with and knowledge of good design have significant impact. At the same time, TDD helps developers by giving quick and constant feedback by means of the unit tests that they are writing. As they also mentioned, the search for testability also makes them rethink the class design many times during the day — if a class cannot be tested easily, then they refactor it.

We agree with the rationale. In fact, when compared with test-last approaches, developers do not have the constant feedback or the need to write testable code. They will have the necessary feedback only at the end, when all the production code has already been written. Then it may be too late (or expensive) to do any significant refactoring in the class design.

![TDD feedback](img/tdd/tdd.svg)

We also agree with the comments about confidence when refactoring. As TDD forces developers to write unit tests frequently, these tests end up working as a safety net. Any broken change in the code is identified quickly. This safety net makes developers more confident to try and experiment with new design changes — after all, if the changes break anything, tests will warn developers about it. That is why they also believe the tests are a safe space to think.

Therefore, we believe that it is not the practice by itself that helps developers to improve their class design. Rather it is the consequences of constantly writing unit tests, making classes testable, and refactoring the code, that drives developers towards a better design.

In conclusion, developers believe that the practice of test-driven development helps them to improve their class design, as the constant need to write a unit test for each part of the software forces them to create testable classes. The feedback — is your code easy to be tested or not? — makes them think and rethink about the class and improve it. Also, as the number of tests grow, they act as a safety net, allowing developers to refactor freely, and also try and experiment different approaches to that code. Based on that, we suggest that developers experiment with the practice of test-driven development, as its effects appear positive for software developers.

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
