# Web testing

Web applications are ubiquitous nowadays: whether you check your e-mail, file your tax return or play a simple online game, chances are high that you are using a web application.
They are all client-server applications, where the server is located somewhere on the Internet, and the client runs in your web browser. 
Testing such web applications is called *web testing*.

<!-- FM: the examples above may not work very well for today's students. They are all used to smartphone apps. Should we have a separate chapter on app testing? ... -->

A simplified architecture diagram of a web application may look as follows:

![Client-server communication in a web application](img/web-testing/webapp.svg)

What makes web testing different from what we have seen so far? 
How can you apply the principles you have learned so far to testing web applications? 
In this chapter, we will answer these questions using concrete examples.

## Characteristics of web applications
We will now take a look at some characteristics of web applications and how they influence our testing process.

* **The front end is usually written in JavaScript.**
JavaScript is still the de facto programming language for applications that run in a browser.
(This may change in the future now that WebAssembly is supported by all major browsers, but WebAssembly has not gained much traction yet.)
This means that you either need to write the front end in JavaScript, or use a different language like TypeScript and "transpile" it into JavaScript before having your code executed by a browser.
Even though you will be able to apply many of the testing principles you have probably applied in a Java context, you will now also have to get acquainted with **JavaScript unit testing frameworks**.
The **programming paradigms** may be different, so principles like "inversion of control" may be implemented differently in a web programming context.
Also, you will have to pay special attention to the structure of your code.
It is very easy to mix JavaScript with HTML in such a way that you end up with something that is difficult to test.
Make sure you **design for testability** and apply some kind of modular design, creating small, independent components that are easily tested.
It is helpful to use a JavaScript library or framework in order to achieve such a structure.
If you are dealing with existing code for which there are no unit tests, you will probably have to do a significant amount of refactoring to make the code testable. 
Further on in this chapter, we will discuss some concrete examples of how to design for testability. <!-- and also of unit testing frameworks and the consequences of different programming paradigms? -->

* **The application follows the client-server model.**
Having to separate your application into a client side (front end) and a server side (back end) which communicate with each other over HTTP may be beneficial, because it forces you to think of some kind of interface and can help to reduce coupling.
Also, the fact that the server side can be written in any programming language you like, means that you can stick to your familiar testing ecosystem there.
At the same time, it poses challenges, like possibly having **different programming languages** and corresponding ecosystems on the client and server side.
(Of course, you could write the server side in Node.js if you wanted to use JavaScript on both sides.)
You also have to realise that just testing the front end and back end separately will probably not cut it.
You will want to reflect how a user uses the application by performing **system tests**, which in turn means that you have to have a web server running while executing such a test.
That server needs to be in the right state (especially if it uses a database), and the versions of front and back end need to be compatible.

* **Everyone can access your application.**
Web applications are usually available to everyone who is connected to the Internet.
First of all, this means that your audience will probably be very diverse, making **usability testing** and **accessibility testing** testing a priority.
Secondly, the number of users of your application may become very high at any given point in time, so **load testing** is a wise thing to do.
Finally, not all of those users may be people who you had expected to be using your application, and they may have malicious intent.
Therefore **security testing** is of utmost importance (see the corresponding chapter).

## TODO

javascript (or transpiled, or WebAssembly) -> different test frameworks, different programming paradigms; still need to do the same things: write unit tests, design for testability (separate logic from DOM manipulation). The language may not be helpful in designing for testability (JS mixed with HTML, etc.); make your life easier by using some library or framework (if you are starting from scratch) (?).

available to everyone, worldwide (large number of users; unexpected 'users') -> usability, accessibility, load, security

client-server; different ecosystems/languages; server online for system test; do an actual system (end-to-end) test, because that reflects what the user does; server side may be straightforward (just do everything you learned so far)

much focus on UI (interactive, responsive) -> UI component testing (appearance, events), snapshot testing (make sure your UI does not change unexpectedly; https://jestjs.io/docs/en/snapshot-testing); how to do system tests? (simulate user interaction with browser)

asynchronous

should work in different browsers -> cross-browser testing

state (on client and on server) -> see model-based testing (state machines)?

finding elements on (HTML) page -> design for testability (add classes to elements)
(performance)




Testing frameworks: Jasmine, Jest, Mocha, QUnit