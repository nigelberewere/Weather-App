# CI/CD Integration Guide

This guide shows how to integrate Weatherly integration tests into your CI/CD pipeline.

## GitHub Actions

### Basic Integration Tests Workflow

Create `.github/workflows/integration-tests.yml`:

```yaml
name: Integration Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  integration_tests:
    runs-on: ubuntu-latest
    
    name: Integration Tests (Android)
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
          cache: true
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Enable Android Emulator
        run: |
          EMULATOR_PATH=$(find $ANDROID_SDK_ROOT -name emulator -type d)
          export PATH=$EMULATOR_PATH:$PATH
          emulator -avd emulator -no-snapshot-load -no-window -no-audio &
          adb wait-for-device
          adb shell input keyevent 82
      
      - name: Run integration tests
        run: flutter test integration_test/ --verbose
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: integration-test-results
          path: build/integration_test/
```

### Advanced GitHub Actions Workflow

Create `.github/workflows/integration-tests-advanced.yml` for parallel testing:

```yaml
name: Integration Tests (Advanced)

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  integration_tests:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        test-file:
          - location_permission_test.dart
          - search_flow_test.dart
          - favorites_flow_test.dart
          - settings_persistence_test.dart
          - user_journey_test.dart
      
      fail-fast: false
    
    name: Test - ${{ matrix.test-file }}
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
          cache: true
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Enable Android Emulator
        run: |
          EMULATOR_PATH=$(find $ANDROID_SDK_ROOT -name emulator -type d)
          export PATH=$EMULATOR_PATH:$PATH
          emulator -avd emulator -no-snapshot-load -no-window -no-audio &
          adb wait-for-device
          adb shell input keyevent 82
      
      - name: Run ${{ matrix.test-file }}
        run: |
          flutter test integration_test/${{ matrix.test-file }} --verbose
      
      - name: Upload test results for ${{ matrix.test-file }}
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: test-results-${{ matrix.test-file }}
          path: build/integration_test/
  
  all_tests_passed:
    runs-on: ubuntu-latest
    needs: integration_tests
    if: always()
    
    steps:
      - name: Check test results
        run: |
          if [ "${{ needs.integration_tests.result }}" != "success" ]; then
            echo "Integration tests failed"
            exit 1
          fi
          echo "All integration tests passed!"
```

## GitLab CI

### GitLab CI Pipeline

Create `.gitlab-ci.yml`:

```yaml
stages:
  - test
  - report

integration_tests:
  stage: test
  image: cirrusci/flutter:latest
  
  before_script:
    - flutter pub get
  
  script:
    - flutter test integration_test/ --verbose
  
  artifacts:
    paths:
      - build/integration_test/
    reports:
      junit: build/integration_test/report.xml
    when: always
    expire_in: 30 days
  
  retry:
    max: 2
    when:
      - runner_system_failure
      - stuck_or_timeout_failure

# Run specific test suites in parallel
location_permission_tests:
  stage: test
  image: cirrusci/flutter:latest
  script:
    - flutter pub get
    - flutter test integration_test/location_permission_test.dart --verbose

search_flow_tests:
  stage: test
  image: cirrusci/flutter:latest
  script:
    - flutter pub get
    - flutter test integration_test/search_flow_test.dart --verbose

favorites_management_tests:
  stage: test
  image: cirrusci/flutter:latest
  script:
    - flutter pub get
    - flutter test integration_test/favorites_flow_test.dart --verbose

settings_persistence_tests:
  stage: test
  image: cirrusci/flutter:latest
  script:
    - flutter pub get
    - flutter test integration_test/settings_persistence_test.dart --verbose

user_journey_tests:
  stage: test
  image: cirrusci/flutter:latest
  script:
    - flutter pub get
    - flutter test integration_test/user_journey_test.dart --verbose
```

## Azure Pipelines

### Azure Pipelines Configuration

Create `azure-pipelines.yml`:

```yaml
trigger:
  - main
  - develop

pr:
  - main
  - develop

pool:
  vmImage: 'ubuntu-latest'

steps:
  - task: UseDotNet@2
    inputs:
      version: '7.x'
      packageType: 'sdk'

  - script: |
      java -version
      flutter --version
    displayName: 'Check Environment'

  - script: |
      flutter pub get
    displayName: 'Get Dependencies'

  - script: |
      flutter test integration_test/ --verbose
    displayName: 'Run Integration Tests'

  - task: PublishTestResults@2
    condition: always()
    inputs:
      testResultsFormat: 'JUnit'
      testResultsFiles: 'build/integration_test/report.xml'
      publishRunAttachments: true
```

## Jenkins Pipeline

### Jenkins Declarative Pipeline

Create `Jenkinsfile`:

```groovy
pipeline {
    agent any
    
    environment {
        FLUTTER_HOME = '/usr/local/flutter'
        PATH = "${env.FLUTTER_HOME}/bin:${env.PATH}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup') {
            steps {
                sh '''
                    flutter --version
                    flutter pub get
                '''
            }
        }
        
        stage('Integration Tests') {
            steps {
                sh 'flutter test integration_test/ --verbose'
            }
        }
        
        stage('Test Report') {
            steps {
                junit 'build/integration_test/report.xml'
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: 'build/integration_test/**', 
                           allowEmptyArchive: true
            cleanWs()
        }
        
        failure {
            echo 'Integration tests failed'
        }
        
        success {
            echo 'Integration tests passed'
        }
    }
}
```

## Test Reporting

### Generate Test Report

```bash
# Run tests with XML output
flutter test integration_test/ \
  --machine \
  --file-reporter=json:build/integration_test/report.json

# Convert to JUnit format
dart run junitreport:tojunitxml \
  -i build/integration_test/report.json \
  -o build/integration_test/report.xml
```

### GitHub Actions Publish Results

Add to your workflow:

```yaml
- name: Publish test results
  if: always()
  uses: EnricoMi/publish-unit-test-result-action@v2
  with:
    files: build/integration_test/report.xml
    check_name: Integration Test Results
    comment_mode: always
```

## Performance Monitoring

### Track Test Duration

Add to your pipeline to track performance over time:

```yaml
- name: Extract test duration
  run: |
    if [ -f "build/integration_test/duration.txt" ]; then
      DURATION=$(cat build/integration_test/duration.txt)
      echo "Test Duration: $DURATION seconds"
    fi
```

## Best Practices

1. **Run on Every PR**: Ensure integration tests run before merges
2. **Parallel Execution**: Split tests across multiple jobs
3. **Timeout Handling**: Set reasonable timeouts (300-600 seconds)
4. **Artifact Storage**: Save test results and screenshots
5. **Notifications**: Alert team on test failures
6. **Report Tracking**: Monitor test statistics over time
7. **Device Variance**: Test on multiple Android/iOS versions if possible
8. **Network Mocking**: Consider mocking network calls for reliability

## Troubleshooting CI/CD

### Emulator Issues
```bash
# Pre-create and start emulator
sdkmanager "system-images;android-31;google_apis;x86_64"
avdmanager create avd -n emulator -k "system-images;android-31;google_apis;x86_64"
emulator -avd emulator -no-window -no-snapshot &
```

### Memory Issues
```yaml
# Increase available memory
pool:
  vmImage: 'ubuntu-latest'
  demands:
    - java
    - Agent.Version -gtVersion 2.144.0
```

### Network Timeouts
```bash
# Add retries
flutter test integration_test/ \
  --timeout 600 \
  --verbose
```

### Missing Dependencies
```bash
# Ensure all deps are cached
flutter pub get --offline  # Or without --offline for fresh deps
```

## Monitoring & Alerts

### Email Notifications

GitHub Actions:
```yaml
- name: Send failure notification
  if: failure()
  uses: dawidd6/action-send-mail@v3
  with:
    server_address: ${{ secrets.MAIL_SERVER }}
    server_port: ${{ secrets.MAIL_PORT }}
    username: ${{ secrets.MAIL_USERNAME }}
    password: ${{ secrets.MAIL_PASSWORD }}
    subject: Integration tests failed
    to: team@example.com
```

### Slack Notifications

```yaml
- name: Slack notification
  if: always()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Integration tests ${{ job.status }}'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## Success Metrics

Track and monitor:
- ✅ Test pass rate (target: 100%)
- ✅ Average test duration (target: < 5 minutes)
- ✅ Test flakiness (target: 0%)
- ✅ Device compatibility (test on 2+ Android versions)
- ✅ Failure reasons and trends

---

For more information, see the main [README.md](README.md) and [QUICK_START.md](QUICK_START.md).
