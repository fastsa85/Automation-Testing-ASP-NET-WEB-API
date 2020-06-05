Feature: Comments
	In order to perform actions with Comments
	As Tweetbook user
	I want to list, create, edit and delete comments

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
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-61a4-4714-b6cd-1b1dae19bdec	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-61a4-4714-b6cd-1b1dae19bdec	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.		| 
	| 33333333-61a4-4714-b6cd-1b1dae19bdec | 00000000-c97d-46e3-a3c9-6c4fd63cef9e | 22222222-61a4-4714-b6cd-1b1dae19bdec	| Et odio pellentesque diam volutpat commodo.								| 
	| 44444444-61a4-4714-b6cd-1b1dae19bdec | 00000000-37fc-4f48-834d-f95608414c7f | 22222222-61a4-4714-b6cd-1b1dae19bdec	| Nullam eget felis eget nunc lobortis mattis.								| 
	| 55555555-61a4-4714-b6cd-1b1dae19bdec | 11111111-37fc-4f48-834d-f95608414c7f | 33333333-61a4-4714-b6cd-1b1dae19bdec	| Lectus urna duis convallis convallis tellus id interdum.					| 


Scenario: User can create new comments, update and delete his comments
	When Login as
	| Email				| Password	|
	| JohnDoe@mail.com	| Dummy#123	|	
	When Create new "Comment" object
	| PostId								| CommentContent				| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| .NET Core fully supports C#	|
	Then Assert get all "Comment" returns list of objects	
	| CommentContent																| PostId                               |
	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod		| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.			| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Et odio pellentesque diam volutpat commodo.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Nullam eget felis eget nunc lobortis mattis.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Lectus urna duis convallis convallis tellus id interdum.						| 33333333-61a4-4714-b6cd-1b1dae19bdec |
	| .NET Core fully supports C#													| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	When Update "Comment" object where "CommentContent" is ".NET Core fully supports C#"
	| CommentContent																| 
	| .NET Core fully supports C# and F# and partially supports Visual Basic .NET.	|
	Then Assert get all "Comment" returns list of objects	
	| CommentContent																| PostId                               |
	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod		| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.			| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Et odio pellentesque diam volutpat commodo.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Nullam eget felis eget nunc lobortis mattis.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Lectus urna duis convallis convallis tellus id interdum.						| 33333333-61a4-4714-b6cd-1b1dae19bdec |
	| .NET Core fully supports C# and F# and partially supports Visual Basic .NET.	| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	When Delete "Comment" object where "CommentContent" is ".NET Core fully supports C# and F# and partially supports Visual Basic .NET."
	Then Assert get all "Comment" returns list of objects	
	| CommentContent																| PostId                               |
	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod		| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.			| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Et odio pellentesque diam volutpat commodo.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Nullam eget felis eget nunc lobortis mattis.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Lectus urna duis convallis convallis tellus id interdum.						| 33333333-61a4-4714-b6cd-1b1dae19bdec |
	

Scenario: User can not delete or update not his comments
	When Login as
	| Email				| Password	|
	| JohnDoe@mail.com	| Dummy#123	|	
	When Create new "Comment" object
	| PostId								| CommentContent				| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| .NET Core fully supports C#	|
	When Login as
	| Email				| Password		|
	| JackSmith@box.com | qwerTy!098	|
	Then Assert get all "Comment" returns list of objects	
	| CommentContent																| PostId                               |
	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod		| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.			| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Et odio pellentesque diam volutpat commodo.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Nullam eget felis eget nunc lobortis mattis.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Lectus urna duis convallis convallis tellus id interdum.						| 33333333-61a4-4714-b6cd-1b1dae19bdec |
	| .NET Core fully supports C#													| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	When Update "Comment" object where "CommentContent" is ".NET Core fully supports C#"
	| CommentContent										| 
	| Trying to update not my post! Should not be allowed	|
	Then Assert get all "Comment" returns list of objects	
	| CommentContent																| PostId                               |
	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod		| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.			| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Et odio pellentesque diam volutpat commodo.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Nullam eget felis eget nunc lobortis mattis.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Lectus urna duis convallis convallis tellus id interdum.						| 33333333-61a4-4714-b6cd-1b1dae19bdec |
	| .NET Core fully supports C#													| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	When Delete "Comment" object where "CommentContent" is ".NET Core fully supports C#"
	Then Assert get all "Comment" returns list of objects	
	| CommentContent																| PostId                               |
	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod		| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.			| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| Et odio pellentesque diam volutpat commodo.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Nullam eget felis eget nunc lobortis mattis.									| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	| Lectus urna duis convallis convallis tellus id interdum.						| 33333333-61a4-4714-b6cd-1b1dae19bdec |
	| .NET Core fully supports C#													| 22222222-61a4-4714-b6cd-1b1dae19bdec |