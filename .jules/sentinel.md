## 2024-04-03 - Exposed Android Keystore Files
**Vulnerability:** Found `keystore.txt` (a base64 encoded Android signing keystore) and `sha.txt` committed in the root directory.
**Learning:** Developers often extract and save base64 keystores for CI/CD environments but mistakenly commit these temporary files to the repository, compromising the app's signing integrity.
**Prevention:** Always add `*.jks`, `keystore.txt`, `sha.txt`, and other keystore/signing related artifacts to `.gitignore` to prevent accidental commits of production signing keys.
