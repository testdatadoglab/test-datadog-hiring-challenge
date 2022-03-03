# **Overview**



## Register Datadog 

Following instructions, a new Datagot trial for Candidature purpose is created  *("To do this, go to https://app.datadoghq.com/signup and enter your email, full name, etc. For the Company field, please enter “Datadog Recruiting Candidate”)*.



![image](https://user-images.githubusercontent.com/100625959/156545218-6fa950c5-bb26-48bb-bdc5-4fd0c0c33ac0.png)




## **Cloud Environment - GCP**

 

Throught a new gmail account *testdatadoglab@gmail.com* it has been enabled a GCP free test (around 300\$).


The first step will be to create a new Project named *test-datadog-student*:

![image](https://user-images.githubusercontent.com/100625959/156600846-a671f918-5f7f-4be4-90e8-e3002dc27098.png)



After, a new **Service Account** must be created. All GCO resources permissions are based on those of the Service account:

![image](https://user-images.githubusercontent.com/100625959/156600911-5b3378e9-6c47-4c21-85fd-3738c10a1cad.png)



These are the assigned service account permissions:


![image](https://user-images.githubusercontent.com/100625959/156600979-030be5f2-f23d-4798-bcdd-3b11e0233d76.png)





Then, it\'s neccesary to access from outside the console to create a Private Key and download it. We will use the JSON key type for this POC:

![image](https://user-images.githubusercontent.com/100625959/156601063-8adbc25b-b549-40b3-a3c2-780122e39a4c.png)




![image](https://user-images.githubusercontent.com/100625959/156601141-6e880e2d-868a-4087-b8bc-b6c18e36af0b.png)




 

 

# **Creation of a new virtual machine where Jenkins will run**

 

Once the IAM - Service Account and a Private key have been created, a new Virtual Machines (CestOS 8 images based) is created to run Jenkins
within. The node name is *test-datadog-jenkins-instance:*



![image](https://user-images.githubusercontent.com/100625959/156601222-6eae339d-8694-4030-aceb-4ea22bc9544b.png)







# **Pipeline prerequisites**

 

 

## 1. Jenkins Installation

 

Before downloading Jenkins it\'s requiered to install some other tools, like **wget**, or **git**.


```
 sudo yum install wget 
```

> The installation procedure itself for CentOS it\'s described on the Jenkins doc
> (https://www.jenkins.io/doc/book/installing/linux/#red-hat-centos)

 

```
sudo wget -O /etc/yum.repos.d/jenkins.repo (https://pkg.jenkins.io/redhat-stable/jenkins.repo)

sudo rpm \--import (https://pkg.jenkins.io/redhat-stable/jenkins.io.key)

sudo yum upgrade\

sudo yum install epel-release java-11-openjdk-devel\

sudo yum install jenkins
```



>   **<u>IMPORTANT:</u>**
>
>  
>
>  Git tool must be installed on the Jenkins node in order to run a JenkinsFile located in a Git Repository:
>
>  ```
>  yum install git
>  ```
>
>  

## 2. Firewall port aperture

 

Previously access to Jenkins, it\'s default port (8080) must be opened in GCP VPC-Firewall section as follows:

 

![image](https://user-images.githubusercontent.com/100625959/156601330-99e546b1-37e1-4ef0-91bf-969235272461.png)



 

## 3. Jenkin\'s plugins installation


Suggested plugins will be installed. Subsequently, the Ansible and Terraform plugins will be installed:



![image](https://user-images.githubusercontent.com/100625959/156601400-55b26368-44f3-4db2-88a9-38ccea96683e.png)




![image](https://user-images.githubusercontent.com/100625959/156601457-057f402b-a37e-4d73-90b0-8c2cb22b393c.png)



 

## 4. Joining  Jenkins with Github

 


-   Git repositorio URL: (https://github.com/testdatadoglab/test-datadog.git)



![image](https://user-images.githubusercontent.com/100625959/156601507-01471846-4777-4a41-8834-3cd4c0c6d2cd.png)





-   Now in Jenkins, we can create a global user named *jenkins-user-github.* Note that the user is a *non-existing-user* and the *password* is the *GitHub Token*:

![image](https://user-images.githubusercontent.com/100625959/156601565-18b1fae3-ab3d-4f23-a426-18eeb42c0f4f.png)




![image](https://user-images.githubusercontent.com/100625959/156601610-5ba35e5b-9f1f-4861-adbc-2d48502468ae.png)






![image](https://user-images.githubusercontent.com/100625959/156601678-6ff2f5c4-d55a-4e5b-bfa6-75ff1079449e.png)


 

## 5. gcloud tool SDK configuration

 

The gcloud CLI manages authentication, local configuration, developer workflow, interactions with Google Cloud APIs. With the gcloud command-line tool, it's easy to perform many common cloud tasks, like creating a Compute Engine VM instance, managing a Google Kubernetes Engine cluster, and deploying an App Engine application, either from the command line or in scripts and other automations. (https://cloud.google.com/sdk).

>  

gcloud CLI will be used in this test to create via Terraform the infrastructure (Virtual Machines and GKE Cluster).



<u>**How to configure gcloud?**</u>

Init gcloud CLI configuration tool:

>   ```
>   gcloud init
>   ```
>
>  

Select to create a new account, in this case *testdatadoglab@gmail.com.* A new link will be presented and must be clicked in order to validate gmail acccount:

>  
>
![image](https://user-images.githubusercontent.com/100625959/156601746-37a72650-5162-45f8-8c2b-b853d4f86334.png)
>
>  




> Then, you have to select a zone, in this case , it will be *europe-west2-c (23):*

![image](https://user-images.githubusercontent.com/100625959/156601891-1306a748-936f-4550-8797-73cf968d7b13.png)

 

> After the configuration process is finished, you can check it using this command:

 

> ```
> gcloud init | gclod config list
> ```

![image](https://user-images.githubusercontent.com/100625959/156601938-4ad4a28b-594e-4c88-9d98-9c9ea30c95b5.png)







> All gcloud configurations are saved on \$HOME/.config/gcloud/configurations

![image](https://user-images.githubusercontent.com/100625959/156601982-e1ff85aa-4c5f-40f1-822d-4a0d70202a85.png)





# **Jenkins Pipeline**



In the pipeline is automatically done the folowiing task:



- Install requiered software (terraform, wget, unzip, etc).

- Update / Upgrade of the OS.

- GKE cluster provisioning using Terraform automation tool.

- Install of datadog Helm repository from K8s.

- Datadog Cluster agent installation.

- Tomcat Installation on k8s using DockerHub image.

- Exposing Tomcat servie using a LoadBalancer.

  

First of all, you have to create a new Job (Pipeline based):

 

![image](https://user-images.githubusercontent.com/100625959/156602055-5080a833-1717-4647-b6df-8a4633fa31b5.png)





## **Pipeline (Jenkinsfile)**

Jenkins Access:

​	http://34.89.72.105:8080/

 

### 1. Checkout code from gitHub:

https://github.com/testdatadoglab/test-datadog.git

>```
>stage('Checkout') {
>   // Checkout our application source code
>   git url: 'https://github.com/testdatadoglab/test-datadog.git', credentialsId: 'jenkins-user-github', branch: 'master'
>    }
>```

### 2. Software Installation: 

> In this step, the necessary software for the next GKE installation will be installed:
>
> 

-   *Git*: Needed to join Jenkins to Github (the site where the code is kept).
-   *Wget*: Needed to download Terraform and Helm software.
-   *Kubectl*: Kubernetes CLI.
-   *Unzip*: Software needed to uncompress files.
-   *Helm*: Utility used on Kubernetes environment which makes easier K8\'s deployments.

 

> ```
> stage('Software Installation') {
>         // Lets solve environment dependencies
>         dir ('.') {
>         sh "sudo yum update -y --skip-broken --nobest"
>         sh "sudo yum upgrade -y --skip-broken --nobest"
>         sh "sudo yum install git -y"
>         sh "sudo yum install wget -y"
>         // Instalación kubectl
>         sh "sudo yum install kubectl -y"
>         // Instalación unzip
>         sh "sudo yum install unzip -y"
>         // Instalación Terraform 
>         sh "sudo  wget https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip && sudo unzip -qq terraform_1.0.9_linux_amd64.zip  &&  sudo mv terraform  /usr/bin && sudo rm -Rf terraform_1.0.9_linux_amd64.zip*"
>         // Instalación Helm
>         sh "sudo wget https://get.helm.sh/helm-v3.4.1-linux-amd64.tar.gz && sudo tar xvf helm-v3.4.1-linux-amd64.tar.gz && sudo mv linux-amd64/helm /usr/bin && sudo rm -Rf helm-v3.4.1-linux-amd64.tar.gz && sudo rm -rf linux-amd64"
>         }
>     } 
> ```

 

### 3. GKE Installation

 

> For this topic, Terraform will be selected as our ** Infrastructure as Code ** tool for testing. It helps to develop and scale Cloud services and manage the state of the network. Its primary use is in data centers and software-defined networking environments. It does not install and manage software on existing devices; instead, it creates, modifies, and destroys servers and various other cloud services.
>
> 
>
> <u>Some feautures of terraform:</u>
>
> 

- Terraform follows a **declarative approach** which makes deployments fast and easy.

- It is a convenient tool to display the resulting model in a  graphical form.

- Terraform also manages **external service providers** such as cloud  networks and in-house solutions.

- It is one of the rare tools to offer **building infrastructure** from scratch, whether public, private or multi-cloud.

- It helps **manage parallel environments**, making it a good choice for testing, validating bug fixes, and formal acceptance.

- Modular code helps in achieving **consistency, reusability, **and** collaboration**.

- Terraform can **manage multiple clouds** to increase fault tolerance.

  

> In the terraform_files directory there are three files that will be used for Terraform:
>
> 

-   *Main.tf*

-   *Variables.tf*

-   *Outputs.tf*

>```
>
>```

https://docs.datadoghq.com/agent/kubernetes/?tab=helm

### 4. Installation of  Datadog on Kubernetes cluster

This is the repositories that Helm will use while installing  Datadog Agent.

 

>  - helm repo add datadog https://helm.datadoghq.com
>
>  ```
>    stage('Helm Repositories Installation'){
>      sh "helm repo add datadog https://helm.datadoghq.com" }
>  
>  ```

Install Datadog agent on K8s Cluster (https://docs.datadoghq.com/agent/kubernetes/?tab=helm)

```bash
	helm install datadog-release -f values.yaml  --set datadog.apiKey=<DATADOG_API_KEY> datadog/datadog
```

In the *values.yaml* file, it's enabled logs and trace collecting:



```bash
  datadog:
  logs:
    enabled: true
    containerCollectAll: true
		## Enable apm agent and provide custom configs
  apm:
    # datadog.apm.portEnabled -- Enable APM over TCP communication (port 8126 by default)
    ## ref: https://docs.datadoghq.com/agent/kubernetes/apm/
    portEnabled: true
```



### 5. **Tomcat Installation on k8s**

 It is used for Tomcat installation and image from DockerHub named *"saravak/tomcat8"*. This is the deployment yaml file used:



>​    stage('Install Tomcat on k8s'){
>
>​        sh "cd ./kubernetes"
>
>​        sh "kubectl apply -f tomcat-deployment-k8s-yaml"
>
>​        sh "kubectl apply -f tomcat-loadbalancer-k8s"
>
>​    }





> ```
> >$ cat tomcat.yaml 
> 
> apiVersion: apps/v1
> kind: Deployment
> metadata:
>  labels:
>     tags.datadoghq.com/env: "stage"
>     tags.datadoghq.com/service: "tomcatinfra"
>     tags.datadoghq.com/version: "1.0"
>  name: tomcat-deployment
> spec:
>   selector:
>     matchLabels:
>       app: tomcatinfra
>   replicas: 2 # tells deployment to run 2 pods matching the template
>   template:
>     metadata:
>       labels:
>         app: tomcatinfra
>         tags.datadoghq.com/env: "stage"
>         tags.datadoghq.com/service: "tomcatinfra"
>         tags.datadoghq.com/version: "1.0"
>     spec:
>       volumes:
>         - hostPath:
>             path: /var/run/datadog/
>           name: apmsocketpath
>       containers:
>         - name: tomcatapp 
>           image: saravak/tomcat8
>           ports:
>           - containerPort: 8080
>           volumeMounts:
>             - name: apmsocketpath
>               mountPath: /var/run/datadog
>           env:
>             - name: DD_AGENT_HOST
>               valueFrom:
>                 fieldRef:
>                   fieldPath: status.hostIP
>             - name: DD_ENV
>               valueFrom:
>                 fieldRef:
>                   fieldPath: metadata.labels['tags.datadoghq.com/env']
>             - name: DD_SERVICE
>               valueFrom:
>                 fieldRef:
>                   fieldPath: metadata.labels['tags.datadoghq.com/service']
>             - name: DD_VERSION
>               valueFrom:
>                 fieldRef:
>                   fieldPath: metadata.labels['tags.datadoghq.com/version']
>             - name: DD_LOGS_INJECTION
>               value: "true"
> 
> ```
>
> 



The latest stept of the pipeline will be to expose Tomcat using LoadBalancer service to make them accesible through internet:

>  
>
>  ```
>  >$ cat tomcat-loadbalancer.yaml
>  ---
>  apiVersion: "v1"
>  kind: "Service"
>  metadata:
>    name: "tomcat-deployment-service"
>    namespace: "default"
>    labels:
>      tags.datadoghq.com/env: "stage"
>      tags.datadoghq.com/service: "tomcatinfra"
>      tags.datadoghq.com/version: "1.0"
>  spec:
>    ports:
>    - protocol: "TCP"
>      port: 8080
>      targetPort: 8080
>    selector:
>      app: "tomcatinfra"
>    type: "LoadBalancer"
>    loadBalancerIP: ""
>  
>  ```
>
>  



# Datadog Console - Integrations with Google Cloud Platform

From Datadatog Console --> Integrations --> Google Cloud Platform Integration, GCP project is integrated in the Datadog ecosystem. Then all metrics exposed by open GCP API are imported to DD:



![image](https://user-images.githubusercontent.com/100625959/156602253-e9d987d5-0da4-4f84-854c-57764ba7bd26.png)



After the integration in complete, in Dashboard sections, there are ready to use some GCP OOTB Dashboards:



![image](https://user-images.githubusercontent.com/100625959/156602337-f48fd29a-4314-406b-8a58-487f64865c60.png)




## Integration Logs Pub/Sub



Following instructions from Datadog documentation (https://docs.datadoghq.com/integrations/google_cloud_platform/#log-collection) GCP logs are integrated via Pub/Sub GCP service in Datadog as it's shown bellow:
![image](https://user-images.githubusercontent.com/100625959/156602424-83a9775c-4692-4ef0-8f9b-8528bc9a0674.png)


![image](https://user-images.githubusercontent.com/100625959/156602491-54bdf376-8339-4347-adab-a3202f7aaadf.png)





## Datadog agent  Cluster Kubernetes

In the pipeline a Kunernetes Cluster agent of Datadog has been installed. Here are the evidences about is was well (some K8s Dashboards):

![image](https://user-images.githubusercontent.com/100625959/156602574-e48007c2-645e-4594-b99f-84146deb207b.png)



![image](https://user-images.githubusercontent.com/100625959/156602621-0d1892e3-2960-4bdf-b589-f95d6b714121.png)







## Integration Tomcat



From Datadatog Console --> Integrations --> Tomcat, Tomcat metrics are integrated in Datadog. Tomcat is running as a POD on K8s:

![image](https://user-images.githubusercontent.com/100625959/156602655-f03662d2-1fdb-4e1f-96a6-eb5512f770d0.png)



Once Tomcat integration is ready, some new OOTB Dashboards are available:


![image](https://user-images.githubusercontent.com/100625959/156602719-79b32b1a-feba-4e01-8839-53937f334ba7.png)



## Synthetic

It has been scheduled every 15 minutes a synthetic test on https://www.datadoghq.com website navigating over several pages:



![image](https://user-images.githubusercontent.com/100625959/156602784-01aca65e-588b-4098-a44a-2a6ea941c9bd.png)

![image](https://user-images.githubusercontent.com/100625959/156602833-73e753c3-c5b5-4a8a-80d9-a314469f2b6d.png)

![image](https://user-images.githubusercontent.com/100625959/156602907-24f2c3ac-8e96-4725-b7c8-a6dd31dfcf13.png)





## Monitor - SLO

Based on the Synthetic test, it has been created a new monitor as it's shown bellow:



![image](https://user-images.githubusercontent.com/100625959/156602978-ae80ad85-759a-4f3d-a83c-9ff51636d18b.png)



SLO Warning has been defined on 99,99 and Target in 99%, the error budget is very short (I know it's not realictic.... it's just a test):

![image](https://user-images.githubusercontent.com/100625959/156603048-5e342417-4e5e-4ae3-a52d-d27fde261951.png)



## Dashboard

It's created a new Timeboard DB with three different sections, infrastructure, Synthetic-SLOs and Logs:

![image](https://user-images.githubusercontent.com/100625959/156603126-0d5861d2-38f6-46b5-ae36-05a71c1ac101.png)




# **Objection Inquiry:**



#### **Objection / Inquiry 1: from prospective customer:** **“My team is too busy fighting fires to evaluate another monitoring tool.”** **- Kate the SRE Manager** 

Hi Kate, this is one of Datadog's strengths and where it can help you the most. Datadog has a wide spectrum of Observability skills, that is, many of the monitoring solutions that youcurrently have and their functionalities would be unified within Datadog. Datadog can therefore help you and simplify your day to day for you and your team. But it is not a solution only for SRE, its users can be very diverse, from infrastructures, development, architecture and even business. 
When an incident occurs, we will help you reduce its MMTR, development will understand the problem if they have to intervene from a language that can interpret (code level and database queries), architecture will better understand the relationships established in its applications, which are the bottlenecks and the layers that most penalize the general performance of the application. Of course business will also gain visibility into how TI and its impact relates to their conversion rates.


#### **Objection / Inquiry 2: from prospective customer:** **“We’re a mobile gaming company about to release an online multiplayer game that’s been super hyped up in the media. We’re bracing for a huge influx of traffic on launch day so we’ll be scaling up very quickly. Can Datadog help during this critical period?”** **- Randy the Product Manager** 

Hi Randy, Datadog is a cloud native solution designed for scalable environments and in the cloud. In these scenarios where the number of requests is unknown, Datadog is where you can best handle them. Thanks to its trademarks "Tracing without limits" and "Logging without limits" in any scenario it is possible to continue collecting 100% of the traces and log records.

Datadog can scale as your business scales, our AWS Auto Scaling is a service to automatically launch or terminate EC2 instances based on user-defined policies.

#### **Objection / Inquiry 4: from prospective customer:** **“I hear Datadog is great at monitoring Public Cloud Infrastructure but we’re not moving to the Cloud, we don’t need another monitoring solution.” - Pierre the VP of Infra** 

Hello Pierre, this is a great point. It's correct that Datadog is cloud native solution based and thought in new architecture paradigm of Infrastructure where it scales up and down depending on the applications activity moving from a Capex to Opex model. The application architecture is also different, it comes from the monolitic model to an atomized one (microservices).  
The thing is that Datadog is  for on-prem infra as well. Indeed the most of customers have an hibrid model where combines Private Cloud on-premise with infrastructure on the cloud.  
In the following article (https://www.datadoghq.com/solutions/on-premises-monitoring/) you can see how Datadog provides full visibility into every layer of an on-premise environment, regardless of where or how teams deploy their services.
