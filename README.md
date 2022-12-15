# BookStore Luiz Vasconcellos


App developped based on the public Google Books API https://developers.google.com/books/docs/v1/getting_started#REST. This app call Gogle Books API searching for "iOS" term and show the books related to this seach paginating it (when you scroll down and reach the end of the list they will load more books). When you select one book you can see the book details, if you want you can bookmark it and if available you can touch up at buy button and can be redirected to the books page. If you bookmarked books, you can access the list directly from the home screen.

The App was developed using Xcode 13.4.1 and Swift 5, based on MVVM-C Architecture (Model, View Model, Coordinator), SOLID principles and Clean Code. I used Cocoa Pods as a Dependency Manager, RXSwift, Swinject and Alamofire pods.

# Pods Used
RXSwift - Used for FRP (Functional reactive programming), I thhink it is a great and easy lib for develop using FRP.
Alamofire - Used for perform API Requests, I decided to use Alamofire in this project becouse they provide some features like error handeling and cache and according to the time for develop this app I tought was better avoid to spend time writing api calls, cache and handeling code.
Swinject - Used for resolve Dependency Injection in a easy way.

# How can you run It?
To make more easy to run and avoid erros in the future I included the external lib in the project.

And to use the app it's very simple, you can just download it, open the project on Xcode and run it 😉 (you can build it for iPhone or iPad).

# Feedback
Please feel free to leave your comments and send me some feedbacks, they will help me to focus my study and learn more everyday! 🥰
