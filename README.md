# Learning Path for IaC, Terraform, AVM

> Acronyms  
> LP - *Learning Path*  
> IaC - *Infrastructure-as-Code*  
> AVM - *Azure Verified Modules*

## Infrastructure as Code (IaC)

### DevOps practices

> For this portion of the LP, I will be leveraging [John Savill's DevOps Master Class]() and [AZ-400](). Feel free to clone this repo and make your own notes if that fits your learning style.

#### What is DevOps?

- *Continuous delivery* of value by unionizing people, processes, and products.
- Clear communication of goals
- Moving to automation rather than relying on manual steps of deployment prcesses
- Identification and use of proper tools for continuous cycles
- Continuous delivery (or development), continuous improvement

Business units focus on *value*.  
Developer units focus on *innovation*.  
Operations units focus on *stability*.  

> For this portion of the LP, I will be leveraging the  LP and taking notes. Feel free to clone this repo and make your own notes if that fits your learning style.

#### Manual versus IaC configuration management

From a manual approach, one would have to really focus on the manual steps fo setting up an individual instance of a resource, let alone `N` number of instances.  

From an IaC approach, it is easier for users to provision `N` number of instances and maintain consistency across the environment. The focuses here are:
- scalability
- traceability when auditing configurations/deployments
- consistency across development, staging, and production environments
- version control, code review, and unit-testing capabilities

These points can ultimately be summed up as ease of use, reduction of human error, and repeatability

#### Declarative versus Imperative

`Declarative` (functional) states *what* the final state should be, without defining steps on *how* that final state should be achieved. This is generally the best approach where ease of use is the primary goal.  

`Imperative` (procedural) defines the *how* and *what* for the final state to be achieved. This is generally the best approach where addressing frequently complex configuration changes is the primary goal.

#### Azure DevOps



#### Vocab words and concepts that don't have a clear section yet:

`Idempotency`: the ability to apply `N` number of operations against a resource that will still result in the same configuration/outcome

`Circular dependency`: indicates there is an issue with dpendency sequencing causing an infinite loop, meaning the deployment becomes unable to continue.

## Terraform

> For this portion of the LP, I will be leveraging the [AZ-400]() LP and taking notes. Feel free to clone this repo and make your own notes if that fits your learning style.

> For this portion of the LP, I will be leveraging the [Hashicorp Terraform Documentation]() and taking notes. Feel free to clone this repo and make your own notes if that fits your learning style.

## Azure Verified Modules (AVM)

> For this portion of the LP, I will be leveraging the [AVM Documentaion](aka.ms/avm) LP and taking notes. Feel free to clone this repo and make your own notes if that fits your learning style.