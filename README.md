Financial Risk Analysis and Rule-Based Fraud Detection System
A beginner-friendly academic web application built with Python, Flask, SQLAlchemy, HTML, and CSS. It records transactions, applies transparent rule-based risk checks, and displays the results in a dashboard.
> **Important:** This is a learning/demo project. The rules are illustrative and are not a validated fraud model. Do not use it to make real financial decisions.
Features
Dashboard with transaction count, flagged count, review count, and total value
Add transaction form
Rule-based risk score and status
Transaction history with reasons for alerts
Delete transaction action
Demo data button
SQLite works by default; optional MySQL configuration
Responsive layout
Fraud detection rules
Rule	Points
Amount is ₹50,000 or more	+60
Otherwise, amount is ₹20,000 or more	+30
Location is Unknown, Overseas, Foreign, or Unverified	+25
Statuses:
Flagged: score ≥ 50
Review: score 25–49
Normal: score below 25
These are sample rules for demonstration. Real fraud detection needs validated data, monitoring, privacy/security controls, and expert review.
Run on Windows
Install Python 3.10 or newer.
Extract/download this project and open its folder in VS Code or PyCharm.
Open a terminal in the project folder.
Create a virtual environment:
```powershell
   py -m venv .venv
   .venv\Scripts\activate
   ```
Install packages:
```powershell
   pip install -r requirements.txt
   ```
Start the application:
```powershell
   python app.py
   ```
Open http://127.0.0.1:5000 in Chrome.
Click Load demo data to populate sample transactions.
The default configuration uses a local SQLite database, so you do not need MySQL just to try the app.
Optional MySQL setup
Start MySQL Server.
Create a database:
```sql
   CREATE DATABASE fraud_detection;
   ```
Copy `.env.example` to `.env`.
Set `DATABASE_URL` in `.env` using this format:
```text
   DATABASE_URL=mysql+pymysql://root:YOUR_PASSWORD@localhost:3306/fraud_detection
   ```
Replace `YOUR_PASSWORD` with your local MySQL password. Do not commit `.env` or passwords to GitHub.
Run the app again:
```powershell
   python app.py
   ```
SQLAlchemy creates the required table when the app starts. `schema.sql` is included as a reference.
Main files
`app.py` — Flask routes, database model, and risk scoring rules
`templates/` — dashboard and add-transaction pages
`static/style.css` — page styling
`schema.sql` — optional MySQL schema reference
`.env.example` — configuration template
`requirements.txt` — Python dependencies
Push to GitHub
Create a new repository at https://github.com/new
Repository name: `financial-risk-fraud-detection`
Choose Public or Private as appropriate for your college rules.
Do not add a README during repository creation if you are uploading this folder's existing README.
In a terminal opened inside this project folder, run:
```powershell
   git init
   git add .
   git commit -m "Initial fraud detection project"
   git branch -M main
   git remote add origin https://github.com/YOUR-GITHUB-USERNAME/financial-risk-fraud-detection.git
   git push -u origin main
   ```
Replace `YOUR-GITHUB-USERNAME` with your actual GitHub username. GitHub may ask you to sign in through a browser.
Your repository URL will be:
`https://github.com/YOUR-GITHUB-USERNAME/financial-risk-fraud-detection`
Suggested project description
Financial Risk Analysis and Rule-Based Fraud Detection System using Python Flask and SQLAlchemy/MySQL. Includes a transaction dashboard, explainable risk scoring rules, and sample data for academic demonstration.
Suggested improvements
Authentication and role-based access
Input validation and audit logging
Date/time and velocity-based rules
Unit tests and reporting/export
A trained ML model evaluated on an appropriate public dataset
Deployment with environment variables and production security settings
