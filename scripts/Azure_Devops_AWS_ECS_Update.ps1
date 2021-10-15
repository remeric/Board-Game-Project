            #set Parameters
            $accessparam = $args[0]
            $secretparam = $args[1] 

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
            Set-AWSCredential -AccessKey $accessparam -SecretKey $secretparam -StoreAs myprofile -Scope Global
            Initialize-AWSDefaultConfiguration -AccessKey $accessparam -SecretKey $secretparam -Region us-east-1 -Scope Global

            # Query for name of cluster and service (assuming you left cluster and service names the same from the original terraform script)
            
            Write-Host "------- Getting Cluster"
            $clusterlist = aws ecs list-clusters --query 'clusterArns' --region us-east-1
            $clusters = $clusterlist | ConvertFrom-Json

            Write-Host "Cluster list variable $clusterlist"
            Write-Host "Clusters variable $clusters"
            
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