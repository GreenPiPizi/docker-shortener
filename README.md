# Docker URL Shortener Project

This is a simple URL shortening service built with Docker, Flask, and Redis.


## How to Run

**Prerequisites:** You need to have [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/) installed.

### **1. Start the Service**

From the project root directory, run the following command to start the application:

```bash
docker-compose up --build
```
After the service starts, **keep the terminal window open**.


### **2. Run Automated Tests**

We provide a `test.sh` script to automate testing.

**Setup (only needed once):**  
Open a new terminal window, navigate to the project root directory, and make the script executable:

```bash
chmod +x test.sh
```

**Usage 1: Test with the Default URL (Google)**

If you run the script without any arguments, it will automatically test shortening the URL https://www.google.com:

```bash
./test.sh
```
You will see output indicating the script is testing Google’s URL.

**Usage 2: Specify Your Own URL**

You can also provide any URL as an argument when running the script. It will shorten and test the URL you provide.

Example:
```bash
# Test a GitHub URL
./test.sh https://www.github.com
```

Make sure the URL includes **http://** or **https://**