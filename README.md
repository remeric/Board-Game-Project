# Board Game Project Purpose: Growing in Knowledge

The purpose of this project is to track my experience and knowledge in DevOps, as I look to move my career from my 15 years as a systems administrator/engineer more torwards a DevOps or Platform Engineer.  On September 8th, 2021 I had no practical experience in programming, DevOps, Python, AWS, Docker, Kubernetes, Jenkins, as well as other various tools.  After two weeks of learning I implemented my first running projects in AWS, and will continue to improve upon it as I game more knowledge and learn more tools.

## Board Game App Synopsis

To build an application using modern DevOps tools that will eventually implement CI/CD methodology.  The application itself will be a tool that will allow users to choose from available board games to play based on certain parameters such as number of plays present, and amount of time available to play.

## Branches

Please see my various branches to check out other implementations of the application, such as the EKS_Build branch that utilizes Kubernetes on Amazon EKS behind a load balancer.  The branches are to show my experience but the main applicaiton I plan to run in free tier services to save on personal cost.

## Implementation
- In variables.tf:
  - Replace the aws_key_pair vairable with the link to your own private key (https://docs.aws.amazon.com/servicecatalog/latest/adminguide/getstarted-keypair.html) 
  - Replace the docker_hub_account variable with your own docker hub, or leave it if you plan to use my docker image
  - Replace the application_version variable with the current application version
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

## Tools/languages I have started practicing with/learning to date (as of 9/8/2021 - 9/28/2021)

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
