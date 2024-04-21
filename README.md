# SRE Fundamentals with Google

https://uplimit.com/course/sre-fundamentals-with-google

**Week 3 Project - Dealing with Toil at UpCommerce**


> Task1 solution is [watcher.sh](./watcher.sh). <br/>
> Task2 solution is below in this README.md.

![UpCommerce](https://github.com/sadikkuzu/sre-task-repo/assets/23168063/3bffdc3e-98cd-4791-9042-87103e235cd1)

## Dealing with Toil at UpCommerce

At last week's UpCommerce SRE team stand-up meeting, two significant topics emerged as sources of toil:

1. **Swype.com Downtime**: UpCommerce, relying on Swype.com as its payment gateway provider, faced downtime significant. During these periods payments in queue did not roll back, leading to customer claims against UpCommerce. The Engineering Lead tasked the SRE team with preventing such incidents from recurring. To address this issue, two solutions were proposed:
     - **Code Refactoring**: The team proposed pulling out the payment system implementation from UpCommerce's original implementation and transforming it into a microservice. The proposed implementation details are already captured in the `swype-deployment.yml` and `swype-service.yml` files.
     - **Fail-Safe Mechanism**: Another solution involves implementing a **"big red button"** service. This service would shut down Swype's payment service in UpCommerce's cluster if it exhibited erratic behavior.

2. **Ticketing System Challenges**: The ticketing system for alert management had been a major point of contention among engineers. Complaints included recurring obsolete issues and a lack of clear prioritization for incoming issues. An example of the ticketing system's output is as follows:

```
Zone XQ: EndpointRegistrationTransientFailure
Zone OH-1: EndpointRegistrationTransientFailure
Zone OH-1: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone OH-1: EndpointRegistrationTransientFailure
Zone OH-1: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone AB: EndpointRegistrationTransientFailure
Zone AB: LLMBatchProcessingJobFailures
Zone AB: EndpointRegistrationFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone OH-1: EndpointRegistrationTransientFailure
Zone OH-1: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone AB: EndpointRegistrationTransientFailure
Zone AB: LLMBatchProcessingJobFailures
Zone AB: TooFewEndpointsRegistered
Zone AB: LLMModelStale
Zone OH-1: EndpointRegistrationTransientFailure
Zone OH-1: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone XQ: EndpointRegistrationTransientFailure
Zone AB: EndpointRegistrationTransientFailure
Zone AB: LLMBatchProcessingJobFailures
Zone AB: EndpointRegistrationFailure
Zone AB: LLMModelVeryStale
```

## Getting your development environment ready

For this week's project you will use GitHub Codespaces as your development environment, just like you did for the projects in previous weeks.

### Steps
1. Create a fork of the [week's repository](https://github.com/onyekaugochukwu/sre-week-three-task).
1. When you have created a fork of the week's repository, start a codespace on the `main` branch.
1. Run the command below in your codespace's terminal to create a single-node, Kubernetes cluster using Minikube: `minikube start`
1. Once your Minikube cluster is running, enter the command: `kubectl create namespace sre`
  This creates a namespace in your Kubernetes cluster named sre. It is within this namespace that you'll do all the tasks required for this project.
1. Run the command below to create the required resources for this project
  ```
  kubectl apply -f upcommerce-deployment.yml -n sre
  kubectl apply -f swype-deployment.yml -n sre
  ```

## Task 1
Implement a "big red button" for UpCommerce by creating a bash script to monitor the Kubernetes deployment dedicated to the Swype microservice defined in `swype-deployment.yml`. The script should be written in the empty `watcher.sh` file in the task repo, and trigger if the pod restarts due to network failure more than three times. Here's an optional, pseudocode hint of the tasks your `watcher.sh` file should perform:

```
1. Define Variables: Set the namespace, deployment name, and maximum number of restarts allowed before scaling down the deployment.
2. Start a Loop: Begin an infinite loop that will continue until explicitly broken.
3. Check Pod Restarts: Within the loop, use the kubectl get pods command to retrieve the number of restarts of the pod associated with the specified deployment in the specified namespace.
4. Display Restart Count: Print the current number of restarts to the console.
5. Check Restart Limit: Compare the current number of restarts with the maximum allowed number of restarts.
6. Scale Down if Necessary: If the number of restarts is greater than the maximum allowed, print a message to the console, scale down the deployment to zero replicas using the kubectl scale command, and break the loop.
7. Pause: If the number of restarts is not greater than the maximum allowed, pause the script for 60 seconds before the next check.
8. Repeat: After the pause, the script goes back to step 3. This process repeats indefinitely until the number of restarts exceeds the maximum allowed, at which point the deployment is scaled down and the loop is broken.
```

When you are done with your `watcher.sh` file, run the commands below to get it working:

```shell
chmod +x watcher.sh
nohup bash watcher.sh &
```

The command `chmod +x watcher.sh` makes the watcher.sh script executable, while `nohup bash watcher.sh` & uses the nohup (no hang up) bash utility to ensure the watcher script runs in a detached mode. `Nohup` usually creates a file named `nohup.out` in which it stores all the `stdout` and `stderr` outputs encountered while running the script.

## Task 2

Identify potential solutions or products, whether free or commercial, to address the toil in the ticketing system. These solutions should aim to mitigate issues such as recurring obsolete alerts and lack of prioritization. Create a markdown file and fill these solutions in your markdown file (feel free to use your repo's README.md file for this task).

When you are done, please submit a link to your fork of the course repo.

---
---

## UpCommerce SRE Ticketing System Improvements

This document outlines potential solutions to address the toil identified in the UpCommerce SRE team's ticketing system, specifically regarding recurring obsolete issues and lack of prioritization.

### Challenges

* **Recurring Obsolete Issues:** The ticketing system displays repetitive alerts for the same problem (e.g., multiple "EndpointRegistrationTransientFailure" entries). This clutters the system and makes it difficult to identify new issues.
* **Lack of Prioritization:** The example lacks clear prioritization for incoming issues. Critical issues might get buried under a pile of less urgent ones.

### Potential Solutions

Here are some solutions to consider, categorized by approach:

**1. Alert Aggregation and Deduplication**

* **Alerting tools:** Implement an alerting tool that can group similar alerts together. This will condense repetitive entries like "EndpointRegistrationTransientFailure" into a single notification with an occurrence count. Popular options include:
    * Graylog (Free & Open Source) - Graylog offers alert aggregation and deduplication features to simplify incident response.
    * Prometheus Alertmanager (Free & Open Source) - Prometheus Alertmanager supports grouping and deduplication of alerts, reducing noise in the system.
    * Zabbix (Free & Open Source) - Zabbix supports alert grouping and deduplication to reduce noise in the system.
    * Edge Delta (Commercial) - Edge Delta offers alert aggregation and deduplication along with real-time anomaly detection for proactive incident identification.
    * PagerDuty (Commercial) - PagerDuty provides alert grouping and deduplication features to streamline incident management.
    * Alertlogic (Commercial) - Alertlogic provides alert aggregation and deduplication features to simplify incident response.
    * Splunk On-Call (Commercial) - Splunk On-Call supports alert grouping and deduplication to enhance incident resolution efficiency.
    * Opsgenie (Commercial) - Opsgenie offers alert aggregation and deduplication functionalities to improve incident management.
    * BigPanda (Commercial) - BigPanda offers alert aggregation and deduplication features to reduce alert fatigue and improve incident resolution.
    * Moogsoft (Commercial) - Moogsoft provides alert aggregation and deduplication functionalities to streamline incident management.
    * Datadog (Commercial) - Datadog offers alert grouping and deduplication features to simplify incident response.
    * New Relic (Commercial) - New Relic provides alert aggregation and deduplication capabilities to enhance incident resolution efficiency.
    * Nagios (Free & Open Source) - Nagios offers alert aggregation and deduplication functionalities to streamline incident management.

* **Ticketing system integrations:** Explore integrations between the existing ticketing system and alerting tools. This can automatically create tickets for grouped alerts, reducing data redundancy.

**2. Alert Prioritization**

* **Alerting rules with severity levels:** Define alert rules that assign severity levels (critical, high, medium, low) based on specific criteria. This allows the ticketing system to automatically prioritize alerts. Tools like Prometheus and many commercial offerings support this functionality.
* **Machine Learning (ML):** Explore integrating ML models that can analyze historical data and incident patterns to predict and prioritize alerts based on potential impact. This requires expertise and data infrastructure but can significantly improve automation.

**3. Ticketing System Enhancements**

* **Customizable dashboards:** Investigate if the current ticketing system allows for creating custom dashboards. These can display prioritized alerts and relevant metrics, providing a clearer view of critical issues.
* **Ticketing workflows:** Consider implementing ticketing workflows that automate routing and escalation procedures based on predefined criteria. This streamlines ticket handling and ensures faster resolution of high-priority issues.

**Additional Considerations**

* **Root cause analysis:** While these solutions address immediate toil, identifying root causes of recurring issues is crucial for long-term improvement. Invest in analyzing and resolving the underlying problems behind repetitive alerts.
* **Team training:** Train SRE team on the new ticketing system features and prioritization methods to ensure efficient utilization of the implemented solutions.
