Feature: Posts Controller
	In order to execute basic CRUD operations with Posts
	As Tweetbook developer
	I want to have /posts endpoint 

	Background: 	
	Given "IdentityUser" records exist in database
	| Id                                   | UserName      | NormalizedUserName | Email                | NormalizedEmail | EmailConfirmed | PasswordHash                                                                         | SecurityStamp                    | ConcurrencyStamp                     | PhoneNumberConfirmed | TwoFactorEnabled | LockoutEnabled | AccessFailedCount |
	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e | user@mail.com | USER@MAIL.COM      | user_poster@mail.com | USER@MAIL.COM   | False          | AQAAAAEAACcQAAAAEE3O6wFKAY2CL9jx4QvTk+XnPRE419lmYlyvs7Fffu5T5pspM2z3/RCo3D6IsnyfDQ== | DYER7IXAG6MD244BVFN5ETREGHYX6GSP | fe4b708e-e301-4056-8acc-4144dc8c285e | False                | False            | True           | 0                 |


Scenario: Create new post	
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/posts"
	"""
	{
	  "PostTitle": "My First Post",
	  "PostContent": "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?"
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/posts" is "Created"	
	Then Assert Body of Response from "Post" "api/v1/posts" contains property "id" as valid GUID 
	Then Assert Body of Response from "Post" "api/v1/posts" contains object, ignoring properties "id"
	"""
	{	
	  "id": "some guid, value is ignored in this test case",
	  "postTitle": "My First Post",
	  "postContent": "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?",
	  "userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	}
	"""	
	Then Assert "Post" records exist in database
	| PostTitle		| PostContent																															| UserId								|
	| My First Post	| Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|


Scenario: Create new post with empty title
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/posts"
	"""
	{
	  "PostTitle": "",
	  "PostContent": "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?"
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/posts" is "BadRequest"	
	Then Assert Body of Response from "Post" "api/v1/posts" contains object
	"""	
	{
	"PostTitle": 
		[
			"The PostTitle field is required."
		]
	}
	"""
	Then Assert "Post" records do not exist in database
	| PostContent																															| 
	| Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?	| 


Scenario: Create new post without title
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/posts"
	"""
	{	 
	  "PostContent": "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?"
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/posts" is "BadRequest"	
	Then Assert Body of Response from "Post" "api/v1/posts" contains object
	"""	
	{
	"PostTitle": 
		[
			"The PostTitle field is required."
		]
	}
	"""
	Then Assert "Post" records do not exist in database
	| PostContent																															| 
	| Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?	| 


Scenario: Create new post with empty content
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/posts"
	"""
	{
	  "PostTitle": "Something That Matters",
	  "PostContent": ""
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/posts" is "BadRequest"	
	Then Assert Body of Response from "Post" "api/v1/posts" contains object
	"""	
	{
	"PostContent": 
		[
			"The PostContent field is required."
		]
	}
	"""
	Then Assert "Post" records do not exist in database
	| PostTitle					| 
	| Something That Matters	| 


Scenario: Create new post without content
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Post" requst to "api/v1/posts"
	"""
	{
	  "PostTitle": "Something That Matters"	  
	}
	"""
	Then Assert Status Code of Response from "Post" "api/v1/posts" is "BadRequest"	
	Then Assert Body of Response from "Post" "api/v1/posts" contains object
	"""	
	{
	"PostContent": 
		[
			"The PostContent field is required."
		]
	}
	"""
	Then Assert "Post" records do not exist in database
	| PostTitle					| 
	| Something That Matters	| 


Scenario: Get all posts when posts exist	
	Given "Post" records exist in database
	| Id                                   | PostTitle     | PostContent                                                                    | UserId                               |
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | First Post    | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor | c913181d-c97d-46e3-a3c9-6c4fd63cef9e |
	| 22222222-61a4-4714-b6cd-1b1dae19bdec | Second Post   | Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.           | c913181d-c97d-46e3-a3c9-6c4fd63cef9e |
	| 33333333-61a4-4714-b6cd-1b1dae19bdec | Third Post    | Et odio pellentesque diam volutpat commodo.                                    | 00000000-c97d-46e3-a3c9-6c4fd63cef9e |
	| 44444444-61a4-4714-b6cd-1b1dae19bdec | Another Post  | Nullam eget felis eget nunc lobortis mattis.                                   | 00000000-37fc-4f48-834d-f95608414c7f |
	| 55555555-61a4-4714-b6cd-1b1dae19bdec | The Last Post | Lectus urna duis convallis convallis tellus id interdum.                       | 11111111-37fc-4f48-834d-f95608414c7f |
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/posts"	
	"""
	"""
	Then Assert Status Code of Response from "Get" "api/v1/posts" is "OK"	
	Then Assert Body of Response from "Get" "api/v1/posts" contains object
	"""
	[
	  {
		"id": "11111111-61a4-4714-b6cd-1b1dae19bdec",
		"postTitle": "First Post",
		"postContent": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
		"userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"		
	  },
	  {
		"id": "22222222-61a4-4714-b6cd-1b1dae19bdec",
		"postTitle": "Second Post",
		"postContent": "Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt.",
		"userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"		
	  },	  
	  {
		"id": "33333333-61a4-4714-b6cd-1b1dae19bdec",
		"postTitle": "Third Post",
		"postContent": "Et odio pellentesque diam volutpat commodo.",
		"userId": "00000000-c97d-46e3-a3c9-6c4fd63cef9e"		
	  },
	  {
		"id": "44444444-61a4-4714-b6cd-1b1dae19bdec",
		"postTitle": "Another Post",
		"postContent": "Nullam eget felis eget nunc lobortis mattis.",
		"userId": "00000000-37fc-4f48-834d-f95608414c7f"		
	  },
	  {
		"id": "55555555-61a4-4714-b6cd-1b1dae19bdec",
		"postTitle": "The Last Post",
		"postContent": "Lectus urna duis convallis convallis tellus id interdum.",
		"userId": "11111111-37fc-4f48-834d-f95608414c7f"		
	  }
	]
	"""	


Scenario: Get all posts when posts do not exist	
	Given "Post" records exist in database
	| Id	| PostTitle	| PostContent	| UserId	|	
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/posts"	
	"""
	"""
	Then Assert Status Code of Response from "Get" "api/v1/posts" is "OK"	
	Then Assert Body of Response from "Get" "api/v1/posts" contains object
	"""
	[]
	"""	


Scenario: Get user's existed post by id
	Given "Post" records exist in database
	| Id									| PostTitle		| PostContent												| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Post One		| Lorem ipsum dolor sit amet, consectetur adipiscing elit	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| Post Two		| Lectus urna duis convallis convallis tellus id interdum.	| 12345678-1111-46e3-a3c9-6c4fd63cef9e	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"
	"""
	"""
	Then Assert Status Code of Response from "Get" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "OK"
	Then Assert Body of Response from "Get" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "id": "11111111-61a4-4714-b6cd-1b1dae19bdec",
	  "postTitle": "Post One",
	  "postContent": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
	  "userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	}
	"""


Scenario: Get NOT his existed post by id
	Given "Post" records exist in database
	| Id									| PostTitle		| PostContent												| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Post One		| Lorem ipsum dolor sit amet, consectetur adipiscing elit	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| Post Two		| Lectus urna duis convallis convallis tellus id interdum.	| 12345678-1111-46e3-a3c9-6c4fd63cef9e	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/posts/22222222-61a4-4714-b6cd-1b1dae19bdec"
	"""
	"""
	Then Assert Status Code of Response from "Get" "api/v1/posts/22222222-61a4-4714-b6cd-1b1dae19bdec" is "OK"
	Then Assert Body of Response from "Get" "api/v1/posts/22222222-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "id": "22222222-61a4-4714-b6cd-1b1dae19bdec",
	  "postTitle": "Post Two",
	  "postContent": "Lectus urna duis convallis convallis tellus id interdum.",
	  "userId": "12345678-1111-46e3-a3c9-6c4fd63cef9e"
	}
	"""


Scenario: Get post by id when id does not exist
	Given "Post" records exist in database
	| Id									| PostTitle		| PostContent												| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Post One		| Lorem ipsum dolor sit amet, consectetur adipiscing elit	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| Post Two		| Lectus urna duis convallis convallis tellus id interdum.	| 12345678-1111-46e3-a3c9-6c4fd63cef9e	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/posts/33333333-61a4-4714-b6cd-1b1dae19bdec"	
	"""	
	"""
	Then Assert Status Code of Response from "Get" "api/v1/posts/33333333-61a4-4714-b6cd-1b1dae19bdec" is "NotFound"
	Then Assert Body of Response from "Get" "api/v1/posts/33333333-61a4-4714-b6cd-1b1dae19bdec" is empty
	

Scenario: Get post by id when any post exists	
	Given "Post" records exist in database
	| Id	| PostTitle	| PostContent	| UserId	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Get" requst to "api/v1/posts/33333333-61a4-4714-b6cd-1b1dae19bdec"	
	"""	
	"""
	Then Assert Status Code of Response from "Get" "api/v1/posts/33333333-61a4-4714-b6cd-1b1dae19bdec" is "NotFound"
	Then Assert Body of Response from "Get" "api/v1/posts/33333333-61a4-4714-b6cd-1b1dae19bdec" is empty
	

Scenario: Updates user's existed post	
	Given "Post" records exist in database
	| Id									| PostTitle			| PostContent																		| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| My Existed Post   | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| Not My Post!!!	| Lorem ipsum dolor sit amet, consectetur											| 12345678-abcd-1234-qwer-qwertyasdfgh	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{
	  "PostTitle": "Updated Post Title",
	  "PostContent": "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?"
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "OK"
	Then Assert Body of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "id": "11111111-61a4-4714-b6cd-1b1dae19bdec",
	  "postTitle": "Updated Post Title",
	  "postContent": "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?",
	  "userId": "c913181d-c97d-46e3-a3c9-6c4fd63cef9e"
	}
	"""
	Then Reload from database all "Post" records by properties	
	| Id									|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	|	
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	|	
	Then Assert "Post" records exist in database
	| Id									| PostTitle				| PostContent																															| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Updated Post Title	| Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| Not My Post!!!		| Lorem ipsum dolor sit amet, consectetur																								| 12345678-abcd-1234-qwer-qwertyasdfgh	|


Scenario: Update NOT user's but existed post	
	Given "Post" records exist in database
	| Id									| PostTitle			| PostContent								| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Not My Post!!!	| Lorem ipsum dolor sit amet, consectetur	| 12345678-abcd-1234-qwer-qwertyasdfgh	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| My Post			| Corporis suscipit laboriosam, nisi ut		| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{
	  "PostTitle": "Updated Post Title",
	  "PostContent": "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?"
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{	
	  "error": "User can not update post 11111111-61a4-4714-b6cd-1b1dae19bdec"	  	  
	}
	"""
	Then Reload from database all "Post" records by properties	
	| Id									|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	|	
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	|	
	Then Assert "Post" records exist in database
	| Id									| PostTitle			| PostContent								| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Not My Post!!!	| Lorem ipsum dolor sit amet, consectetur	| 12345678-abcd-1234-qwer-qwertyasdfgh	|
	| 22222222-61a4-4714-b6cd-1b1dae19bdec	| My Post			| Corporis suscipit laboriosam, nisi ut		| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	

Scenario: Update NOT existed post	
	Given "Post" records exist in database
	| Id	| PostTitle	| PostContent	| UserId	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{
	  "PostTitle": "Updated Post Title",
	  "PostContent": "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis?"
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{
	"error": "User can not update post 11111111-61a4-4714-b6cd-1b1dae19bdec"	  	  
	}
	"""
	Then Assert "Post" records do not exist in database
	| Id                                   |
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | 
	

Scenario: Update post with empty title
	Given "Post" records exist in database
	| Id									| PostTitle			| PostContent																		| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| My Existed Post   | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{
	  "PostTitle": "",
	  "PostContent": "Ut enim ad minima veniam, quis"
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{
		"PostTitle": 
			[
				"The PostTitle field is required."
			]
	}
	"""
	Then Reload from database all "Post" records by properties	
	| Id									|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	|		
	Then Assert "Post" records exist in database
	| Id									| PostTitle			| PostContent																		| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| My Existed Post	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	

Scenario: Update post with empty content
	Given "Post" records exist in database
	| Id									| PostTitle			| PostContent																		| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| My Existed Post   | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Put" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	{
	  "PostTitle": "My Existed Post",
	  "PostContent": ""
	}
	"""
	Then Assert Status Code of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Put" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""
	{
		"PostContent": 
			[
				"The PostContent field is required."
			]
	}
	"""
	Then Reload from database all "Post" records by properties	
	| Id									|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	|		
	Then Assert "Post" records exist in database
	| Id									| PostTitle			| PostContent																		| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| My Existed Post	| Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	

Scenario: Deletes user's existed post
	Given "Post" records exist in database
	| Id									| PostTitle			| PostContent															| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| My Existed Post   | Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis?	| c913181d-c97d-46e3-a3c9-6c4fd63cef9e	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Delete" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	"""
	Then Assert Status Code of Response from "Delete" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "NoContent"
	Then Assert Body of Response from "Delete" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is empty	
	Then Assert "Post" records do not exist in database
	| Id                                   | 
	| 11111111-61a4-4714-b6cd-1b1dae19bdec | 
	

Scenario: Delete NOT user's but existed post
	Given "Post" records exist in database
	| Id									| PostTitle			| PostContent								| UserId								|
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Not My Post!!!	| Lorem ipsum dolor sit amet, consectetur	| 12345678-abcd-1234-qwer-qwertyasdfgh	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Delete" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	"""
	Then Assert Status Code of Response from "Delete" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Delete" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""	
	{
		"error": "User can not delete post 11111111-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""
	Then Assert "Post" records exist in database
	| 11111111-61a4-4714-b6cd-1b1dae19bdec	| Not My Post!!!	| Lorem ipsum dolor sit amet, consectetur	| 12345678-abcd-1234-qwer-qwertyasdfgh	|


Scenario: Delete NOT existed post
	Given "Post" records exist in database
	| Id	| PostTitle	| PostContent	| UserId	|
	When Login as
	| Email         | Password	|
	| user@mail.com	| Dummy#123	|
	When Execute "Delete" requst to "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec"	
	"""
	"""
	Then Assert Status Code of Response from "Delete" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" is "BadRequest"
	Then Assert Body of Response from "Delete" "api/v1/posts/11111111-61a4-4714-b6cd-1b1dae19bdec" contains object
	"""	
	{
		"error": "User can not delete post 11111111-61a4-4714-b6cd-1b1dae19bdec"
	}
	"""