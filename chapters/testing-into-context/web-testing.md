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
We will now take a look at some characteristics of web applications and how they influence our testing process. These consequences for testing are then discussed in more detail after this section.

### The front end is usually written in JavaScript
JavaScript is still the de facto programming language for applications that run in a browser.
(This may change in the future now that WebAssembly is supported by all major browsers, but WebAssembly has not gained much traction yet.)
This means that you either need to write the front end in JavaScript, or use a different language like TypeScript and "transpile" it into JavaScript before having your code executed by a browser.
Even though you will be able to apply many of the testing principles you have probably applied in a Java context, you will now also have to get acquainted with **JavaScript unit testing frameworks**.

The **programming paradigms** may be different, so principles like "inversion of control" may be implemented differently in a JavaScript context.

Also, you will have to pay special attention to the structure of your code.
It is very easy to mix JavaScript with HTML in such a way that you end up with something that is difficult to test.
Make sure you **design for testability** and apply some kind of modular design, creating small, independent components that are easily tested.
When starting a new project from scratch, is helpful to use a JavaScript library or framework (like Vue.js, React or Angular) in order to achieve such a structure.
If you are dealing with existing code for which there are no unit tests, you will probably have to do a significant amount of refactoring to make the code testable. 

### The application follows the client-server model
Having to separate your application into a client side (front end) and a server side (back end) which communicate with each other over HTTP may be beneficial, because it forces you to think of some kind of interface and can help to reduce coupling.
Also, the fact that the server side can be written in any programming language you like, means that you can stick to your familiar testing ecosystem there.
At the same time, it poses challenges, like possibly having **different programming languages** and corresponding ecosystems on the client and server side.
(Of course, you could write the server side in Node.js if you wanted to use JavaScript on both sides.)
You also have to realise that just testing the front and back end separately will probably not cut it.
You will want to reflect how a user uses the application by performing **system tests**, which in turn means that you have to have a web server running while executing such a test.
That server needs to be in the right state (especially if it uses a database), and the versions of front and back end need to be compatible.

### Everyone can access your application
Web applications are usually available to everyone who is connected to the Internet.
First of all, this means that your audience will probably be very diverse: the users will have very different backgrounds. This makes **usability testing** and **accessibility testing** testing a priority.
Secondly, the number of users of your application may become very high at any given point in time, so **load testing** is a wise thing to do.
Finally, some of those users may have malicious intent.
Therefore **security testing** is of utmost importance (and is discussed in the separate Security Testing chapter).

### The front end runs in a browser
Different users use different versions of different browsers.
**Cross-browser testing** helps to ensure that your application will work in the browsers you support.

In addition, browsers show web pages differently based on the window size.
Web designers use something called **responsive web design** to make sure the application will look good in browsers with different sizes, running on different devices.
This is of course also something you should test.

Another factor to consider is the fact that HTML is used as the markup language for web pages.
Even your HTML should be **designed for testability**, so that you can select elements easily (for instance by adding CSS classes to elements), and so that you can test different parts of the user interface (UI) independently. 
Speaking of user interfaces: **UI component testing** can be considered  a special case of unit testing: here your "unit" is one part of the Document Object Model (DOM), which you feed with certain inputs, possibly triggering some events (like "click"), after which you check whether the new DOM state is equal to what you expected. 
Even more specifically, **snapshot testing** can help you to make sure your UI does not change unexpectedly.

Finally, when you want to perform **system tests** automatically, you will have to somehow control the browser and make it simulate user interaction. 
Two well-known tools for this are Selenium WebDriver and Cypress.

### Many web applications are asynchronous
Especially in a single-page application (SPA), most of the requests to the server are done in an **asynchronous** manner: while the browser is waiting for results from the server, the user can continue to use the application (i.e., they do not have to wait for the results). 
When writing unit tests, you have to account for this by "awaiting" the results from the (mocked) server call before you can check whether the output of your unit matches what you expected. 
When performing system tests, you may have to wait for a certain element to appear on the screen, or even to wait for a certain amount of time (like 1 second) before checking the output. 
This can easily lead to *flaky tests* (as discussed in the chapter on Test Code Quality). 
You either have to write custom code to make your tests more robust, or use a tool like Cypress, which has retry-and-timeout logic built-in.

### TODO
* Something about state (of client and server)? Relate to model-based testing?
* More info about testing the server side? Maybe testing the server by calling it directly with HTTP? (Which may not add much if you use some framework on the server side which translates HTTP requests into classes that are easily tested using traditional techniques.)
* Something about performance testing?

## JavaScript unit testing
TODO. Mention testing frameworks: Jasmine, Jest, Mocha, QUnit.

## UI component testing
TODO

## System testing
TODO

## Other types of tests
TODO. Discuss in less detail.

## TODO
* Overlap between the different testing types (unit, component/UI, integration, system). How to choose what to test?
* The role of manual testing.
