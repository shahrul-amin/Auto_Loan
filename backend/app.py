from flask import Flask, jsonify
from flask_cors import CORS
from flask_mail import Mail
from config import Config
from services.firebase_service import FirebaseService
from services.email_service import EmailService

app = Flask(__name__)
app.config.from_object(Config)

CORS(app, origins=Config.CORS_ORIGINS, supports_credentials=True)

# Initialize Flask-Mail
mail = Mail(app)

firebase_service = FirebaseService()
email_service = EmailService(mail, firebase_service)

@app.route('/', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'ok',
        'message': 'Auto Loan Backend API is running',
        'version': '1.0.0'
    }), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        'error': 'Not Found',
        'message': 'The requested resource was not found'
    }), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        'error': 'Internal Server Error',
        'message': 'An unexpected error occurred'
    }), 500

from routes import auth_routes, user_routes, personal_info_routes, employment_info_routes, banks_routes, credit_score_routes, loan_applications_routes, dashboard_routes, loan_approval_routes

app.register_blueprint(auth_routes.bp)
app.register_blueprint(user_routes.bp)
app.register_blueprint(personal_info_routes.bp)
app.register_blueprint(employment_info_routes.bp)
app.register_blueprint(banks_routes.bp)
app.register_blueprint(credit_score_routes.bp)
app.register_blueprint(loan_applications_routes.bp)
app.register_blueprint(dashboard_routes.bp)
app.register_blueprint(loan_approval_routes.bp)

if __name__ == '__main__':
    print(f"Starting Flask server on port {Config.PORT}")
    print(f"Environment: {Config.FLASK_ENV}")
    host = '0.0.0.0' if Config.FLASK_ENV == 'development' else '127.0.0.1'
    
    if host == '0.0.0.0':
        print("WARNING: Server is accessible from network (development mode)")
    
    app.run(host=host, port=Config.PORT, debug=Config.DEBUG)
