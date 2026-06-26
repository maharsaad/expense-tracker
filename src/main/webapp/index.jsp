<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String action = request.getParameter("action");
    String errorMsg = null;
    String successMsg = null;

    if (action != null) {
        com.example.loginproject.UserDAO userDAO = new com.example.loginproject.UserDAO();

        if ("login".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            com.example.loginproject.User user = userDAO.getUserByUsername(username);
            if (user != null && user.getPassword().equals(password)) {
                session.setAttribute("loggedInUser", username);
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                return;
            } else {
                errorMsg = "Invalid username or password.";
            }
        }

        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirm  = request.getParameter("confirmPassword");
            com.example.loginproject.UserDAO userDAO2 = new com.example.loginproject.UserDAO();
            if (!password.equals(confirm)) {
                errorMsg = "Passwords do not match.";
            } else if (userDAO2.getUserByUsername(username) != null) {
                errorMsg = "Username already taken.";
            } else {
                userDAO2.addUser(new com.example.loginproject.User(username, password));
                successMsg = "Account created! You can now sign in.";
                action = null;
            }
        }
    }

    String showForm = request.getParameter("form");
    if (showForm == null) showForm = "login";
    if ("register".equals(action) && errorMsg != null) showForm = "signup";
    if (successMsg != null) showForm = "login";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login & Signup</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background-color: #f8fafc; min-height: 100vh; display: flex; align-items: center; justify-content: center; color: #1e293b; overflow-x: hidden; }
        .container { display: flex; background: white; border-radius: 24px; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.1); overflow: hidden; max-width: 1000px; width: 90%; min-height: 600px; }
        .form-section { flex: 1; padding: 60px 50px; display: flex; flex-direction: column; justify-content: center; }
        .image-section { flex: 1; background: #0f172a; display: flex; align-items: center; justify-content: center; color: white; text-align: center; position: relative; overflow: hidden; }
        .image-section::before { content: ''; position: absolute; inset: 0; background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="%23334155" stroke-width="0.5" opacity="0.3"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>'); opacity: 0.4; }
        .image-content { z-index: 1; padding: 40px; }
        .image-content h2 { font-size: 2.5rem; margin-bottom: 20px; font-weight: 700; }
        .image-content p { font-size: 1.1rem; line-height: 1.6; opacity: 0.8; color: #cbd5e1; }
        .form-title { font-size: 2.5rem; font-weight: 700; margin-bottom: 10px; color: #0f172a; text-align: center; }
        .form-subtitle { color: #64748b; text-align: center; margin-bottom: 32px; font-size: 1rem; }
        .form-group { position: relative; margin-bottom: 20px; }
        .form-group i { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #94a3b8; z-index: 1; }
        .form-control { width: 100%; padding: 16px 20px 16px 48px; border: 2px solid #e2e8f0; border-radius: 12px; font-size: 1rem; outline: none; font-weight: 500; background: #fefefe; transition: all 0.3s ease; }
        .form-control:focus { border-color: #3b82f6; background: white; box-shadow: 0 0 0 4px rgba(59,130,246,0.1); }
        .btn-primary { width: 100%; background: #3b82f6; color: white; padding: 16px; border: none; border-radius: 12px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s ease; margin-top: 8px; }
        .btn-primary:hover { background: #2563eb; transform: translateY(-2px); box-shadow: 0 10px 25px rgba(59,130,246,0.3); }
        .social-login { margin-top: 28px; }
        .social-title { text-align: center; color: #64748b; margin-bottom: 16px; position: relative; font-weight: 500; }
        .social-title::before, .social-title::after { content: ''; position: absolute; top: 50%; width: 35%; height: 1px; background: #e2e8f0; }
        .social-title::before { left: 0; } .social-title::after { right: 0; }
        .social-buttons { display: flex; gap: 12px; }
        .social-btn { flex: 1; padding: 14px; border: 2px solid #e2e8f0; border-radius: 12px; background: white; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; transition: all 0.3s ease; }
        .social-btn:hover { border-color: #cbd5e1; transform: translateY(-2px); }
        .social-btn.google { color: #ea4335; } .social-btn.facebook { color: #1877f2; } .social-btn.twitter { color: #1da1f2; }
        .form-switch { text-align: center; margin-top: 28px; color: #64748b; font-weight: 500; }
        .form-switch a { color: #3b82f6; text-decoration: none; font-weight: 600; }
        .forgot-password { text-align: right; margin-bottom: 16px; }
        .forgot-password a { color: #3b82f6; text-decoration: none; font-size: 0.9rem; }
        .checkbox-group { display: flex; align-items: flex-start; margin-bottom: 20px; font-size: 0.9rem; color: #64748b; line-height: 1.5; }
        .checkbox-group input { margin-right: 12px; margin-top: 3px; accent-color: #3b82f6; transform: scale(1.2); }
        .msg-error { color: #ef4444; margin-bottom: 16px; font-weight: 500; text-align: center; background: #fef2f2; padding: 10px 16px; border-radius: 10px; font-size: 0.9rem; }
        .msg-success { color: #10b981; margin-bottom: 16px; font-weight: 500; text-align: center; background: #f0fdfa; padding: 10px 16px; border-radius: 10px; font-size: 0.9rem; }
        .form-container { display: none; }
        .form-container.active { display: block; animation: fadeIn 0.4s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 768px) { .container { flex-direction: column; max-width: 420px; } .image-section { min-height: 200px; order: -1; } .form-section { padding: 40px 30px; } }
    </style>
</head>
<body>
<div class="container">
    <div class="form-section">

        <!-- LOGIN FORM -->
        <div class="form-container <%= "login".equals(showForm) ? "active" : "" %>" id="loginForm">
            <h1 class="form-title">Welcome Back</h1>
            <p class="form-subtitle">Sign in to your account to continue</p>

            <% if (errorMsg != null && "login".equals(action)) { %>
            <p class="msg-error"><%= errorMsg %></p>
            <% } %>
            <% if (successMsg != null) { %>
            <p class="msg-success"><%= successMsg %></p>
            <% } %>

            <form action="index.jsp" method="post">
                <input type="hidden" name="action" value="login">
                <div class="form-group">
                    <i class="fas fa-user"></i>
                    <input type="text" name="username" class="form-control" placeholder="Username" required>
                </div>
                <div class="form-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="form-control" placeholder="Password" required>
                </div>
                <div class="forgot-password"><a href="#">Forgot Password?</a></div>
                <button type="submit" class="btn-primary">Sign In</button>
            </form>

            <div class="social-login">
                <div class="social-title">Or continue with</div>
                <div class="social-buttons">
                    <div class="social-btn google"><i class="fab fa-google"></i></div>
                    <div class="social-btn facebook"><i class="fab fa-facebook-f"></i></div>
                    <div class="social-btn twitter"><i class="fab fa-twitter"></i></div>
                </div>
            </div>
            <div class="form-switch">
                Don't have an account? <a href="index.jsp?form=signup">Create one</a>
            </div>
        </div>

        <!-- SIGNUP FORM -->
        <div class="form-container <%= "signup".equals(showForm) ? "active" : "" %>" id="signupForm">
            <h1 class="form-title">Create Account</h1>
            <p class="form-subtitle">Join us and start tracking your finances</p>

            <% if (errorMsg != null && "register".equals(action)) { %>
            <p class="msg-error"><%= errorMsg %></p>
            <% } %>

            <form action="index.jsp" method="post">
                <input type="hidden" name="action" value="register">
                <div class="form-group">
                    <i class="fas fa-user"></i>
                    <input type="text" name="username" class="form-control" placeholder="Username" required>
                </div>
                <div class="form-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="form-control" placeholder="Password" required>
                </div>
                <div class="form-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm Password" required>
                </div>
                <div class="checkbox-group">
                    <input type="checkbox" id="terms" required>
                    <label for="terms">I agree to the <a href="#" style="color:#3b82f6;font-weight:600;">Terms of Service</a> and <a href="#" style="color:#3b82f6;font-weight:600;">Privacy Policy</a></label>
                </div>
                <button type="submit" class="btn-primary">Create Account</button>
            </form>

            <div class="social-login">
                <div class="social-title">Or sign up with</div>
                <div class="social-buttons">
                    <div class="social-btn google"><i class="fab fa-google"></i></div>
                    <div class="social-btn facebook"><i class="fab fa-facebook-f"></i></div>
                    <div class="social-btn twitter"><i class="fab fa-twitter"></i></div>
                </div>
            </div>
            <div class="form-switch">
                Already have an account? <a href="index.jsp">Sign in</a>
            </div>
        </div>

    </div>

    <div class="image-section">
        <div class="image-content">
            <% if ("signup".equals(showForm)) { %>
            <h2>Welcome Back!</h2>
            <p>To keep connected with us please login with your personal information</p>
            <% } else { %>
            <h2>Hello, Friend!</h2>
            <p>Enter your personal details and start your journey with us today</p>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>