Features

Firebase Email/Password Authentication

Users can sign up and log in using email and password.

Fingerprint Authentication (Biometric Login)

After login, users can enable fingerprint authentication for future app unlocks.

The app stores a local flag securely to remember fingerprint login preference.

On next launch, if fingerprint login is enabled, the user is prompted to unlock with fingerprint.

If authentication fails, is canceled, or not available, the normal login screen is shown.

User Roles

Supports two roles: Admin and Normal User.

Role is determined based on email:

Admin: admin@gmail.com

Normal User: xa@gmail.com

Role-Based Dashboard

After login or successful fingerprint authentication, the dashboard displays the user type (Admin or User).

Logout

Users can log out, clearing authentication and fingerprint login preferences.