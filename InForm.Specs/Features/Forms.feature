﻿Feature: Forms

A short summary of the feature



@existingform
Scenario: Getting an existing form
	Given the form with guid
	When the client requests the form with guid
	Then the client receives the form with guid

@nonexistingform
Scenario: Getting a non-existing form
	Given A form does not exist with the guid
	When I request the form with the guid
	Then I should get a 404 response

@existingformsname
Scenario: Getting an existing form's name
	Given the form with guid
	When the client requests the form's name with guid
	Then the client receives the form's name with guid

@nonexistingformsname
Scenario: Getting nonextistant form's name
	Given A form does not exist with the guid
	When the client requests the form's name with guid
	Then I should get a 404 response

@creatingform
Scenario: Creating a form
	Given I have a form with the following attributes:
		| title | subtitle | elementTitle | elementSubtitle | required | multiline | elementMaxLength |
		| form1 | form1 subtitle | element1 | element1 subtitle | true | true | 100 |
	When I create the form
	Then I should get a CreatedStatusCode and form should have a guid


#private CreateFormRequest makeCreateFormRequest(string title,string subtitle,string elementTitle
#												string elementSubtitle, bool required, bool multiline, int elementMaxLength)