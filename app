import os
from datetime import datetime
from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "change-this-for-local-development")

# If MySQL is configured in .env, use it. Otherwise SQLite makes the project easy to run.
mysql_url = os.getenv("DATABASE_URL", "").strip()
if mysql_url:
    app.config["SQLALCHEMY_DATABASE_URI"] = mysql_url
else:
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///fraud_detection.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)


class Transaction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    customer_name = db.Column(db.String(100), nullable=False)
    account_id = db.Column(db.String(40), nullable=False)
    amount = db.Column(db.Float, nullable=False)
    transaction_time = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    location = db.Column(db.String(100), nullable=False, default="Unknown")
    status = db.Column(db.String(20), nullable=False, default="Pending")
    risk_score = db.Column(db.Integer, nullable=False, default=0)
    reason = db.Column(db.String(255), nullable=False, default="No rule triggered")


def assess_transaction(amount, location):
    """Transparent demonstration rules; not a production fraud model."""
    score = 0
    reasons = []
    if amount >= 50000:
        score += 60
        reasons.append("High transaction amount")
    elif amount >= 20000:
        score += 30
        reasons.append("Unusually large amount")
    if location.strip().lower() in {"unknown", "overseas", "foreign", "unverified"}:
        score += 25
        reasons.append("Unverified or unusual location")
    if not reasons:
        reasons.append("No rule triggered")
    status = "Flagged" if score >= 50 else ("Review" if score >= 25 else "Normal")
    return score, status, ", ".join(reasons)


@app.route("/")
def dashboard():
    transactions = Transaction.query.order_by(Transaction.transaction_time.desc()).all()
    total = len(transactions)
    flagged = sum(t.status == "Flagged" for t in transactions)
    review = sum(t.status == "Review" for t in transactions)
    total_amount = sum(t.amount for t in transactions)
    return render_template(
        "index.html",
        transactions=transactions,
        total=total,
        flagged=flagged,
        review=review,
        total_amount=total_amount,
    )


@app.route("/add", methods=["GET", "POST"])
def add_transaction():
    if request.method == "POST":
        try:
            customer_name = request.form["customer_name"].strip()
            account_id = request.form["account_id"].strip()
            amount = float(request.form["amount"])
            location = request.form["location"].strip() or "Unknown"
            if not customer_name or not account_id or amount < 0:
                raise ValueError
            score, status, reason = assess_transaction(amount, location)
            item = Transaction(
                customer_name=customer_name,
                account_id=account_id,
                amount=amount,
                location=location,
                transaction_time=datetime.now(),
                status=status,
                risk_score=score,
                reason=reason,
            )
            db.session.add(item)
            db.session.commit()
            flash(f"Transaction added. Risk status: {status}.", "success")
            return redirect(url_for("dashboard"))
        except (ValueError, KeyError):
            flash("Please enter valid details and a non-negative amount.", "error")
    return render_template("add_transaction.html")


@app.route("/seed")
def seed_demo_data():
    """Adds sample rows only when the database is empty."""
    if Transaction.query.count() == 0:
        samples = [
            ("Asha Rao", "AC1001", 1200, "Tirupati"),
            ("Kiran Kumar", "AC1002", 28500, "Hyderabad"),
            ("Meera Das", "AC1003", 78000, "Overseas"),
            ("Rahul Varma", "AC1004", 5000, "Chennai"),
            ("Nisha Reddy", "AC1005", 56000, "Unknown"),
        ]
        for name, account, amount, location in samples:
            score, status, reason = assess_transaction(amount, location)
            db.session.add(Transaction(
                customer_name=name,
                account_id=account,
                amount=amount,
                location=location,
                status=status,
                risk_score=score,
                reason=reason,
            ))
        db.session.commit()
        flash("Demo transactions added.", "success")
    else:
        flash("Sample data was not added because transactions already exist.", "info")
    return redirect(url_for("dashboard"))


@app.route("/delete/<int:transaction_id>", methods=["POST"])
def delete_transaction(transaction_id):
    item = db.session.get(Transaction, transaction_id)
    if item:
        db.session.delete(item)
        db.session.commit()
        flash("Transaction deleted.", "success")
    return redirect(url_for("dashboard"))


with app.app_context():
    db.create_all()


if __name__ == "__main__":
    app.run(debug=True)
