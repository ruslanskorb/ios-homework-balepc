[![Build Status](https://travis-ci.org/ruslanskorb/ios-homework-balepc.svg)](https://travis-ci.org/ruslanskorb/ios-homework-balepc)

### Problem definition
Create a prototype iOS application to meet the following business requirements:

- Application should have two screens:
	- list of books;
	- feedback form for a chosen book;
- List of books should be formed based on the API call http://54.152.155.201/books.json
- Book feedback form should consist of two fields: **name**, **comment**
	- There should be a validation before sending data
		- name should be present
		- comment should be present and have more than 100 characters
	- Form should be sent to (POST) http://54.152.155.201/book/:book_id

### Technical requirements
You have total control over framework and tools, as long as application is written in ObjectiveC/Swift. 

### What gets evaluated

- Conformance to business requirements;
- Code quality, tests presence;
- Conformance to iOS best practices;
- Easy UI/UX;

**Good luck and have fun!**
