#!/bin/bash

# Define the target URL to shorten
DEFAULT_URL="https://www.google.com"
TARGET_URL="${1:-$DEFAULT_URL}"

# Define the API endpoint
API_ENDPOINT="http://localhost:5000/"

echo "Starting test for the URL Shortener service"
echo "Target URL: $TARGET_URL"
echo "----------------------------------------"

# --- Step 1: Create a short URL ---
echo "1. Creating a short link for \"$TARGET_URL\" "

# Send a POST request. -s enables silent mode (only output the result).
# The server response is stored in the RESPONSE variable.
RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d "{\"url\": \"$TARGET_URL\"}" \
  $API_ENDPOINT)

# --- Step 2: Parse the response to get the short URL ---
# Use sed to extract the value of "short_url" from the JSON response.
# This method is general and does not require extra tools like jq.
SHORT_URL=$(echo $RESPONSE | sed -n 's/.*"short_url":"\([^"]*\)".*/\1/p')

# Check if the short URL was successfully obtained
if [ -z "$SHORT_URL" ]; then
    echo "Error: Failed to create short URL!"
    echo "Server response: $RESPONSE"
    exit 1 # Exit script with error
fi

echo "Success. Short URL obtained: $SHORT_URL"
echo "----------------------------------------"

# --- Step 3: Test the redirection ---
echo "2. Testing redirection"

# Use curl to follow the redirect and get the final destination URL
FINAL_URL=$(curl -L -s -o /dev/null -w "%{url_effective}" $SHORT_URL)

echo "Redirected to: $FINAL_URL"

# --- Step 4: Verify the result ---
if [ "${FINAL_URL%/}" == "${TARGET_URL%/}" ]; then
    echo "Success: Redirect matches the original URL"
    echo "Test passed"
else
    echo "Failure: Redirect does not match the original URL"
    echo "Expected: $TARGET_URL"
    echo "Actual:   $FINAL_URL"
fi

echo "----------------------------------------"