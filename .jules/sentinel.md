## 2024-05-18 - [CRITICAL] Hardcoded Keystore and Passwords in Repository
**Vulnerability:** Android keystore files (`upload-keystore.jks`) and their associated credentials (`key.properties`) were committed to version control.
**Learning:** Checking in keystores and their passwords allows anyone with repository access to build and sign malicious versions of the Android app that would be accepted as official updates by app stores.
**Prevention:** Keystores (`*.jks`, `*.keystore`) and property files containing credentials (`key.properties`) must be added to `.gitignore`. A `.example` file can be provided to specify the format of the required properties file without exposing real credentials.
