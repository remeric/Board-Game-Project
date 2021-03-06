# Board Game Project Purpose: Growing in Knowledge

The purpose of this project is to track my experience and knowledge in DevOps, as I look to move my career from my 15 years as a systems administrator/engineer more torwards a DevOps or Platform Engineer.  On September 8th, 2021 I had no practical experience in programming, DevOps, Python, AWS, Docker, Kubernetes, Jenkins, Azure DevOps, as well as other various tools.  After two weeks of learning I implemented my first running projects in AWS, and will continue to improve upon it as I game more knowledge and learn more tools.

## Board Game App Synopsis

To build an application using modern DevOps tools  The application itself will be a tool that will allow users to choose from available board games to play based on certain parameters such as number of plays present, and amount of time available to play.

## Environments

Please see my various environment builds in Terraform - while I prefer to work on AWS EKS to practice my Kuberenetes skills, most of my workd is done on the AWS ECS environment as it is free tier eligible while AWS EKS is not.

## Implementation
NOTICE!  these instructions may not always be 100% up to date as I am constantly working on my skills and updating things, this is more to work as a guide is someone else would also like to play around with the app on their own.
- Update ./app/games.xlsx with your own list of games
- Build your docker image and push to your docker hub
- In terraform/backend-state:
  - update bucket name for resournce aws_s3_bucket to your desired bucket name
- Choose an environment in terraform folder, I suggest AWS-ECS for balance of functionality and cost
- In variables.tf in desired environment:
  - Replace the aws_key_pair vairable with the link to your own private key (https://docs.aws.amazon.com/servicecatalog/latest/adminguide/getstarted-keypair.html) 
  - Replace the docker_hub_account variable with your own docker hub account
  - Replace the application_version variable with the current application version you created in your docker hub
- In Main.tf of desired environment
  - update the bucket name on your S3 backend config
- Run terraform apply from within the terraform folder
- Grab the public_ip from the output and verify your app is up and running.

Notice:  These instructions are for those with some basic DevOps knowledge - if you are new like I was and need further instruction on what all tools to install, how to get started, etc. please let me know.  Or, I would recommend taking the "Learn DevOps: Docker, Kubernetes, Terraform and Azure DevOps" course by in28minutes on Udemy.
  
## Tools/languages I have started implementing to date

- AWS
- Python
- Flask
- Docker
- Kubernetes
- Terraform
- Azure Devops

## Tools/languages I have started practicing with/learning to date (as of 9/8/2021 - 10/18/2021)

- AWS
- Python
- Flask
- Docker
- Kubernetes
- Terraform
- GCP
- Azure
- Jenkins
- Azure DevOps
- Ansible (starting week of 10/18)
