# 🚀 End-to-End DevOps Pipeline: Containerized Weather API

## 📖 Executive Summary
This project demonstrates a complete, production-grade Continuous Integration and Continuous Deployment (CI/CD) pipeline. It encompasses Infrastructure as Code (IaC), automated containerized deployments, and a robust observability stack to monitor application health and server metrics in real-time.

## 🏗️ Architecture & Workflow

Below is the high-level architecture diagram representing the automated CI/CD lifecycle and the production monitoring stack:

```mermaid
flowchart TD
    %% Define Nodes
    Dev[Developer]
    Git[GitHub Repository]
    Jenkins[Jenkins CI/CD Server]
    DockerHub[(Docker Hub Registry)]
    
    subgraph AWS_Prod [AWS EC2 Ubuntu Instance]
        App[Python Flask API Container :5000]
        Prometheus[Prometheus Container :9090]
        Grafana[Grafana Container :3000]
        
        %% Internal Monitoring Flow
        Prometheus -- Scrapes Metrics --> App
        Grafana -- Queries Time-Series Data --> Prometheus
    end

    %% Workflow Connections
    Dev -- 1. Git Push --> Git
    Git -- 2. Triggers Pipeline --> Jenkins
    Jenkins -- 3. Builds & Pushes Image --> DockerHub
    Jenkins -- 4. SSH Remote Execution --> AWS_Prod
    AWS_Prod -- 5. Pulls Latest Image --> DockerHub

