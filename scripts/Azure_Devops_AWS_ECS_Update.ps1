            #set Parameters (must use script with params for secrets in AzureDevops, can't do inline)
            $accessparam = $arg[0]
            $secretparam = $arg[1]

            $accessparam
            $secretparam

            #Set to powershell 7 (Azure Devops currently launches V5)
            if ($PSVersionTable.PSVersion -lt [Version]"7.0") {
                Write-Host "Version: $($PSVersionTable.PSVersion)"
                Write-Host "Re-launching as pwsh"
                pwsh -File $MyInvocation.MyCommand.Definition
                exit
            }   

            #Install AWS Tools module for Set-AWSCredentials command
            Write-Host "-------Installing AWS Tools Common module"
            Set-executionpolicy unrestricted
            $ProgressPreference = "SilentlyContinue"
            Set-PSRepository PSGallery -InstallationPolicy Trusted
            install-module AWS.Tools.Common -SkipPublisherCheck
            
            #Check installs and versions
            Write-Host "-------Check Installed Modules"
            Get-InstalledModule

            Write-Host "------- PS Version Information"
            Get-Host

            Write-Host "-------AWS Version Information"
            aws --version

            Write-Host "------- Set AWS Credentials"
            $accessparam
            $secretparam
            Initialize-AWSDefaultConfiguration -AccessKey $accessparam -SecretKey $secretparam

            # Query for name of cluster and service (assuming you left cluster and service names the same from the original terraform script)
            
            Write-Host "------- Getting Cluster"
            $clusterlist = aws ecs list-clusters --query 'clusterArns' --region us-east-1
            $clusters = $clusterlist | ConvertFrom-Json

            Write-Host "Cluster list variable $clusterlist"
            Write-Host "Clusters variable $clusters"
            Write-Host "PS Version"
            Get-Host
            
            foreach ($cluster in $clusters) {
                If ($cluster -like "*BGapp_ECS_cluster*") {
                    $clusterarn = $cluster
                    echo $clusterarn
                }
            }
            Write-Host "-------Cluster ARN $clusterarn"


            Write-Host "-------Getting Service ARN"
            $servicelist = aws ecs list-services --cluster $clusterarn --query 'serviceArns'  --region us-east-1
            $services = $servicelist | ConvertFrom-Json
            
            foreach ($service in $services) {
                If ($service -like "*BGapp_ECS_service*") {
                    $servicearn = $service
                    echo $servicearn
                }
            }
            Write-Host "-------Service ARN $servicearn"
            
            #update service that is running task
            #aws ecs update-service --cluster $clusterarn --service $servicearn --region us-east-1 --force-new-deployment
