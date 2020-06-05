Feature: Comments Controller
	In order to execute basic CRUD operations with Comments
	As Tweetbook developer
	I want to have /comments endpoint 

Background: 	
	Given "IdentityUser" records exist in database
	| Id                                   | UserName      | NormalizedUserName | Email                | NormalizedEmail | EmailConfirmed | PasswordHash                                                                         | SecurityStamp                    | ConcurrencyStamp                     | PhoneNumberConfirmed | TwoFactorEnabled | LockoutEnabled | AccessFailedCount |
	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e | user@mail.com | USER@MAIL.COM      | user_poster@mail.com | USER@MAIL.COM   | False          | AQAAAAEAACcQAAAAEE3O6wFKAY2CL9jx4QvTk+XnPRE419lmYlyvs7Fffu5T5pspM2z3/RCo3D6IsnyfDQ== | DYER7IXAG6MD244BVFN5ETREGHYX6GSP | fe4b708e-e301-4056-8acc-4144dc8c285e | False                | False            | True           | 0                 |


Scenario: Create comment to NOT user's post when other comments exist for the same post
	Given "Post" records exist in database
	| Id                                   | UserId                               | PostTitle			| PostContent																		| 
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | My First Post		| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 99999999-c97d-46e3-a3c9-6c4fd63cef9e | My Second Post		| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.				| 	
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-61a4-4714-b6cd-1b1dae19bdec	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-61a4-4714-b6cd-1b1dae19bdec	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.		| 
	| 33333333-61a4-4714-b6cd-1b1dae19bdec | 00000000-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-61a4-4714-b6cd-1b1dae19bdec	| Et odio pellentesque diam volutpat commodo.								| 
	| 44444444-61a4-4714-b6cd-1b1dae19bdec | 00000000-37fc-4f48-834d-f95608414c7f | 11111111-61a4-4714-b6cd-1b1dae19bdec	| Nullam eget felis eget nunc lobortis mattis.								| 
	| 55555555-61a4-4714-b6cd-1b1dae19bdec | 11111111-37fc-4f48-834d-f95608414c7f | 11111111-61a4-4714-b6cd-1b1dae19bdec	| Lectus urna duis convallis convallis tellus id interdum.					| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	  
	  "CommentContent": "Nullam eget felis eget?",
	  "PostId": "11111111-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "Created"	
	Then Assert Body of Response from "Post" "api/v1/comments" contains property "id" as valid GUID 
	Then Assert Body of Response from "Post" "api/v1/comments" contains object, ignoring properties "id"
	"""
	{	
	  "id": "some guid, value is ignored in this test case",	  
	  "commentContent": "Nullam eget felis eget?",
	  "postId": "11111111-61a4-4714-b6cd-1b1dae19bdec",
	  "userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	}
	"""	
	Then Assert "Comment" records exist in database
	| CommentContent          | UserId                               | PostId                               |
	| Nullam eget felis eget? | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-61a4-4714-b6cd-1b1dae19bdec |


Scenario: Create new comment to NOT user's post when other comments do not exist for the same post
	Given "Post" records exist in database
	| Id                                   | UserId                               | PostTitle			| PostContent																		| 
	| c913181d-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | My First Post		| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| 	
	| 33333333-61a4-4714-b6cd-1b1dae19bdec | 22222222-c97d-46e3-a3c9-6c4fd63cef9e | Other user's Post	| Lectus urna duis convallis convallis tellus id interdum.							| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	  
	  "CommentContent": "Nullam eget felis eget nunc lobortis mattis!",
	  "PostId": "33333333-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "Created"	
	Then Assert Body of Response from "Post" "api/v1/comments" contains property "id" as valid GUID 
	Then Assert Body of Response from "Post" "api/v1/comments" contains object, ignoring properties "id"
	"""
	{	
	  "id": "some guid, value is ignored in this test case",	  
	  "commentContent": "Nullam eget felis eget nunc lobortis mattis!",
	  "postId": "33333333-61a4-4714-b6cd-1b1dae19bdec",
	  "userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	}
	"""	
	Then Assert "Comment" records exist in database
	| CommentContent                               | UserId                               | PostId                               |
	| Nullam eget felis eget nunc lobortis mattis! | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 33333333-61a4-4714-b6cd-1b1dae19bdec |


Scenario: Creates comment to user's post
	Given "Post" records exist in database
	| Id                                   | UserId                               | PostTitle			| PostContent																		| 
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | My First Post		| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e |My Second Post		| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.				| 
	| 33333333-61a4-4714-b6cd-1b1dae19bdec | 12345678-c97d-46e3-a3c9-6c4fd63cef9e | Other user's Post	| Lectus urna duis convallis convallis tellus id interdum.							| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	  
	  "CommentContent": "Nullam eget felis eget nunc lobortis mattis!",
	  "PostId": "11111111-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "Created"	
	Then Assert Body of Response from "Post" "api/v1/comments" contains property "id" as valid GUID 
	Then Assert Body of Response from "Post" "api/v1/comments" contains object, ignoring properties "id"
	"""
	{	
	  "id": "some guid, value is ignored in this test case",	  
	  "commentContent": "Nullam eget felis eget nunc lobortis mattis!",
	  "postId": "11111111-61a4-4714-b6cd-1b1dae19bdec",
	  "userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	}
	"""		
	Then Assert "Comment" records exist in database
	| CommentContent                               | UserId                               | PostId                               |
	| Nullam eget felis eget nunc lobortis mattis! | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-61a4-4714-b6cd-1b1dae19bdec |


Scenario: Create comment to NOT existed post
	Given "Post" records exist in database
	| Id                                   | UserId                               | PostTitle			| PostContent																		| 
	| c913181d-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | My First Post		| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| 
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | 11111111-c97d-46e3-a3c9-6c4fd63cef9e | My Second Post		| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.				| 
	| 33333333-61a4-4714-b6cd-1b1dae19bdec | 22222222-c97d-46e3-a3c9-6c4fd63cef9e | Other user's Post	| Lectus urna duis convallis convallis tellus id interdum.							| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	  
	  "CommentContent": "Nullam eget felis eget nunc lobortis mattis!",
	  "PostId": "12345678-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "BadRequest"
	Then Assert Body of Response from "Post" "api/v1/comments" contains object
	"""	
	{
		"error": "Post with Id 12345678-61a4-4714-b6cd-1b1dae19bdec does not exist"
	}
	"""	
	Then Assert "Comment" records do not exist in database
	| CommentContent                               | UserId                               | PostId                               |
	| Nullam eget felis eget nunc lobortis mattis! | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 12345678-61a4-4714-b6cd-1b1dae19bdec |


Scenario: Create comment when any post exists
	Given "Post" records exist in database
	| Id	| UserId	| PostTitle	| PostContent	| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	  
	  "CommentContent": "Nullam eget felis eget nunc lobortis mattis!",
	  "PostId": "12345678-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "BadRequest"
	Then Assert Body of Response from "Post" "api/v1/comments" contains object
	"""	
	{
		"error": "Post with Id 12345678-61a4-4714-b6cd-1b1dae19bdec does not exist"
	}
	"""	
	Then Assert "Comment" records do not exist in database
	| CommentContent                               | UserId                               | PostId                               |
	| Nullam eget felis eget nunc lobortis mattis! | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 12345678-61a4-4714-b6cd-1b1dae19bdec |


Scenario: Create comment without PostId
	Given "Post" records exist in database
	| Id									| UserId								| PostTitle			| PostContent																		|
	| c913181d-61a4-4714-b6cd-1b1dae19bdec	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	| My First Post		| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	  
	  "CommentContent": "Nullam eget felis eget nunc lobortis mattis!"	  
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "BadRequest"
	Then Assert Body of Response from "Post" "api/v1/comments" contains object
	"""	
	{
	"PostId": 
		[
			"The PostId field is required."
		]
	}
	"""
	Then Assert "Comment" records do not exist in database
	| CommentContent                               | 
	| Nullam eget felis eget nunc lobortis mattis! | 


	Scenario: Create comment with empty PostId
	Given "Post" records exist in database
	| Id									| UserId								| PostTitle			| PostContent																		|
	| c913181d-61a4-4714-b6cd-1b1dae19bdec	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	| My First Post		| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	  
	  "CommentContent": "Nullam eget felis eget nunc lobortis mattis!",
	  "PostId": ""
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "BadRequest"
	Then Assert Body of Response from "Post" "api/v1/comments" contains object
	"""	
	{
	"PostId": 
		[
			"The PostId field is required."
		]
	}
	"""
	Then Assert "Comment" records do not exist in database
	| CommentContent                               | 
	| Nullam eget felis eget nunc lobortis mattis! | 
	
	
Scenario: Create comment without Content
	Given "Post" records exist in database
	| Id									| UserId								| PostTitle			| PostContent																		|
	| c913181d-61a4-4714-b6cd-1b1dae19bdec	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	| My First Post		| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	
		"PostId": "c913181d-61a4-4714-b6cd-1b1dae19bdec"			  
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "BadRequest"
	Then Assert Body of Response from "Post" "api/v1/comments" contains object
	"""	
	{
	"CommentContent": 
		[
			"The CommentContent field is required."
		]
	}
	"""
	Then Assert "Comment" records do not exist in database
	| UserId                               | 
	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 


Scenario: Create comment with empty Content
	Given "Post" records exist in database
	| Id									| UserId								| PostTitle			| PostContent																		|
	| c913181d-61a4-4714-b6cd-1b1dae19bdec	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	| My First Post		| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/comments"
	"""
	{	
		"PostId": "c913181d-61a4-4714-b6cd-1b1dae19bdec",
		"CommentContent": ""
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/comments" is "BadRequest"
	Then Assert Body of Response from "Post" "api/v1/comments" contains object
	"""	
	{
	"CommentContent": 
		[
			"The CommentContent field is required."
		]
	}
	"""
	Then Assert "Comment" records do not exist in database
	| UserId                               | 
	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 


Scenario: Get all comments when comments exist	
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 0831f94b-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 0831f94b-4db5-4758-bbd6-3a7dbd9792ee	| Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.		| 
	| 33333333-61a4-4714-b6cd-1b1dae19bdec | 00000000-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Et odio pellentesque diam volutpat commodo.								| 
	| 44444444-61a4-4714-b6cd-1b1dae19bdec | 00000000-37fc-4f48-834d-f95608414c7f | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Nullam eget felis eget nunc lobortis mattis.								| 
	| 55555555-61a4-4714-b6cd-1b1dae19bdec | 11111111-37fc-4f48-834d-f95608414c7f | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Lectus urna duis convallis convallis tellus id interdum.					| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/comments"	
	"""
	"""
	Then Assert Status Code of Response from "Get" "api/v1/comments" is "OK"	
	Then Assert Body of Response from "Get" "api/v1/comments" contains object
	"""
	[
	  {
		"id": "11111111-61a4-4714-b6cd-1b1dae19bdec",
		"commentContent": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
		"postId": "0831f94b-4db5-4758-bbd6-3a7dbd9792ee",
		"userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	  },
	  {
		"id": "22222222-61a4-4714-b6cd-1b1dae19bdec",
		"commentContent": "Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.",
		"postId": "0831f94b-4db5-4758-bbd6-3a7dbd9792ee",
		"userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	  },
	  {
		"id": "33333333-61a4-4714-b6cd-1b1dae19bdec",
		"commentContent": "Et odio pellentesque diam volutpat commodo.",
		"postId": "11111111-4db5-4758-bbd6-3a7dbd9792ee",
		"userId": "00000000-c97d-46e3-a3c9-6c4fd63cef9e"
	  },
	  {
		"id": "44444444-61a4-4714-b6cd-1b1dae19bdec",
		"commentContent": "Nullam eget felis eget nunc lobortis mattis.",
		"postId": "11111111-4db5-4758-bbd6-3a7dbd9792ee",
		"userId": "00000000-37fc-4f48-834d-f95608414c7f"
	  },
	  {
		"id": "55555555-61a4-4714-b6cd-1b1dae19bdec",
		"commentContent": "Lectus urna duis convallis convallis tellus id interdum.",
		"postId": "22222222-4db5-4758-bbd6-3a7dbd9792ee",
		"userId": "11111111-37fc-4f48-834d-f95608414c7f"
	  }
	]
	"""	


Scenario: Get all comments when comments do not exist	
	Given "Comment" records exist in database
	| Id	| UserId	| PostId	| CommentContent	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/comments"	
	"""
	"""
	Then Assert Status Code of Response from "Get" "api/v1/comments" is "OK"	
	Then Assert Body of Response from "Get" "api/v1/comments" contains object
	"""
	[	  
	]
	"""	


Scenario: User gets his existed comment by id
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	"""
	Then Assert Status Code of Response from "Get" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" is "OK"
	Then Assert Body of Response from "Get" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "id": "11111111-61a4-4714-b6cd-1b1dae19bdec",	  
	  "commentContent": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
	  "postId": "11111111-4db5-4758-bbd6-3a7dbd9792ee",
	  "userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	}
	"""		


Scenario: User gets NOT his existed comment by id
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	"""
	Then Assert Status Code of Response from "Get" "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec" is "OK"
	Then Assert Body of Response from "Get" "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "id": "22222222-61a4-4714-b6cd-1b1dae19bdec",	  
	  "commentContent": "Quis nostrum exercitationem ullam corporis suscipit laboriosam",
	  "postId": "22222222-4db5-4758-bbd6-3a7dbd9792ee",
	  "userId": "12345678-qwer-1234-asdf-6c4fd63cef9e"
	}
	"""	


Scenario: Get comment when id does not exist
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec"	
	"""	
	"""
	Then Assert Status Code of Response from "Get" "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec" is "NotFound"
	Then Assert Body of Response from "Get" "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec" is empty


Scenario: Get comment by id when any comment exists	
	Given "Comment" records exist in database
	| Id	| UserId	| PostId	| CommentContent	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec"	
	"""	
	"""
	Then Assert Status Code of Response from "Get" "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec" is "NotFound"
	Then Assert Body of Response from "Get" "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec" is empty


Scenario: User updates his existed comment
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{	  
	  "CommentContent": "Updated Comment Content"
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" is "OK"
	Then Assert Body of Response from "Put" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "id": "11111111-61a4-4714-b6cd-1b1dae19bdec",	  
	  "commentContent": "Updated Comment Content",
	  "postId": "11111111-4db5-4758-bbd6-3a7dbd9792ee",
	  "userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	}
	"""	
	Then Reload from database all "Comment" records by properties	
	| Id									|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	Then Assert "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Updated Comment Content													| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 


Scenario: User tries to update NOT his but existed comment
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{	  
	  "CommentContent": "Updated Comment Content!!!"
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "error": "User can not update comment 22222222-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""	
	Then Reload from database all "Comment" records by properties	
	| Id                                   |
	| 11111111-61a4-4714-b6cd-1b1dae19bdec |
	| 22222222-61a4-4714-b6cd-1b1dae19bdec |
	Then Assert "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	

Scenario: User tries to update not existed comment
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 22222222-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{	  
	  "CommentContent": "Updated Comment Content!!!"
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "error": "User can not update comment 33333333-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""	
	Then Assert "Comment" records do not exist in database
	| Id                                   | 
	| 33333333-61a4-4714-b6cd-1b1dae19bdec | 


Scenario: User tries to update comment when any comment exists
	Given "Comment" records exist in database
	| Id | UserId  | PostId	| CommentContent |
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/comments/00000000-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{	  
	  "CommentContent": "Updated Comment Content!!!"
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/comments/00000000-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/comments/00000000-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "error": "User can not update comment 00000000-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""	
	Then Assert "Comment" records do not exist in database
	| Id                                   | 
	| 00000000-61a4-4714-b6cd-1b1dae19bdec | 


	Scenario: User tries to update comment without comment content
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""	
	{
	"CommentContent": 
		[
			"The CommentContent field is required."
		]
	}
	"""
	Then Reload from database all "Comment" records by properties	
	| Id                                   |
	| 11111111-61a4-4714-b6cd-1b1dae19bdec |	
	Then Assert "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	


Scenario: User tries to update comment with empty comment content
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{
		"CommentContent": ""
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""	
	{
	"CommentContent": 
		[
			"The CommentContent field is required."
		]
	}
	"""
	Then Reload from database all "Comment" records by properties	
	| Id                                   |
	| 11111111-61a4-4714-b6cd-1b1dae19bdec |	
	Then Assert "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	


Scenario: User deletes his existed comment
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Delete" requst to "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""	
	"""
	Then Assert Status Code of Response from "Delete" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" is "NoContent"
	Then Assert Body of Response from "Delete" "api/v1/comments/11111111-61a4-4714-b6cd-1b1dae19bdec" is empty	
	Then Assert "Comment" records do not exist in database
	| Id                                   | 
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | 
	

Scenario: User tries to delete NOT his but existed comment
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Delete" requst to "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec"	
	"""	
	"""
	Then Assert Status Code of Response from "Delete" "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Delete" "api/v1/comments/22222222-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""	
	{
		"error": "User can not delete comment 22222222-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""
	Then Assert "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	

Scenario: User tries to delete NOT existed comment
	Given "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Delete" requst to "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec"	
	"""	
	"""
	Then Assert Status Code of Response from "Delete" "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Delete" "api/v1/comments/33333333-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""	
	{
		"error": "User can not delete comment 33333333-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""
	Then Assert "Comment" records exist in database
	| Id                                   | UserId                               | PostId									| CommentContent															|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | c913181d-c97d-46e3-a3c9-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	| 	
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | 12345678-qwer-1234-asdf-6c4fd63cef9e | 11111111-4db5-4758-bbd6-3a7dbd9792ee	| Quis nostrum exercitationem ullam corporis suscipit laboriosam			| 
	

Scenario: User tries to delete comment when any comment exists
	Given "Comment" records exist in database
	| Id | UserId | PostId | CommentContent |
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Delete" requst to "api/v1/comments/11111111-4db5-4758-bbd6-3a7dbd9792ee"	
	"""	
	"""
	Then Assert Status Code of Response from "Delete" "api/v1/comments/11111111-4db5-4758-bbd6-3a7dbd9792ee" is "BadRequest"
	Then Assert Body of Response from "Delete" "api/v1/comments/11111111-4db5-4758-bbd6-3a7dbd9792ee" contains object
	"""	
	{
		"error": "User can not delete comment 11111111-4db5-4758-bbd6-3a7dbd9792ee"
	}
	"""
	
