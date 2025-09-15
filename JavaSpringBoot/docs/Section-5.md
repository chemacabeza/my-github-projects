## Section 5: REST API Security

You will learn how to:
* Secure Spring Boot REST APIs
* Define users and roles
* Protect URLs based on role
* Store users, passwords and roles in DB (plain-text -> encrypted)

Practical results:
* Cover the most common Spring Security tasks that you will need on daily projects
* For a full overview of Spring Security please check this <a href="https://docs.spring.io/spring-security/reference/">link</a>.

Spring Security Model:
* Spring Security defines a framework for security
* Implemented using Servlet filters in the background
* Two methods of securing an app: declarative and programmatic

Spring Security with Servlet Filters:
* Servlet Filters are used to pre-process / post-process web requests
* Servlet Filters can route web requests based on security logic
* Spring provides a bulk of security functionality with servlet filters

**Security Concepts**
* Authentication
    * Check user id and password with credentials stored in app / db
* Authorization
    * Check to see if user has an authorized role

**Declarative Security**
* Define application's security constraints in configuration
    * All Java config: "`@Configuration`"
* Provides separation of concerns between application code and security

**Programmatic Security**
* Spring Security provides an API for custom application coding
* Provides greater customization for specific app requirements

**Enabling Spring Security**
1. Edit "`pom.xml`" and add "`spring-boot-starter-security`"

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

2. This will automagically secure all endpoints for application

### Basic Configuration

Our users will be:

| User ID | Password | Roles |
| :---: | :--- | :--- |
| `john` | `test123` | `EMPLOYEE` |
| `mary` | `test123` | `EMPLOYEE, MANAGER` |
| `susan` | `test123` | `EMPLOYEE, MANAGER, ADMIN` |

The roles can be ANYTHING.

**Development Process**
1. Create Spring Security Configuration ("`@Configuration`")

```java
import org.springframework,context.annotation.Configuration;

@Configuration
public class DemoSecurityConfig {
    // add our security configuration here ...
}
```

2. Add users, passwords and roles

**Spring Security Password Storage**
* In Spring Security, passwords are stored using a specific format: "`{id}encodedPassword`"
    * The "`{id}`" is the encoding algorithm being used
    * The "`encodedPassword`" is the plain text password after being processed with the enconding algorithm.

Table with options of "`{id}`":

| ID | Description |
| :---: | :--- |
| `noop` | Plain text passwords |
| `bcrypt` | Bcrypt password hashing |
| ... | ... | 

Password example:
* "`{noop}test123`"


```java
package com.luv2code.springboot.cruddemo.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;

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
}
```

Since we are creating our users in this previous class Spring will NOT user the user/password from the "`applications.properties`" file.


**Our Example**

| HTTP Method | Endpoint | CRUD Action | Role |
| :----: | :---- | :---- | :---- |
| `GET` | `/api/employees` | Read all | `EMPLOYEE` |
| `GET` | `/api/employees/{employeeId}` | Read single | `EMPLOYEE` |
| `POST` | `/api/employees` | Create | `MANAGER` |
| `PUT` | `/api/employees` | Update | `MANAGER` |
| `DELETE` | `/api/employees/{employeeId}` | Delete employee | `ADMIN` |

**Restricting access to Roles**

* General syntax

```java
requestMatchers("<< add path to match on >>")
       .hasRole("<< authorized role >>")
```

or 


```java
requestMatchers("<< add HTTP METHOD to match on >>", "<< add path to match on >>")
       .hasRole("<< authorized role >>")
```

or 


```java
requestMatchers("<< add HTTP METHOD to match on >>", "<< add path to match on >>")
       .hasAnyRole("<< list of comma-delimited authorized roles >>")
```

The final solution for our previous table would be like follows:

```java
package com.luv2code.springboot.cruddemo.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
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
                        .requestMatchers(HttpMethod.GET, "/api/employees").hasRole("EMPLOYEE")
                        .requestMatchers(HttpMethod.GET, "/api/employees/**").hasRole("EMPLOYEE")
                        .requestMatchers(HttpMethod.POST, "/api/employees").hasRole("MANAGER")
                        .requestMatchers(HttpMethod.PUT, "/api/employees").hasRole("MANAGER")
                        .requestMatchers(HttpMethod.DELETE, "/api/employees/**").hasRole("ADMIN")
        );

        // use HTTP Basic authentication
        http.httpBasic(Customizer.withDefaults());

        // disable Cross Site Request Forgery (CSRF)
        // in general, not required for stateless REST APIs that use POST, PUT, DELETE and/or PATCH
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }
}
```

### Spring Security: User Accounts Stored in Database

**Database Access**
* So far, our user accounts were hard coded in Java source code.
* We want to add database acces.
* Spring Security can read user account info from database
* By default, you have to follow Spring Security's predefined table schemas
    * There is a very little Java code you need to write.
* Can also customize the table schemas
* Useful if you have custom tables specific to your project / custom
* You will be responsible for developing the code to access the data
    * JDBC, JPA/Hibernate etc...
* Follow Spring Security's predefined table schemas

**Development Process**
1. Develop SQL Script to set up database tables
2. Add database support to Maven POM file
3. Create JDBC properties file
4. Update Spring Security Configuration to use JDBC

By default, Spring Security requires two tables which are "`users`" and "`authorities`".

The SQL Script to create these 2 tables in a MySQL database is:

```sql
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

Pay attention that you HAVE to prefix the roles with "`ROLE_`".

**Password Storage - Best Practice**
* The best practice is to store passwords in an encrypted format

**Spring Security Team Recommendation**
* Spring Security recommends using the popular "`bcrypt`" algorithm
* "`bcrypt`"
    * Performs one-way encrypted hashing
    * Adds a random salt to the password for additional protection
    * Includes support to defeat brute force attacks

**Bcrypt Additional Information**
* <a href="https://danboterhoven.medium.com/why-you-should-use-bcrypt-to-hash-passwords-af330100b861">Why you should use bcrypt to hash passwords</a>
* <a href="https://en.wikipedia.org/wiki/Bcrypt">Detailed bcrypt algorithm analysis</a>
* <a href="https://crackstation.net/hashing-security.htm">Password hashing - Best Practices</a>

**Development Process**
1. Run SQL Script that contains encrypted passwords
    * Modify DDL for password field, length should be 68
2. And that's it!

### Spring Security Custom Tables

**Custom Tables**
* What if we have our own custom tables?
* Our own custom column names?

**For Security Schema Customization**
* Tell Spring how to query your custom tables
* Provide query to find user by user name
* Provide query to find authorities / roles by user name

**Development Process**
1. Create our custom tables with SQL
2. Update Spring Security Configuration
    * Provide query to find user by user name
    * Provide query to find authorities / roles by user name

For example:

```java
package com.luv2code.springboot.cruddemo.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
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
                        .requestMatchers(HttpMethod.GET, "/api/employees").hasRole("EMPLOYEE")
                        .requestMatchers(HttpMethod.GET, "/api/employees/**").hasRole("EMPLOYEE")
                        .requestMatchers(HttpMethod.POST, "/api/employees").hasRole("MANAGER")
                        .requestMatchers(HttpMethod.PUT, "/api/employees").hasRole("MANAGER")
                        .requestMatchers(HttpMethod.DELETE, "/api/employees/**").hasRole("ADMIN")
        );

        // use HTTP Basic authentication
        http.httpBasic(Customizer.withDefaults());

        // disable Cross Site Request Forgery (CSRF)
        // in general, not required for stateless REST APIs that use POST, PUT, DELETE and/or PATCH
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }
}
```

