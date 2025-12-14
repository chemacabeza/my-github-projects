# Section 8: Troubleshooting Fooocus

Common issues when using Fooocus on Google Colab and their solutions.

## 1. "Cannot connect to GPU backend"

**Symptom**: You try to start the Colab notebook, but it refuses to connect.
**Cause**: You may have run out of "Compute Units" (credits) on your Google account.
**Solution**:
*   Wait for the daily free quota reset (usually 12-24 hours).
*   Switch to a paid Colab Pro subscription.
*   Try using a different Google account.

## 2. "Connection Error" or UI Freezing

**Symptom**: You are using Fooocus, and suddenly:
*   Red error boxes appear in the interface.
*   The generation progress bar freezes.
*   The interface becomes unresponsive.

**Cause**:
*   **Timeouts**: Google Colab has a timeout limit (especially for free tier users). If you leave the tab idle or run it for too long, it disconnects.
*   **Memory Crash**: Sometimes generating very large batches or upscale factors crashes the RAM.

**Solution**:
1.  **Check the Colab Tab**: Go back to the browser tab running the code.
2.  **Restart**: If the cell has stopped (the "Play" button is visible again), you must click "Play" to restart the session.
3.  **New Link**: A new public URL (gradio.live) will be generated. You must use the new link; the old one will effectively be dead.

---
[Previous Section](Section-7.md) | [Next Section](Section-9.md)
