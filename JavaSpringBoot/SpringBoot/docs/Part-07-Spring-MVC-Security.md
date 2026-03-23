### Section 8: Spring MVC Security

In this section we will learn how to:
* 
* Secure Spring MVC Web Apps
* Develop login pages (default and custom)
* Define user and roles with simple authentication
* Protect URLs based on a given role
* Hide/show content based on a given role
* Store users, passwords and roles in DB (plain-text -> encrypted)

You can have a look a the gory details of Spring Security in <a href="https://docs.spring.io/spring-security/reference/">this webpage</a>.

**Spring Security Model**
* Spring Security defines a framework for security
* Implemented using Servlet filters in the background
    * Servlet Filters are used to pre-process / post-process web requests
    * Servlet Filters can route web requests based on security logic
    * Spring provides a bulk of security functionality with servlet filters
* Two methods of securing an app:
    * Declarative
    * Programmatic

**Security Concepts**
* Authentication
    * Check used id and password with credentials stored in app / db
* Authorization
    * Check to see if user has an authorized role

**Declarative Security**
* Define application's security constraints in configuration
    * All Java config: "`@Configuration`"
* Provides separation of concerns between application code and security

**Programmatic Security**
* Spring Security provides and API for custom application coding
* Provides greater customization for specific app requirements

**Enabling Spring Security**
1. Edit "`pom.xml`" file and add "`spring-boot-starter-security`"

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

**Development Process**
1. Create project at <a href="https://start.spring.io/">Spring Initializr website</a>
    * Add Maven dependencies for Spring MVC Web App, Security, Thymeleaf

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>3.4.0</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>
	<groupId>com.luv2code.springboot</groupId>
	<artifactId>demosecurity</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>demosecurity</name>
	<description>Demo project for Spring Boot</description>
	<properties>
		<java.version>17</java.version>
	</properties>
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-thymeleaf</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
		<dependency>
			<groupId>org.thymeleaf.extras</groupId>
			<artifactId>thymeleaf-extras-springsecurity6</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-devtools</artifactId>
			<scope>runtime</scope>
			<optional>true</optional>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
		<dependency>
			<groupId>org.springframework.security</groupId>
			<artifactId>spring-security-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

</project>
```

2. Develop our Spring controller

```java
package com.luv2code.springboot.demosecurity.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DemoController {

    @GetMapping("/")
    public String showHome() {

        return "home";
    }
}
```

* The string "`home`" that the method "`showHome`" returns is telling to Spring MVC to use the template that is placed inside "`src/main/resources/templates/home.html`". 

3. Develop our Thymeleaf view page

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>luv2code Company Home Page</title>
</head>

<body>

    <h2>luv2code Company Home Page</h2>
    <hr>
    Welcome to the luv2code company home page!

</body>
</html>
```

Let's say we do have the following users in our system:


| User ID | Password | Roles |
| :---: | :--- | :--- |
| `john` | `test123` | `EMPLOYEE` |
| `mary` | `test123` | `EMPLOYEE, MANAGER` |
| `susan` | `test123` | `EMPLOYEE, MANAGER, ADMIN` |

**Development Process**
1. Create Spring Security Configuration ("`@Configuration`")

```java
package com.luv2code.springboot.demosecurity.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class DemoSecurityConfig {

    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {

        UserDetails john = User.builder()
                .username("john")
                .password("{noop}test123")
                .roles("EMPLOYEE")
                .build();

        UserDetails mary = User.builder()
                .username("mary")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER")
                .build();

        UserDetails susan = User.builder()
                .username("susan")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER", "ADMIN")
                .build();

        return new InMemoryUserDetailsManager(john, mary, susan);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                        configurer
                                .anyRequest().authenticated()
                )
                .formLogin(form ->
                        form
                                .loginPage("/showMyLoginPage")
                                .loginProcessingUrl("/authenticateTheUser")
                                .permitAll()
                );

        return http.build();
    }
}
```

2. Add users, passwords and roles

#### Custom Login Form

**Development Process**
1. Modify Spring Security Configuration to reference custom login form
```java
package com.luv2code.springboot.demosecurity.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class DemoSecurityConfig {

    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {

        UserDetails john = User.builder()
                .username("john")
                .password("{noop}test123")
                .roles("EMPLOYEE")
                .build();

        UserDetails mary = User.builder()
                .username("mary")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER")
                .build();

        UserDetails susan = User.builder()
                .username("susan")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER", "ADMIN")
                .build();

        return new InMemoryUserDetailsManager(john, mary, susan);
    }

    /*
    * THIS IS THE IMPORTANT STUFF NOW VVVVVVVVVVVVVVVV
    */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                        configurer
                                .anyRequest().authenticated()
                )
                .formLogin(form ->
                        form
                                .loginPage("/showMyLoginPage")
                                .loginProcessingUrl("/authenticateTheUser")
                                .permitAll()
                );

        return http.build();
    }
}
```

* What this snippet of code in the "`filterChain`" method is saying:
    * Whenever a "`GET`" request happens go to the "`/showMyLoginPage`" URL which will redirect the user to the template "`src/main/resources/templates/plain-login.html`"
    * Then the login form will "`POST`" data to the "`/authenticateTheUser`" URL for processing
        * No Controller Request Mapping required for this. We get it for free.
    * The "`permitAll()`" means that allow everyone to see the login page

2. Develop a Controller to show custom login form

```java
package com.luv2code.springboot.demosecurity.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    @GetMapping("/showMyLoginPage")
    public String showMyLoginPage() {

        // return "plain-login";
        return "fancy-login";
    }
}
```

* The string "`fancy-login`" is telling Spring MVC to redirect the user to the template located in "`src/main/resources/templates/fancy-login.html`"

3. Create custom login form
    * HTML (CSS optional)

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
    <head>
        <title>Login Page</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Bootstrap demo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous" />
    </head>

    <body>
        <div class="container">
            <div id="loginbox" style="margin-top: 50px;" class="col-md-3 col-md-offset-2 col-sm-6 col-sm-offset-2">
                <div class="card border-info">
                    <div class="card-header bg-info">
                        Sign In
                    </div>

                    <div class="card-body">
                        <div class="card-text">

                            <!-- Login Form -->
                            <form action="#" th:action="@{/authenticateTheUser}" method="POST" class="form-horizontal">

                                <!-- Place for messages: error, alert etc ... -->
                                <div class="form-group">
                                    <div class="col-xs-15">
                                        <div>
                                            <!-- Check for login error -->
                                            <div th:if="${param.error}">

                                                <div class="alert alert-danger col-xs-offset-1 col-xs-10">
                                                    Invalid username and password.
                                                </div>

                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <!-- User name -->
                                <div style="margin-bottom: 25px;" class="input-group">
                                    <input type="text" name="username" placeholder="username" class="form-control" />
                                </div>

                                <!-- Password -->
                                <div style="margin-bottom: 25px;" class="input-group">
                                    <input type="password" name="password" placeholder="password" class="form-control" />
                                </div>

                                <!-- Login/Submit Button -->
                                <div style="margin-top: 10px;" class="form-group">
                                    <div class="col-sm-6 controls">
                                        <button type="submit" class="btn btn-success">Login</button>
                                    </div>
                                </div>

                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
```

* Send data to login processing URL: "`/authenticateTheUser`"
    * Must "**POST**" the data
* Spring Security defines <u><b>default names</b></u> for login form fields
    * User name field: **username**
    * Password field: **password**

With the previous setup, if we introduce a bad credentials the application sends us back to the same login page without any error message. 

Using the default login page that is provided by Spring MVC, that page contains default support for error messages, but since we are doing a custom login page we need to add custom code to deal with our errors. 

#### Logout

**Development Process**
1. Add logout support to Spring Security Configuration

```java
package com.luv2code.springboot.demosecurity.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class DemoSecurityConfig {

    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {

        UserDetails john = User.builder()
                .username("john")
                .password("{noop}test123")
                .roles("EMPLOYEE")
                .build();

        UserDetails mary = User.builder()
                .username("mary")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER")
                .build();

        UserDetails susan = User.builder()
                .username("susan")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER", "ADMIN")
                .build();

        return new InMemoryUserDetailsManager(john, mary, susan);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                        configurer
                                .anyRequest().authenticated()
                )
                .formLogin(form ->
                        form
                                .loginPage("/showMyLoginPage")
                                .loginProcessingUrl("/authenticateTheUser")
                                .permitAll()
                )
                .logout(logout -> logout.permitAll()
                ); // THIS IS NEW ^^^^^^^^^^^^^^^^^^

        return http.build();
    }
}
```

2. Add logout button to home page

3. Update login form to display "logged out" message

#### Restrict URLs Based on Roles

**Development Process**
1. Modify "`DemoSecurityConfig`" class to add the restrictions based on roles

```java
package com.luv2code.springboot.demosecurity.security;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class DemoSecurityConfig {

    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {

        UserDetails john = User.builder()
                .username("john")
                .password("{noop}test123")
                .roles("EMPLOYEE")
                .build();

        UserDetails mary = User.builder()
                .username("mary")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER")
                .build();

        UserDetails susan = User.builder()
                .username("susan")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER", "ADMIN")
                .build();

        return new InMemoryUserDetailsManager(john, mary, susan);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                        configurer
                                .requestMatchers("/").hasRole("EMPLOYEE")          // THIS IS NEW
                                .requestMatchers("/leaders/**").hasRole("MANAGER") // THIS IS NEW
                                .requestMatchers("/systems/**").hasRole("ADMIN")   // THIS IS NEW
                                .anyRequest().authenticated()
                )
                .formLogin(form ->
                        form
                                .loginPage("/showMyLoginPage")
                                .loginProcessingUrl("/authenticateTheUser")
                                .permitAll()
                )
                .logout(logout -> logout.permitAll()
                );

        return http.build();
    }

}
```

What is happening in the previous code is that employees with role "`EMPLOYEE`" will be able to access the Home Page ("`/`"). Employees with role "`MANAGER`" will be able to access all pages located under "`/leaders/**`" and all employees with role "`ADMIN`" will be able to access all pages located under "`/systems/**`".

Our home page looks like this:

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/extras/spring-security">

<head>
    <title>luv2code Company Home Page</title>
</head>

<body>
<h2>luv2code Company Home Page</h2>
<hr>

<p>
Welcome to the luv2code company home page!
</p>

<hr>

<!-- display user name and role(s) -->

<p>
    User: <span sec:authentication="principal.username"></span>
    <br><br>
    Role(s): <span sec:authentication="principal.authorities"></span>
</p>

<hr>
<!-- Add a link to point to /leaders ... this is for the managers -->
<p>
    <a th:href="@{/leaders}">Leadership Meeting</a>
    (Only for Manager peeps)
</p>


<!-- Add a link to point to /systems ... this is for the admins -->

<p>
    <a th:href="@{/systems}">IT Systems Meeting</a>
    (Only for Admin peeps)
</p>


<hr>

<!-- Add a logout button -->
<form action="#" th:action="@{/logout}"
      method="POST">

    <input type="submit" value="Logout" class="btn btn-outline-primary mt-2" />

</form>


</body>

</html>
```

#### Custom Access Denied Page

**Development Process**
1. Configure custom page for access denied

```java
package com.luv2code.springboot.demosecurity.security;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class DemoSecurityConfig {

    @Bean
    public InMemoryUserDetailsManager userDetailsManager() {

        UserDetails john = User.builder()
                .username("john")
                .password("{noop}test123")
                .roles("EMPLOYEE")
                .build();

        UserDetails mary = User.builder()
                .username("mary")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER")
                .build();

        UserDetails susan = User.builder()
                .username("susan")
                .password("{noop}test123")
                .roles("EMPLOYEE", "MANAGER", "ADMIN")
                .build();

        return new InMemoryUserDetailsManager(john, mary, susan);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                        configurer
                                .requestMatchers("/").hasRole("EMPLOYEE")
                                .requestMatchers("/leaders/**").hasRole("MANAGER")
                                .requestMatchers("/systems/**").hasRole("ADMIN")
                                .anyRequest().authenticated()
                )
                .formLogin(form ->
                        form
                                .loginPage("/showMyLoginPage")
                                .loginProcessingUrl("/authenticateTheUser")
                                .permitAll()
                )
                .logout(logout -> logout.permitAll()
                ) // THIS IS THE NEW STUFF VVVVVVVVVVVVVVVVVVVVVVVVVV
                .exceptionHandling(configurer ->
                        configurer.accessDeniedPage("/access-denied")
                );

        return http.build();
    }

}
```

2. Create supporting controller code and view page

```java
package com.luv2code.springboot.demosecurity.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    @GetMapping("/showMyLoginPage")
    public String showMyLoginPage() {

        return "fancy-login";
    }

    // add request mapping for /access-denied

    @GetMapping("/access-denied")
    public String showAccessDenied() {

        return "access-denied";
    }

}
```

3. Create "`access-denied.html`" page

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>luv2code - Access Denied</title>
</head>
<body>

<h2>Access Denied - You are not authorized to access this resource.</h2>

<hr>

<a th:href="@{/}">Back to Home Page</a>

</body>
</html>
```

#### Display Content Based on Roles

The purpose of this section is to be able to display content in the HTML webpage that depends on the role of the user. There might be some parts of your webpage that you don't want to show to some users.

This modification needs to happen in the HTML file itself for that you need to include a new namespace at the "`html`" header that is called "`xmlns:sec="http://www.thymeleaf.org/extras/spring-security"`". 

This new namespace will open to a few methods such as the following ones:
* **Authorization & Access Control** ("`sec:authorize`", Used to conditionally display content based on user roles/permissions.)
    * "`hasRole('ROLE_NAME')`": Checks if the user has a specific role.
    * "`hasAnyRole('ROLE_1', 'ROLE_2')`": Checks if the user has at least one of the given roles.
    * "`hasAuthority('PERMISSION')`": Checks if the user has a specific permission.
    * "`hasAnyAuthority('PERM_1', 'PERM_2')`": Checks if the user has at least one of the given permissions.
    * "`isAuthenticated()`": Checks if the user is authenticated.
    * "`isAnonymous()`": Checks if the user is anonymous.
    * "`isRememberMe()`": Checks if the user is logged in using "remember me."
    * "`isFullyAuthenticated()`": Checks if the user is fully authenticated (not "remember me").
* **User Authentication & Principal Information** 
    * "`sec:authentication`": Displays specific details about the authenticated user.
        * "`name`": Gets the username of the authenticated user.
        * "`principal`": Accesses the principal object.
        * "`authorities`": Displays user roles/permissions.
    * "`sec:authorize-expr`": Allows for more flexible security expressions.

When we use the new namespace our Home Page will be modifed as follows.

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/extras/spring-security">

<head>
    <title>luv2code Company Home Page</title>
</head>

<body>
<h2>luv2code Company Home Page</h2>
<hr>

<p>
Welcome to the luv2code company home page!
</p>

<hr>

<!-- display user name and role(s) -->

<p>
    User: <span sec:authentication="principal.username"></span>
    <br><br>
    Role(s): <span sec:authentication="principal.authorities"></span>
</p>

<div sec:authorize="hasRole('MANAGER')">

    <!-- Add a link to point to /leaders ... this is for the managers -->
    <p>
        <a th:href="@{/leaders}">Leadership Meeting</a>
        (Only for Manager peeps)
    </p>

</div>

<div sec:authorize="hasRole('ADMIN')">

    <!-- Add a link to point to /systems ... this is for the admins -->

    <p>
        <a th:href="@{/systems}">IT Systems Meeting</a>
        (Only for Admin peeps)
    </p>

</div>

<hr>

<!-- Add a logout button -->
<form action="#" th:action="@{/logout}"
      method="POST">

    <input type="submit" value="Logout" class="btn btn-outline-primary mt-2" />

</form>


</body>

</html>
```

#### JDBC Authentication

**Development Process**
1. Develop SQL Script to set up database tables

```sql
USE `employee_directory`;

DROP TABLE IF EXISTS `authorities`;
DROP TABLE IF EXISTS `users`;

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `enabled` tinyint NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Inserting data for table `users`
--

INSERT INTO `users`
VALUES
('john','{noop}test123',1),
('mary','{noop}test123',1),
('susan','{noop}test123',1);


--
-- Table structure for table `authorities`
--

CREATE TABLE `authorities` (
  `username` varchar(50) NOT NULL,
  `authority` varchar(50) NOT NULL,
  UNIQUE KEY `authorities_idx_1` (`username`,`authority`),
  CONSTRAINT `authorities_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Inserting data for table `authorities`
--

INSERT INTO `authorities`
VALUES
('john','ROLE_EMPLOYEE'),
('mary','ROLE_EMPLOYEE'),
('mary','ROLE_MANAGER'),
('susan','ROLE_EMPLOYEE'),
('susan','ROLE_MANAGER'),
('susan','ROLE_ADMIN');
```

2. Add database support to Maven POM file

```xml
		<dependency>
			<groupId>com.mysql</groupId>
			<artifactId>mysql-connector-j</artifactId>
			<scope>runtime</scope>
		</dependency>
```

3. Create JDBC properties file

```properties
#
# JDBC Properties
#
spring.datasource.url=jdbc:mysql://localhost:3306/employee_directory
spring.datasource.username=springstudent
spring.datasource.password=springstudent

#
# Log JDBC SQL statements
#
# Only use this for dev/testing
# DO NOT use for PRODUCTION since it will log user names
logging.level.org.springframework.jdbc.core=TRACE
```

4. Update Spring Security Configuration to use JDBC

```java
package com.luv2code.springboot.demosecurity.security;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

import javax.sql.DataSource;

@Configuration
public class DemoSecurityConfig {

    // add support for JDBC ... no more hardcoded users :-)

    @Bean
    public UserDetailsManager userDetailsManager(DataSource dataSource) {

        return new JdbcUserDetailsManager(dataSource);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                        configurer
                                .requestMatchers("/").hasRole("EMPLOYEE")
                                .requestMatchers("/leaders/**").hasRole("MANAGER")
                                .requestMatchers("/systems/**").hasRole("ADMIN")
                                .anyRequest().authenticated()
                )
                .formLogin(form ->
                        form
                                .loginPage("/showMyLoginPage")
                                .loginProcessingUrl("/authenticateTheUser")
                                .permitAll()
                )
                .logout(logout -> logout.permitAll()
                )
                .exceptionHandling(configurer ->
                        configurer.accessDeniedPage("/access-denied")
                );

        return http.build();
    }

}
```

#### Spring Security with Custom Tables

By default Spring Security uses the following tables.

```sql
--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `username` varchar(50) NOT NULL,
  `password` char(68) NOT NULL,
  `enabled` tinyint NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `authorities`
--

CREATE TABLE `authorities` (
  `username` varchar(50) NOT NULL,
  `authority` varchar(50) NOT NULL,
  UNIQUE KEY `authorities4_idx_1` (`username`,`authority`),
  CONSTRAINT `authorities4_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

You MUST use the exact names for the tables and the columns of the tables.

You might have thought that this is a bit restrictive, which might be true.

You also might have thought, what if we have our own **custom tables** with our own **custom column names**?

**For Security Schema Customization**
* You need to tell Spring how to query your custom tables
* You need to provide a query to find user by user name
* You also need to provide a query to find authorities / roles by user name

**Development Process**
1. Create our custom tables with SQL

```sql
--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `user_id` varchar(50) NOT NULL,
  `pw` char(68) NOT NULL,
  `active` tinyint NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `authorities`
--

CREATE TABLE `roles` (
  `user_id` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL,
  UNIQUE KEY `authorities5_idx_1` (`user_id`,`role`),
  CONSTRAINT `authorities5_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `members` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

2. Update Spring Security Configuration
    * Provide query to find user by user name
    * Provide query to find authorities / roles by user name

```java
package com.luv2code.springboot.demosecurity.security;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

import javax.sql.DataSource;

@Configuration
public class DemoSecurityConfig {

    // add support for JDBC ... no more hardcoded users :-)

    @Bean
    public UserDetailsManager userDetailsManager(DataSource dataSource) {

        JdbcUserDetailsManager jdbcUserDetailsManager = new JdbcUserDetailsManager(dataSource);

        // define query to retrieve a user by username
        jdbcUserDetailsManager.setUsersByUsernameQuery(
                "select user_id, pw, active from members where user_id=?");

        // define query to retrieve the authorities/roles by username
        jdbcUserDetailsManager.setAuthoritiesByUsernameQuery(
                "select user_id, role from roles where user_id=?");

        return jdbcUserDetailsManager;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(configurer ->
                        configurer
                                .requestMatchers("/").hasRole("EMPLOYEE")
                                .requestMatchers("/leaders/**").hasRole("MANAGER")
                                .requestMatchers("/systems/**").hasRole("ADMIN")
                                .anyRequest().authenticated()
                )
                .formLogin(form ->
                        form
                                .loginPage("/showMyLoginPage")
                                .loginProcessingUrl("/authenticateTheUser")
                                .permitAll()
                )
                .logout(logout -> logout.permitAll()
                )
                .exceptionHandling(configurer ->
                        configurer.accessDeniedPage("/access-denied")
                );

        return http.build();
    }

}
```
