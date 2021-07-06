# Changelog iOS

## Verify SDK 2.1.4
- Updates push token for native support for ISV

## Verify SDK 2.1.3
- Updates push token for native support for ISVA

## Verify SDK 2.1.2
- Fixes Base32 decoding
- Fixes self-signed certificate pinning against VPN

## Verify SDK 2.1.1
- Improves logging removing sensitive information from being output
- Improves biometry determination
- Improves Base32 decoding removing unsafe pointer support
- Updates pushToken from device attributes on AuthenticatorContext.refresh()
deviceIdentifier saved to Keychain
- Updates push token for native support

## Verify SDK 2.0.6
- New `xcframework` build.
- Add theming support for Cloud Identity.
- Make OAuth token refresh optional during parsing.
- Add support for customised headers to `AuthenticatorContext`; on-prem support only.

## Verify SDK 2.0.5
- Enhances `Base64EncodingOptions` with `safeUrlCharacters` and `noPaddingCharacters`.
- Recompile for Swift 5.1 and Xcode 11.
- Parse theming information from ISAM.

## Verify SDK 2.0.4
- Support for QR code scanning for Cloud Identity login.
- OnPremiseAuthenticator includes the `qrloginUri` endpoint.
- Fixes on-premises filtering of pending transactions by `authenticator_id`.
- Fixes threading issue in `OAuthContext`.
- Recompile for Swift 5 and Xcode 10.2.
- Enhances TOTP enrolment parsing for on-premises authenticators.  
- Persist the `deviceId` in `RegistrationAttributes`
- Update TOTP period validation. 

## Verify SDK 2.0.2
- Support certificate pinning 
- Support default implementations for `ignoreSsl == true`

## Verify SDK 2.0.1
- n/a

## Verify SDK 2.0.0
- Replacing Mobile Access SDK v1
- Supporting both on-premises and cloud based multi-factor authenticators
- Enhanced security features that apply to both on-premise and cloud

## Mobile Access SDK v1.3.0
- Support for Xcode 10 and Swift 4.2
- Remove voice biometric proof of concept and associated dependencies.

## Mobile Access SDK v1.2.9
- Added support for Hmac prefix to hash algorithms for one-time password (OTP) generation.
- `ChallengeContext.shared.pendingTransactions` will return an empty PendingTransaction array if no transactions are parsed.
- `IBMMobileKitError.unauthenticated` is returned when the HTTP response content-type is not JSON or the status code is a 401.

## Mobile Access SDK v1.2.8
- Face ID support for internationalisation (Czech, German, Spanish, French, Hungarian, Italian, Japanese, Korean, Polish, Portuguese, Russian, Chinese (Simplified and Taiwan))

## Mobile Access SDK v1.2.7
- Support for Xcode 9.1.
- Renamed sharedInstance to shared for context classes to be more consistent with iOS SDK conventions.
- `OAuthToken.createAuthorizationHeader()` returns a non-optional String
- Support for iPhone X Face ID.
- Fixes `NSLog` support for encoded values.
- Support for getting version information from `FrameworkHelper`.

## Mobile Access SDK v1.2.6
- Support for checking if key pair exists.

## Mobile Access SDK v1.2.5
- Build target updated to iOS 9 or greater.
- Support for private key generation with an access control constraint.
- Support for determining if keys may be invalidated for a domain state.
- `UIQRScanView` exposes configurable properties to display a border on successful and unsuccessful scans.
- Fix issue in `UIQRScanView.startCapture()` to reactivate the camera after a scan.

## Mobile Access SDK v1.2.4
- Support for custom headers in `OAuthContext`.
- Support Base64 encoding options for public key export and data signing.
- `OAuthContext` applies safe url encoding to all parameters.
- String extension `urlSafeEncodedValue` supports Base64 string encoding.
- Objective-C support for `OAuthContext`

## Mobile Access SDK v1.2.0
- Support for Swift 3.1
- Support for Xcode universal framework
- Support for internationalisation.
  * Czech, German, Spanish, French, Hungarian, Italian, Japanese, Korean, Polish, Portuguese, Russian, Chinese (Simplified and Taiwan) 
- Support for multi-factor (MFA) and non-MFA authentication enrolment
  * Touch ID
  * User presence enrolment
  * HOTP enrolment
  * TOTP enrolment
- Support for multi-factor (MFA) authentication unenrolment
  * Touch ID
  * User presence enrolment
- Support for context based challenge and verification
  * Touch ID
  * User presence enrolment
  * HOTP enrolment
  * TOTP enrolment
  * Username password
- Support for extending the context based challenge framework
- Support for querying pending challenges

## Mobile Access SDK v1.0.0
- Support for OAuth ROPC and AZN code flow
- Support for HMAC generated one-time password (HOTP)
- Support for time generated one-time password (TOTP)
