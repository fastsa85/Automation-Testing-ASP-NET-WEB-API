Feature: Posts
	In order to perform actions with Posts
	As Tweetbook user
	I want to list, create, edit and delete posts

Background:
	Given Register Users
	| Email             | Password   |
	| JohnDoe@mail.com  | Dummy#123  |
	| JackSmith@box.com | qwerTy!098 |
	Given "Post" records exist in database
	| Id									| PostTitle		| PostContent													| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Post One		| Lorem ipsum dolor sit amet, consectetur adipiscing elit		| 11111111-c97d-46e3-a3c9-6c4fd63cef9e	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| Post Two		| Lectus urna duis convallis convallis tellus id interdum.		| 22222222-1111-46e3-a3c9-6c4fd63cef9e	|
	| 33333333-61a4-4714-b6cd-1b1dae19bdec	| Post Three	| Diam quam nulla porttitor massa id neque aliquam vestibulum.	| 22222222-1111-46e3-a3c9-6c4fd63cef9e	|
	| 44444444-61a4-4714-b6cd-1b1dae19bdec	| Post Four		| Parturient montes nascetur ridiculus mus mauris.				| 33333333-1111-46e3-a3c9-6c4fd63cef9e	|

Scenario: User can create new post, update and delete his posts
	When Login as
	| Email				| Password	|
	| JohnDoe@mail.com	| Dummy#123	|
	Then Assert get all "Post" returns list of objects	
	| PostTitle		| PostContent													|	
	| Post One		| Lorem ipsum dolor sit amet, consectetur adipiscing elit		|
	| Post Two		| Lectus urna duis convallis convallis tellus id interdum.		|
	| Post Three	| Diam quam nulla porttitor massa id neque aliquam vestibulum.	|
	| Post Four		| Parturient montes nascetur ridiculus mus mauris.				|
	When Create new "Post" object
	| PostTitle		| PostContent																										| 
	| My New Post	| .NET is a free, cross-platform, open source developer platform for building many different types of applications.	|
	Then Assert get all "Post" returns list of objects	
	| PostTitle		| PostContent																										| 
	| Post One		| Lorem ipsum dolor sit amet, consectetur adipiscing elit															| 
	| Post Two		| Lectus urna duis convallis convallis tellus id interdum.															|
	| Post Three	| Diam quam nulla porttitor massa id neque aliquam vestibulum.														| 
	| Post Four		| Parturient montes nascetur ridiculus mus mauris.																	| 
	| My New Post	| .NET is a free, cross-platform, open source developer platform for building many different types of applications.	|
	When Update "Post" object where "PostTitle" is "My New Post"
	| PostTitle		| PostContent																										| 
	| Updated! Post	| ASP stands for Active Server Pages. ASP is a development framework for building web pages.						|
	Then Assert get all "Post" returns list of objects	
	| PostTitle		| PostContent																										| 
	| Post One		| Lorem ipsum dolor sit amet, consectetur adipiscing elit															| 
	| Post Two		| Lectus urna duis convallis convallis tellus id interdum.															|
	| Post Three	| Diam quam nulla porttitor massa id neque aliquam vestibulum.														| 
	| Post Four		| Parturient montes nascetur ridiculus mus mauris.																	| 
	| Updated! Post	| ASP stands for Active Server Pages. ASP is a development framework for building web pages.						|
	When Delete "Post" object where "PostTitle" is "Updated! Post"
	Then Assert get all "Post" returns list of objects	
	| PostTitle		| PostContent																										| 
	| Post One		| Lorem ipsum dolor sit amet, consectetur adipiscing elit															| 
	| Post Two		| Lectus urna duis convallis convallis tellus id interdum.															|
	| Post Three	| Diam quam nulla porttitor massa id neque aliquam vestibulum.														| 
	| Post Four		| Parturient montes nascetur ridiculus mus mauris.																	| 


Scenario: User can not delete or update not his posts
	When Login as
	| Email				| Password		|
	| JackSmith@box.com | qwerTy!098	|
	When Create new "Post" object
	| PostTitle			| PostContent														| 
	| Post of JackSmith	| .NET is a free, cross-platform, open source developer platform	|
	Then Assert get all "Post" returns list of objects	
	| PostTitle			| PostContent														|	
	| Post One			| Lorem ipsum dolor sit amet, consectetur adipiscing elit			|
	| Post Two			| Lectus urna duis convallis convallis tellus id interdum.			|
	| Post Three		| Diam quam nulla porttitor massa id neque aliquam vestibulum.		|
	| Post Four			| Parturient montes nascetur ridiculus mus mauris.					|
	| Post of JackSmith	| .NET is a free, cross-platform, open source developer platform	|
	When Login as
	| Email				| Password	|
	| JohnDoe@mail.com	| Dummy#123	|
	When Update "Post" object where "PostTitle" is "Post of JackSmith"
	| PostTitle								| PostContent														| 
	| Trying To Update Post of JackSmith	| This update should not be success as Post relates to other user	|
	Then Assert get all "Post" returns list of objects	
	| PostTitle			| PostContent														| 
	| Post One			| Lorem ipsum dolor sit amet, consectetur adipiscing elit			| 
	| Post Two			| Lectus urna duis convallis convallis tellus id interdum.			|
	| Post Three		| Diam quam nulla porttitor massa id neque aliquam vestibulum.		| 
	| Post Four			| Parturient montes nascetur ridiculus mus mauris.					| 
	| Post of JackSmith	| .NET is a free, cross-platform, open source developer platform	|
	When Delete "Post" object where "PostTitle" is "Post One"
	Then Assert get all "Post" returns list of objects	
	| PostTitle			| PostContent														| 
	| Post One			| Lorem ipsum dolor sit amet, consectetur adipiscing elit			| 
	| Post Two			| Lectus urna duis convallis convallis tellus id interdum.			|
	| Post Three		| Diam quam nulla porttitor massa id neque aliquam vestibulum.		| 
	| Post Four			| Parturient montes nascetur ridiculus mus mauris.					| 
	| Post of JackSmith	| .NET is a free, cross-platform, open source developer platform	|