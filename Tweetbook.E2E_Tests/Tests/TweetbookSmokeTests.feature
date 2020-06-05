Feature: Tweetbook Smoke Tests


Background: 
	Given Register user
	| Email             | Password	|
	| tester_1@mail.com | Dummy#123	|
	Given Register user
	| Email             | Password		|
	| tester_2@mail.com | Dummy#123		|

Scenario: Tweetbook basic actions
	Given Login as
	| Email             | Password		|
	| tester_1@mail.com | Dummy#123		|
		