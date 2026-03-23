## Section 6: Spring MVC with Thymeleaf

**What is Thymeleaf**
* <a href="https://www.thymeleaf.org/">Thymeleaf</a> is a Java templating engine
* Commonly used to generate HTML views for web apps
* However, it is general purpose templating engine
    * Can use Thymeleaf outside of webapps

**Where to place Thymeleaf template?**
* In Spring Boot, your Thymeleaf template file go in "`src/main/resources/templates`"
* For web apps, Thymeleaf templates have a "`.html`" extension

**Additional Features**
* Looping and conditionals
* CSS and JavaScript integration
* Template layouts and fragments

**Using CSS with Thymeleaf Templates**
* You have the option of using
    * Local CSS files as part of your project
    * Referencing remote CSS files

**Development Process**
1. Create CSS file
    * Spring Boot will look for static resources in the directory "`src/main/resources/static`"
        * We could have a CSS file stored in "`src/main/resources/static/css/demo.css`"
2. Reference CSS in Thymeleaf template

```html
<head>
    <title>Thymeleaf Demo</title>

    <!-- reference CSS file -->
    <link rel="stylesheet" th:href="@{/css/demo.css}"/>
</head>
```

Let's say the content of the CSS file "`demo.css`" is the following:

```css
.funny {
    font-style: italic;
    color: green;
}
```

3. Apply CSS

```html
<head>
    <title>Thymeleaf Demo</title>

    <!-- reference CSS file -->
    <link rel="stylesheet" th:href="@{/css/demo.css}"/>
</head>
<body>
    <p th:text="'The time on the server is ' + ${theDate}" class="funny"/>
</body>
```

### Spring Boot - Spring MVC Behind the Scenes

**Components of a Spring MVC Application**
* A set of web pages to layout UI components
* A collection of Spring beans (controllers, services, etc...)
* Spring condiguration (XML, Annotations or Java)

**Spring MVC Front Controller**
* Front controller known as **DispatchetServlet**
    * Part of the Spring Framework
    * Already developed by Spring Dev Team
* You will create
    * Model objects
    * View templates
    * Controller classes

#### Controller
* Code created by developer
* Contains your business logic
    * Handle the request
    * Store/retrieve data (db, web service,...)
    * Place data in model
* Send to appropriate view template

#### Model
* Model: contains your data
* Store/retrieve data via backend systems
    * database, web service, etc...
    * Use a Spring bean if you like
* Place your data in the model
    * Data can be any Java object/collection

#### View Template
* Spring MVC is flexible
    * Supports many view templates
* Recommended: <a href="https://www.thymeleaf.org/">Thymeleaf</a>
* Developer creates a page
    * Displays data

**View Template (more)**
* Other view templates supported:
    * Groovy, Velocity, Freemarker, etc...
* For details go to this <a href="https://docs.spring.io/spring-framework/reference/web/webmvc-view.html">webpage</a>

### Reading Form Data with Spring MVC
On high level overview we will present to our user with a form. It could very simple something like a text field and a button asking for the name of the user. When the user clicks the button the webpage will display a message that will use the name of the user. 

**Development Process**
1. **Create Controller class**
2. **Show HTML form**
    * Create controller method to show HTML form
    * Create View Page for HTML form
3. **Process HTML form**
    * Create controller method to process HTML form
    * Develop View Page for Confirmation

### Adding Data to Spring Model

**Spring Model**
* The **Model** is a container for your application data
* In your Controller
    * You can put anything in the **model**
    * string, objects, info from database, etc...
* Your View page can access data from the **model**

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HelloWorldController {

    // need a controller method to show initial HTML form

    @RequestMapping("/showForm")
    public String showForm() {
        return "helloworld-form";
    }

    // need a controller method to process the HTML form
    @RequestMapping("/processForm")
    public String processForm() {
        return "helloworld";
    }

    // need a controller method to read form data and
    // add data to the model

    @RequestMapping("/processFormVersionTwo")
    public String letsShoutDude(HttpServletRequest request, Model model) {

        // read the request parameter from the HTML form
        String theName = request.getParameter("studentName");

        // convert the data to all caps
        theName = theName.toUpperCase();

        // create the message
        String result = "Yo! " + theName;

        // add message to the model
        model.addAttribute("message", result);

        return "helloworld";
    }
}
```

### Reading HTML Form Data with `@RequestParam` annotation

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HelloWorldController {

    // need a controller method to show initial HTML form

    @RequestMapping("/showForm")
    public String showForm() {
        return "helloworld-form";
    }

    // need a controller method to process the HTML form
    @RequestMapping("/processForm")
    public String processForm() {
        return "helloworld";
    }

    // need a controller method to read form data and
    // add data to the model

    @RequestMapping("/processFormVersionTwo")
    public String letsShoutDude(HttpServletRequest request, Model model) {

        // read the request parameter from the HTML form
        String theName = request.getParameter("studentName");

        // convert the data to all caps
        theName = theName.toUpperCase();

        // create the message
        String result = "Yo! " + theName;

        // add message to the model
        model.addAttribute("message", result);

        return "helloworld";
    }

    @RequestMapping("/processFormVersionThree")
    public String processFormVersionThree(@RequestParam("studentName") String theName,
                                          Model model) {

        // convert the data to all caps
        theName = theName.toUpperCase();

        // create the message
        String result = "Hey My Friend from v3! " + theName;

        // add message to the model
        model.addAttribute("message", result);

        return "helloworld";
    }
}
```

### Spring MVC Form - Drop Down List

Let's review how to make a drop down list in HTML. Typically is something like this:

```html
<select th:field="*{country}">
    <option th:value="Brazil">Brazil</option>
    <option th:value="France">France</option>
    <option th:value="Germany">Germany</option>
    <option th:value="India">India</option>
</select>
```

Bear in mind that this "`select`" uses Thymeleaf (pay attention to the attributes:
* "`th:field`": This one is used to do a binding between the HTML code and the Java class.
* "`th:value`": This one is used to assign a value to the attribute of the Java class that was referred using "`th:field`".

**Development Process**
1. Update HTML form
2. Update Student class - add getter/setter for new property
    * We are adding the new "`country`" property to the Student class
3. Update confirmation page

**You can make things more dynamic**

You could declare a new property in your "`application.properties`" file and you could use that information.

Let's say that you declare the following property in your properties file:

```properties
countries=Brazil,France,Germany,India,Mexico,Spain,United States
```

Once this information is added in the properties file you need to update the model to introduce this information so that in can be accessed in the view.

For instance, we need to update the "`StudentController`" class as the following:

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import com.luv2code.springboot.thymeleafdemo.model.Student;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class StudentController {

    @Value("${countries}")
    private List<String> countries;

    @GetMapping("/showStudentForm")
    public String showForm(Model theModel) {

        // create a student object
        Student theStudent = new Student();

        // add student object to the model
        theModel.addAttribute("student", theStudent);

        // add the list of countries to the model
        theModel.addAttribute("countries", countries);

        return "student-form";
    }

    @PostMapping("/processStudentForm")
    public String processForm(@ModelAttribute("student") Student theStudent) {

        // log the input data
        System.out.println("theStudent: " + theStudent.getFirstName() + " " + theStudent.getLastName());

        return "student-confirmation";
    }

}
```

Pay attention to the line where "`countries`" is added to "`theModel`" object. 

The "`countries`" will be used in the View like this:

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Student Registration Form</title>
</head>
<body>
<h3>Student Registration Form</h3>
<form th:action="@{/processStudentForm}" th:object="${student}" method="POST">
    First name: <input type="text" th:field="*{firstName}" />

    <br><br>

    Last name: <input type="text" th:field="*{lastName}" />

    <br><br>

    Country:
    <!-- THIS IS THE IMPORTANT PART -->
    <select th:field="*{country}">
        <option th:each="tempCountry : ${countries}" th:value="${tempCountry}" th:text="${tempCountry}" />
    </select>
    <!-- THIS IS THE IMPORTANT PART -->
    <br><br>
    <input type="submit" value="Submit" />
</form>
</body>
</html>
```


### Spring MVC Form - Radio Buttons

Let's review how to make radio buttons in HTML:

```html
    <input type="radio" th:field="*{favoriteLanguage}" th:value="Go">Go</input>
    <input type="radio" th:field="*{favoriteLanguage}" th:value="Java">Java</input>
    <input type="radio" th:field="*{favoriteLanguage}" th:value="Python">Python</input>
```

As you can see here you need to use the "`<input>`" tag in HTML with the type "`radio`". Then, using Thymeleaf you are mapping the new attribute "`favoriteLanguage`" to the Student class.

**Development Process** (Same as previous examples)
1. Update HTML form

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Student Registration Form</title>
</head>
<body>
<h3>Student Registration Form</h3>
<form th:action="@{/processStudentForm}" th:object="${student}" method="POST">
    First name: <input type="text" th:field="*{firstName}" />
    <br><br>
    Last name: <input type="text" th:field="*{lastName}" />
    <br><br>
    Country:
    <select th:field="*{country}">
        <option th:each="tempCountry : ${countries}" th:value="${tempCountry}" th:text="${tempCountry}" />
    </select>

    <br><br>

    Favorite Programming Language:
    <! THIS IS NEW -->
    <input type="radio" th:field="*{favoriteLanguage}" th:value="Go">Go</input>
    <input type="radio" th:field="*{favoriteLanguage}" th:value="Java">Java</input>
    <input type="radio" th:field="*{favoriteLanguage}" th:value="Python">Python</input>
    <! THIS IS NEW -->

    <br><br>
    <input type="submit" value="Submit" />
</form>
</body>
</html>
```

2. Update Student class - add getter/setter for new property

```java
package com.luv2code.springboot.thymeleafdemo.model;

public class Student {

    private String firstName;
    private String lastName;
    private String country;
    private String favoriteLanguage;

    public Student() {

    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getFavoriteLanguage() {
        return favoriteLanguage;
    }

    public void setFavoriteLanguage(String favoriteLanguage) {
        this.favoriteLanguage = favoriteLanguage;
    }
}
```

3. Update confirmation page

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Student Confirmation</title>
</head>
<body>

<h3>Student Confirmation</h3>

The student is confirmed: <span th:text="${student.firstName} + ' ' + ${student.lastName}" />

<br><br>

Country: <span th:text="${student.country}" />

<br><br>

Favorite Programming Language: <span th:text="${student.favoriteLanguage}" />

</body>
</html>
```

In the same way that we are to "bind" the countries using the "`@Value`" annotation and the data in the "`application.properties`" file we can do the same with the radio buttons.

**Step 1: We modiffy the "`application.properties`" file**

```txt
countries=Brazil,France,Germany,India,Mexico,Spain,United States
languages=Go,Java,Python,Rust,TypeScript
```

**Step 2: We modify the "`StudentController`" class to inject the new data of the properties file with the "`@Value`" annotation**

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import com.luv2code.springboot.thymeleafdemo.model.Student;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class StudentController {

    @Value("${countries}")
    private List<String> countries;

    /*
     * THIS IS NEW VVVVVVVVVVV
     */
    @Value("${languages}")
    private List<String> languages;
    /*
     * THIS IS NEW ^^^^^^^^^^^
     */

    @GetMapping("/showStudentForm")
    public String showForm(Model theModel) {

        // create a student object
        Student theStudent = new Student();

        // add student object to the model
        theModel.addAttribute("student", theStudent);

        // add the list of countries to the model
        theModel.addAttribute("countries", countries);

        /*
         * THIS IS NEW VVVVVVVVVVV
         */
        // add the list of languages to the model
        theModel.addAttribute("languages", languages);
        /*
         * THIS IS NEW ^^^^^^^^^^^
         */

        return "student-form";
    }

    @PostMapping("/processStudentForm")
    public String processForm(@ModelAttribute("student") Student theStudent) {

        // log the input data
        System.out.println("theStudent: " + theStudent.getFirstName() + " " + theStudent.getLastName());

        return "student-confirmation";
    }

}
```

**Step 3: Add the list of languages to the model**

```java
package com.luv2code.springboot.thymeleafdemo.model;

public class Student {

    private String firstName;
    private String lastName;
    private String country;

    /*
    * THIS IS NEW VVVVVVV
    */
    private String favoriteLanguage;
    /*
    * THIS IS NEW ^^^^^^^
    */

    public Student() {

    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getFavoriteLanguage() {
        return favoriteLanguage;
    }

    public void setFavoriteLanguage(String favoriteLanguage) {
        this.favoriteLanguage = favoriteLanguage;
    }
}
```

**Step 4: Modify the Studen form to include the new data**

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Student Registration Form</title>
</head>
<body>
<h3>Student Registration Form</h3>
<form th:action="@{/processStudentForm}" th:object="${student}" method="POST">

    First name: <input type="text" th:field="*{firstName}" />

    <br><br>

    Last name: <input type="text" th:field="*{lastName}" />

    <br><br>

    Country:

    <select th:field="*{country}">

        <option th:each="tempCountry : ${countries}" th:value="${tempCountry}" th:text="${tempCountry}" />

    </select>

    <br><br>

    Favorite Programming Language:
    <!-- THIS IS NEW VVVVVV -->
    <input type="radio" th:field="*{favoriteLanguage}"
                        th:each="tempLang : ${languages}"
                        th:value="${tempLang}"
                        th:text="${tempLang}" />
    <!-- THIS IS NEW ^^^^^^ -->
    <br><br>

    <input type="submit" value="Submit" />

</form>

</body>
</html>
```

### Spring MVC Form - Check Boxes

**Step 1: Modify the form to include the check boxes**

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <title>Student Registration Form</title>
</head>
<body>
<h3>Student Registration Form</h3>
<form th:action="@{/processStudentForm}" th:object="${student}" method="POST">
    First name: <input type="text" th:field="*{firstName}" />

    <br><br>
    Last name: <input type="text" th:field="*{lastName}" />

    <br><br>
    Country:
    <select th:field="*{country}">
        <option th:each="tempCountry : ${countries}" th:value="${tempCountry}" th:text="${tempCountry}" />
    </select>

    <br><br>
    Favorite Programming Language:
    <input type="radio" th:field="*{favoriteLanguage}"
                        th:each="tempLang : ${languages}"
                        th:value="${tempLang}"
                        th:text="${tempLang}" />

    <br><br>

    Favorite Operating Systems:

    <!-- THIS IS NEW VVVVVV -->
    <input type="checkbox" th:field="*{favoriteSystems}" th:value="Linux">Linux</input>
    <input type="checkbox" th:field="*{favoriteSystems}" th:value="macOS">macOS</input>
    <input type="checkbox" th:field="*{favoriteSystems}"
                           th:value="'Microsoft Windows'">Microsoft Windows</input>
    <!-- THIS IS NEW ^^^^^^ -->

    <br><br>

    <input type="submit" value="Submit" />

</form>

</body>
</html>
```

Notice the special case of the 3rd option ("`Microsoft Windows`"). As the name itself contains spaces it needs to be enclosed between single quotes ("`'...'`) to be able to be shown properly.

**Step 2: Add the new property to the model**

```java
package com.luv2code.springboot.thymeleafdemo.model;

import java.util.List;

public class Student {

    private String firstName;
    private String lastName;
    private String country;
    private String favoriteLanguage;
    /*
    * THIS IS NEW VVVVVVV
    */
    private List<String> favoriteSystems;
    /*
    * THIS IS NEW ^^^^^^^
    */

    public Student() {

    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getFavoriteLanguage() {
        return favoriteLanguage;
    }

    public void setFavoriteLanguage(String favoriteLanguage) {
        this.favoriteLanguage = favoriteLanguage;
    }

    public List<String> getFavoriteSystems() {
        return favoriteSystems;
    }

    public void setFavoriteSystems(List<String> favoriteSystems) {
        this.favoriteSystems = favoriteSystems;
    }
}
```

**Step 3: Update confirmation page**

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Student Confirmation</title>
</head>
<body>

<h3>Student Confirmation</h3>

The student is confirmed: <span th:text="${student.firstName} + ' ' + ${student.lastName}" />

<br><br>

Country: <span th:text="${student.country}" />

<br><br>

Favorite Programming Language: <span th:text="${student.favoriteLanguage}" />

<br><br>

Favorite Operating Systems:

<!-- THIS IS NEW VVVVVV -->
<ul>
    <li th:each="tempSystem : ${student.favoriteSystems}" th:text="${tempSystem}" />
</ul>
<!-- THIS IS NEW ^^^^^^ -->


</body>
</html>
```

To do the "*binding*" so that it can be extracted from the "`application.properties`" file you need to do the following:
* Step 1: Add the new data in the "`application.properties`" file

```txt
countries=Brazil,France,Germany,India,Mexico,Spain,United States
languages=Go,Java,Python,Rust,TypeScript
systems=Linux,macOS,Microsoft Windows,Android OS,iOS
```

* Step 2: Add the new data in the model

```java
package com.luv2code.springboot.thymeleafdemo.model;

import java.util.List;

public class Student {

    private String firstName;
    private String lastName;
    private String country;
    private String favoriteLanguage;
    /*
    * THIS IS NEW VVVVVVV
    */
    private List<String> favoriteSystems;
    /*
    * THIS IS NEW ^^^^^^^
    */

    public Student() {

    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getFavoriteLanguage() {
        return favoriteLanguage;
    }

    public void setFavoriteLanguage(String favoriteLanguage) {
        this.favoriteLanguage = favoriteLanguage;
    }

    public List<String> getFavoriteSystems() {
        return favoriteSystems;
    }

    public void setFavoriteSystems(List<String> favoriteSystems) {
        this.favoriteSystems = favoriteSystems;
    }
}
```

* Step 3: Modify the "`StudentController`" class

```java
package com.luv2code.springboot.thymeleafdemo.controller;

import com.luv2code.springboot.thymeleafdemo.model.Student;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class StudentController {

    @Value("${countries}")
    private List<String> countries;

    @Value("${languages}")
    private List<String> languages;

    @Value("${systems}")
    private List<String> systems;

    @GetMapping("/showStudentForm")
    public String showForm(Model theModel) {

        // create a student object
        Student theStudent = new Student();

        // add student object to the model
        theModel.addAttribute("student", theStudent);

        // add the list of countries to the model
        theModel.addAttribute("countries", countries);

        // add the list of languages to the model
        theModel.addAttribute("languages", languages);

        // add the list of systems to the model
        theModel.addAttribute("systems", systems);

        return "student-form";
    }

    @PostMapping("/processStudentForm")
    public String processForm(@ModelAttribute("student") Student theStudent) {

        // log the input data
        System.out.println("theStudent: " + theStudent.getFirstName() + " " + theStudent.getLastName());

        return "student-confirmation";
    }

}
```

* Step 4: Modify the student form page

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <title>Student Registration Form</title>
</head>
<body>

<h3>Student Registration Form</h3>

<form th:action="@{/processStudentForm}" th:object="${student}" method="POST">

    First name: <input type="text" th:field="*{firstName}" />

    <br><br>

    Last name: <input type="text" th:field="*{lastName}" />

    <br><br>

    Country:

    <select th:field="*{country}">

        <option th:each="tempCountry : ${countries}" th:value="${tempCountry}" th:text="${tempCountry}" />

    </select>

    <br><br>

    Favorite Programming Language:

    <input type="radio" th:field="*{favoriteLanguage}"
                        th:each="tempLang : ${languages}"
                        th:value="${tempLang}"
                        th:text="${tempLang}" />

    <br><br>

    Favorite Operating Systems:
    <!-- THIS IS NEW VVVVVV -->
    <input type="checkbox" th:field="*{favoriteSystems}"
                           th:each="tempSystem : ${systems}"
                           th:value="${tempSystem}"
                           th:text="${tempSystem}" />
    <!-- THIS IS NEW ^^^^^^ -->
    <br><br>

    <input type="submit" value="Submit" />

</form>

</body>
</html>
```

* Step 5: Modify the student confirmation page

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Student Confirmation</title>
</head>
<body>

<h3>Student Confirmation</h3>

The student is confirmed: <span th:text="${student.firstName} + ' ' + ${student.lastName}" />

<br><br>

Country: <span th:text="${student.country}" />

<br><br>

Favorite Programming Language: <span th:text="${student.favoriteLanguage}" />

<br><br>

Favorite Operating Systems:

<!-- THIS IS NEW VVVVVV -->
<ul>
    <li th:each="tempSystem : ${student.favoriteSystems}" th:text="${tempSystem}" />
</ul>
<!-- THIS IS NEW ^^^^^^ -->

</body>
</html>
```

### Spring MVC Validation

The need for validation. Check the user input for:
* Required fields
* Valid numbers in a range
* Valid format (for example, postal code)
* Custom business rule

**Java's Standard Bean Validation API**
* Java has a standard Bean Validation API
* Defines a metadata model and API for entity validation
* Spring Boot and Thymeleaf also support the Bean Validation API
* You can find more information about the Bean Validation API in <a href="https://beanvalidation.org/">the following link</a>
* Bean validation features
    * Required
    * Validate length
    * Validate numbers
    * Validate with regular expressions
    * Custom validation

#### Spring MVC Validation - Required Fields

**Development Process**
1. Create Customer class and add validation rules

```java
package com.luv2code.springdemo.mvc;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class Customer {

    private String firstName;

    @NotNull(message="is required")
    @Size(min=1, message="is required")
    private String lastName = "";

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
```

2. Add Controller code to show HTML form

```java
package com.luv2code.springdemo.mvc;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class CustomerController {

    @GetMapping("/")
    public String showForm(Model theModel) {

        theModel.addAttribute("customer", new Customer());

        return "customer-form";
    }

    @PostMapping("/processForm")
    public String processForm(
            @Valid @ModelAttribute("customer") Customer theCustomer,
            BindingResult theBindingResult) {

        if (theBindingResult.hasErrors()) {
            return "customer-form";
        }
        else {
            return "customer-confirmation";
        }
    }
}
```

3. Develop HTML form and add validation support

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customer Registration Form</title>

    <style>
        .error {color:red}
    </style>
</head>

<body>
<i>Fill out the form. Asterisk (*) means required.</i>
<br><br>
<form th:action="@{/processForm}" th:object="${customer}" method="POST">

    First name: <input type="text" th:field="*{firstName}" />

    <br><br>

    Last name (*): <input type="text" th:field="*{lastName}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('lastName')}"
          th:errors="*{lastName}"
          class="error"></span>

    <br><br>

    <input type="submit" value="Submit" />

</form>

</body>
</html>
```

4. Perform validation in the Controller class

```java
package com.luv2code.springdemo.mvc;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class CustomerController {

    @GetMapping("/")
    public String showForm(Model theModel) {

        theModel.addAttribute("customer", new Customer());

        return "customer-form";
    }

    @PostMapping("/processForm")
    public String processForm(
            @Valid @ModelAttribute("customer") Customer theCustomer,
            BindingResult theBindingResult) {

        if (theBindingResult.hasErrors()) {
            return "customer-form";
        }
        else {
            return "customer-confirmation";
        }
    }
}
```

5. Create confirmation page

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customer Confirmation</title>
</head>
<body>

The customer is confirmed: <span th:text="${customer.firstName + ' ' + customer.lastName}" />

</body>
</html>
```

#### Spring MVC Validation - @InitBinder

* Our previous example had a problem with white space
    * Last name field with all whitespace passed ... YIKES!
    * Should have failed
* We need to trim whitespace from input fields

For that we will use the "`@InitBinder`" annotation:
* The "`@InitBinder`" annotation works as a pre-processor
* It will pre-process each web request to our controller
* Method annotated with "`@InitBinder`" is executed
* We will use it to trim Strings
    * Remove leading and trailing white space
* If String only has white spaces... trim it to `null` 
* This will resolve our validation problem... whew :-)

In our case we are adding a method in the "`CustomerController`" class like the following:

```java
    @InitBinder
    public void initBinder(WebDataBinder dataBinder) {

        StringTrimmerEditor stringTrimmerEditor = new StringTrimmerEditor(true);

        dataBinder.registerCustomEditor(String.class, stringTrimmerEditor);
    }
```

This method will:
* Pre-process every String form data
* Remove leading and trailing white space
* If String only has white space ... trim it to `null`

Once you introduce the new "`initBinder`" method annotated with the "`@InitBinder`" annotation the "`CustomerController`" class will look like follows:

```java
package com.luv2code.springdemo.mvc;

import jakarta.validation.Valid;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class CustomerController {

    // add an initbinder ... to convert trim input strings
    // remove leading and trailing whitespace
    // resolve issue for our validation
    @InitBinder
    public void initBinder(WebDataBinder dataBinder) {

        StringTrimmerEditor stringTrimmerEditor = new StringTrimmerEditor(true);

        dataBinder.registerCustomEditor(String.class, stringTrimmerEditor);
    }

    @GetMapping("/")
    public String showForm(Model theModel) {

        theModel.addAttribute("customer", new Customer());

        return "customer-form";
    }

    @PostMapping("/processForm")
    public String processForm(
            @Valid @ModelAttribute("customer") Customer theCustomer,
            BindingResult theBindingResult) {

        System.out.println("Last name: |" + theCustomer.getLastName() + "|");

        if (theBindingResult.hasErrors()) {
            return "customer-form";
        }
        else {
            return "customer-confirmation";
        }
    }
}
```

#### Spring MVC Validation - Number Range "`@Min`" and "`@Max`"

**Development Process**
1. Add validation rule to "`Customer`" class

```java
package com.luv2code.springdemo.mvc;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class Customer {

    private String firstName;

    @NotNull(message="is required")
    @Size(min=1, message="is required")
    private String lastName = "";

    @Min(value=0, message="must be greater than or equal to zero")
    @Max(value=10, message="must be less than or equal to 10")
    private int freePasses;

    public int getFreePasses() {
        return freePasses;
    }

    public void setFreePasses(int freePasses) {
        this.freePasses = freePasses;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
```

2. Display error messages on HTML form

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customer Registration Form</title>

    <style>
        .error {color:red}
    </style>
</head>

<body>
<i>Fill out the form. Asterisk (*) means required.</i>
<br><br>
<form th:action="@{/processForm}" th:object="${customer}" method="POST">

    First name: <input type="text" th:field="*{firstName}" />

    <br><br>

    Last name (*): <input type="text" th:field="*{lastName}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('lastName')}"
          th:errors="*{lastName}"
          class="error"></span>

    <br><br>

    Free passes: <input type="text" th:field="*{freePasses}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('freePasses')}"
          th:errors="*{freePasses}"
          class="error"></span>

    <br><br>

    <input type="submit" value="Submit" />

</form>

</body>
</html>
```

3. Perform validation in the Controller class

```java
package com.luv2code.springdemo.mvc;

import jakarta.validation.Valid;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class CustomerController {

    // add an initbinder ... to convert trim input strings
    // remove leading and trailing whitespace
    // resolve issue for our validation
    @InitBinder
    public void initBinder(WebDataBinder dataBinder) {

        StringTrimmerEditor stringTrimmerEditor = new StringTrimmerEditor(true);

        dataBinder.registerCustomEditor(String.class, stringTrimmerEditor);
    }

    @GetMapping("/")
    public String showForm(Model theModel) {

        theModel.addAttribute("customer", new Customer());

        return "customer-form";
    }

    @PostMapping("/processForm")
    public String processForm(
            @Valid @ModelAttribute("customer") Customer theCustomer,
            BindingResult theBindingResult) {

        System.out.println("Last name: |" + theCustomer.getLastName() + "|");

        if (theBindingResult.hasErrors()) {
            return "customer-form";
        }
        else {
            return "customer-confirmation";
        }
    }
}
```

4. Update confirmation page

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customer Confirmation</title>
</head>
<body>

The customer is confirmed: <span th:text="${customer.firstName + ' ' + customer.lastName}" />

<br><br>

Free passes: <span th:text="${customer.freePasses}" />

</body>
</html>
```

#### Spring MVC Validation - Regular Expressions

**Regular Expressions**
* A sequence of characters that define a search pattern
    * This pattern is used to find or match strings
* Regular Expressions is like its own language (advanced topic)
* <a href="https://docs.oracle.com/javase/tutorial/essential/regex/">There are plenty of free tutorials available</a>

The development process is very similar to the previous examples:
1. Add validation rule to the "`Customer`" class

```java
package com.luv2code.springdemo.mvc;

import jakarta.validation.constraints.*;

public class Customer {

    private String firstName;

    @NotNull(message="is required")
    @Size(min=1, message="is required")
    private String lastName = "";

    @Min(value=0, message="must be greater than or equal to zero")
    @Max(value=10, message="must be less than or equal to 10")
    private int freePasses;

    @Pattern(regexp = "^[a-zA-Z0-9]{5}", message = "only 5 chars/digits")
    private String postalCode;

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public int getFreePasses() {
        return freePasses;
    }

    public void setFreePasses(int freePasses) {
        this.freePasses = freePasses;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
```

2. Display error messages on HTML form

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customer Registration Form</title>

    <style>
        .error {color:red}
    </style>
</head>

<body>
<i>Fill out the form. Asterisk (*) means required.</i>
<br><br>
<form th:action="@{/processForm}" th:object="${customer}" method="POST">

    First name: <input type="text" th:field="*{firstName}" />

    <br><br>

    Last name (*): <input type="text" th:field="*{lastName}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('lastName')}"
          th:errors="*{lastName}"
          class="error"></span>

    <br><br>

    Free passes: <input type="text" th:field="*{freePasses}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('freePasses')}"
          th:errors="*{freePasses}"
          class="error"></span>

    <br><br>

    Postal Code: <input type="text" th:field="*{postalCode}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('postalCode')}"
          th:errors="*{postalCode}"
          class="error"></span>

    <br><br>

    <input type="submit" value="Submit" />

</form>

</body>
</html>
```

3. Update confirmation page

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customer Confirmation</title>
</head>
<body>

The customer is confirmed: <span th:text="${customer.firstName + ' ' + customer.lastName}" />

<br><br>

Free passes: <span th:text="${customer.freePasses}" />

<br><br>

Postal code: <span th:text="${customer.postalCode}" />

</body>
</html>
```

#### Spring MVC Validation - Make an Integer Field Required

Basically you add the "`@NotNull`" annotation to the field of the model that is required and that's it.


#### Spring MVC Validation - Handle String Input for Integer Fields

There are cases where you will have a user introduce text in a field that is supposed to be a number.

You need to add the "`messages.properties`" file with the following content:

```txt
typeMismatch.customer.freePasses=Invalid number
```

Where the key "`typeMismatch.customer.freePasses`" will be mapped to the property of the model that has a "Type Mismatch".

The key can be decomposed in the following parts:
* **Error Type**: "`typeMismatch`"
* **Spring model attribute name**: "`customer`"
* **Field name**: "`freePasses`"

Very important to bear in mind is that the location of the "`messages.properties`" file should always be "`src/main/resources/messages.properties`".

#### Spring MVC Validation - Custom Validation

* Perform custom validation based on your business rules
    * In the following example we will write a validator forcing the "Course Code" to start with "LUV"
* Spring MVC calls our custom validation
* Custom validation returns boolean value for pass/fail (true / false)

To be able to write a custom validation we need to create a custom Java Annotation... from scratch
* So far, we've used predefines validation rules: "`@Min`", "`@Max`", ...
* For custom validation ... we will create a **Custom Java Annotation**
    * "`@CourseCode`"

**Development Process**
1. Create custom validation rule
    a. Create "`@CourseCode`" annotation

```java
package com.luv2code.springdemo.mvc.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = CourseCodeConstraintValidator.class)
@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface CourseCode {

    // define default course code
    public String value() default "LUV";

    // define default error message
    public String message() default "must start with LUV";

    // define default groups
    public Class<?>[] groups() default {};

    // define default payloads
    public Class<? extends Payload>[] payload() default {};
}
```


   b. Create "`CourseCodeConstraintValidator`" class
       * It's a helper class that contains our custom business logic for validation


```java
package com.luv2code.springdemo.mvc.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class CourseCodeConstraintValidator  implements ConstraintValidator<CourseCode, String> {

    private String coursePrefix;

    @Override
    public void initialize(CourseCode theCourseCode) {
        coursePrefix = theCourseCode.value();
    }

    @Override
    public boolean isValid(String theCode, ConstraintValidatorContext theConstraintValidatorContext) {

        boolean result;

        if (theCode != null) {
            result = theCode.startsWith(coursePrefix);
        }
        else {
            result = true;
        }

        return result;
    }
}
```

2. Add validation rule to "`Customer`" class

```java
package com.luv2code.springdemo.mvc;

import com.luv2code.springdemo.mvc.validation.CourseCode;
import jakarta.validation.constraints.*;

public class Customer {

    private String firstName;

    @NotNull(message="is required")
    @Size(min=1, message="is required")
    private String lastName = "";

    @NotNull(message="is required")
    @Min(value=0, message="must be greater than or equal to zero")
    @Max(value=10, message="must be less than or equal to 10")
    private Integer freePasses;

    @Pattern(regexp = "^[a-zA-Z0-9]{5}", message = "only 5 chars/digits")
    private String postalCode;

    /*
    * THIS IS NEW VVVVV
    */
    @CourseCode(value="TOPS", message="must start with TOPS")
    private String courseCode;
    /*
    * THIS IS NEW ^^^^^
    */

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public Integer getFreePasses() {
        return freePasses;
    }

    public void setFreePasses(Integer freePasses) {
        this.freePasses = freePasses;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
```

3. Display error messages on HTML form

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customer Registration Form</title>

    <style>
        .error {color:red}
    </style>
</head>

<body>
<i>Fill out the form. Asterisk (*) means required.</i>
<br><br>
<form th:action="@{/processForm}" th:object="${customer}" method="POST">

    First name: <input type="text" th:field="*{firstName}" />

    <br><br>

    Last name (*): <input type="text" th:field="*{lastName}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('lastName')}"
          th:errors="*{lastName}"
          class="error"></span>

    <br><br>

    Free passes: <input type="text" th:field="*{freePasses}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('freePasses')}"
          th:errors="*{freePasses}"
          class="error"></span>

    <br><br>

    Postal Code: <input type="text" th:field="*{postalCode}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('postalCode')}"
          th:errors="*{postalCode}"
          class="error"></span>

    <br><br>

    Course Code: <input type="text" th:field="*{courseCode}" />

    <!-- Add error message (if present) -->
    <span th:if="${#fields.hasErrors('courseCode')}"
          th:errors="*{courseCode}"
          class="error"></span>

    <br><br>

    <input type="submit" value="Submit" />

</form>

</body>
</html>
```

4. Update confirmation page

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Customer Confirmation</title>
</head>
<body>

The customer is confirmed: <span th:text="${customer.firstName + ' ' + customer.lastName}" />

<br><br>

Free passes: <span th:text="${customer.freePasses}" />

<br><br>

Postal code: <span th:text="${customer.postalCode}" />

<br><br>

Course code: <span th:text="${customer.courseCode}" />


</body>
</html>
```

