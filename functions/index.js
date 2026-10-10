const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");

initializeApp();

exports.resetPasswordAfterPhoneVerification = onCall(
  {
    region: "us-central1",
  },
  async (request) => {
    // User must be authenticated through Firebase Phone Auth.
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "You must verify your phone number first."
      );
    }

    const uid = request.auth.uid;
    const newPassword = request.data?.newPassword;

    // Validate password
    if (
      typeof newPassword !== "string" ||
      newPassword.length < 6
    ) {
      throw new HttpsError(
        "invalid-argument",
        "Password must be at least 6 characters long."
      );
    }

    // Get current Firebase user
    let userRecord;

    try {
      userRecord = await getAuth().getUser(uid);
    } catch (error) {
      console.error("User lookup failed:", error);

      throw new HttpsError(
        "not-found",
        "User account could not be found."
      );
    }

    // Make sure the account has a verified phone
    if (!userRecord.phoneNumber) {
      throw new HttpsError(
        "failed-precondition",
        "This account does not have a verified phone number."
      );
    }

    // Make sure the account uses email/password
    const hasPasswordProvider =
      userRecord.providerData.some(
        (provider) => provider.providerId === "password"
      );

    if (!hasPasswordProvider) {
      throw new HttpsError(
        "failed-precondition",
        "This account does not use email/password authentication."
      );
    }

    // Update password
    try {
      await getAuth().updateUser(uid, {
        password: newPassword,
      });

      return {
        success: true,
        message: "Password updated successfully.",
      };
    } catch (error) {
      console.error("Password update failed:", error);

      throw new HttpsError(
        "internal",
        "Unable to update the password."
      );
    }
  }
);