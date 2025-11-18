import os
import google.generativeai as genai

print("Attempting to initialize Gemini model...")
print("The library should automatically use Application Default Credentials (ADC).")

try:
    model = genai.GenerativeModel('gemini-1.5-flash-latest')

    print("Model initialized. Sending a test prompt...")

    # Set a timeout for the generate_content call
    response = model.generate_content("test", request_options={'timeout': 30})

    print("Successfully received a response from the Gemini API.")
    print("Response:", response.text)
    print("\nSUCCESS: Your environment is correctly configured to call the Gemini API.")

except Exception as e:
    print(f"\nERROR: An exception occurred: {type(e).__name__}")
    print(e)
    print("\nFAILURE: Your environment is NOT correctly configured.")
    print("Please check the following:")
    print("1. Have you run 'gcloud auth application-default login' on your host machine?")
    print("2. Is the Vertex AI API or Generative Language API enabled in your GCP project?")
    print("3. Does the authenticated user/service account have the 'Vertex AI User' or 'AI Platform User' IAM role?")
    print("4. Is there a firewall or network policy blocking outbound traffic to *.googleapis.com?")
