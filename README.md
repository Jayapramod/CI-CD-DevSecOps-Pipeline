# CI-CD-DevSecOps-Pipeline

This repository is a minimal demo application and CI/CD pipeline scaffold combining Jenkins, Maven, JUnit, SonarQube, Docker, Trivy, and DockerHub. It is intended as a starting point for a full DevSecOps pipeline.

Files added/important:

- `pom.xml` — Maven build configuration (Spring Boot web app + JUnit 5)
- `src/main/java/com/example/demo` — sample Spring Boot app and controller
- `src/test/java/com/example/demo` — small unit test
- `Dockerfile` — multi-stage Dockerfile producing a runtime image
- `Jenkinsfile` — Declarative pipeline (checkout, build, test, sonar, docker build, trivy scan, push, notify)
- `sonar-project.properties` — SonarQube configuration

Quick start (local):

1. Build and run tests locally:

```bash
mvn -B clean package
mvn test
```

2. Run the Spring Boot app locally:

```bash
mvn spring-boot:run
# then open http://localhost:8080/hello
```

3. Build the Docker image locally (optional):

```bash
docker build -t myname/cicd-pipeline:local-1 .
docker run -p 8080:8080 myname/cicd-pipeline:local-1
```

SonarQube

- The `Jenkinsfile` expects a Sonar token credential (ID: `sonar-token`) in Jenkins. The Sonar analysis step runs `mvn sonar:sonar` and will use `sonar.login`.
- You can also run Sonar locally if you have a Sonar server available.

Jenkins credentials recommended

- `dockerhub-creds` — username/password for DockerHub (usernamePassword)
- `sonar-token` — SonarQube token (secret text)

Trivy

- The Jenkinsfile runs the official Trivy Docker image to scan the built image. Adjust severity thresholds or make the step fail the build depending on your policy.

Enforced policies in the Jenkinsfile

- SonarQube Quality Gate: the pipeline uses `withSonarQubeEnv` and a separate `Quality Gate` stage which calls `waitForQualityGate()`. Configure a SonarQube server in Jenkins (name used in the pipeline: `SonarQube`) and create the `sonar-token` credential. A non-OK quality gate will fail the build.
- Trivy policy: the Trivy step runs the official Trivy image in fail-on-severity mode. It is configured to exit non-zero if any HIGH or CRITICAL vulnerabilities are found; the build will fail in that case. Adjust the `--severity` and `--exit-code` flags in the `Jenkinsfile` if you want a different policy.

Email notifications

- The pipeline uses `emailext` (Email Extension plugin). Configure SMTP in Jenkins global settings and set recipients or use recipient providers.

Notes and next steps

- `scripts/deploy.sh` is intentionally untouched — implement your deployment logic later (e.g., kubectl, docker-compose, or SSH deploy).
- Update `Jenkinsfile` variables: `DOCKERHUB_NAMESPACE`, Sonar host URL if different, and credential IDs as you create them in Jenkins.
- Consider adding policy gates for Trivy and Sonar (break build on quality gate failure).

Quick environment check (simple and fast)

To keep things simple, run the included script to verify your local or agent environment before running the pipeline:

```bash
./scripts/check-env.sh
```

It checks for `java`, `mvn`, and `docker` and prints clear hints if anything is missing.
