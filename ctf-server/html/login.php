<?php
session_start();

$message = "";
$flag = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    // INTENTIONALLY VULNERABLE TO SQL INJECTION — FOR EDUCATIONAL USE ONLY
    // This is a CTF challenge. Do NOT use this pattern in real applications.
    $db = new SQLite3('/var/www/data/users.db');
    $query = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
    $result = $db->query($query);

    if ($result) {
        $row = $result->fetchArray();
        if ($row) {
            $message = "Welcome, " . htmlspecialchars($row['username']) . "! Role: " . htmlspecialchars($row['role']);
            if ($row['role'] === 'hidden') {
                $flag = $row['password'];
            }
        } else {
            $message = "Invalid username or password.";
        }
    } else {
        $message = "Query error — but that might be useful information...";
    }
    $db->close();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - HackCraft CTF</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Courier New', monospace;
            background: #0a0a0a;
            color: #00ff41;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-box {
            background: #111;
            border: 1px solid #00ff41;
            border-radius: 8px;
            padding: 40px;
            width: 400px;
        }
        h2 { text-align: center; margin-bottom: 25px; }
        label { display: block; margin-bottom: 5px; font-size: 0.9em; }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            background: #1a1a1a;
            border: 1px solid #333;
            color: #00ff41;
            font-family: 'Courier New', monospace;
            font-size: 1em;
            border-radius: 4px;
        }
        input:focus { outline: none; border-color: #00ff41; }
        button {
            width: 100%;
            padding: 12px;
            background: #00ff41;
            color: #0a0a0a;
            border: none;
            font-family: 'Courier New', monospace;
            font-size: 1em;
            font-weight: bold;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover { background: #00cc33; }
        .message {
            margin-top: 15px;
            padding: 10px;
            background: #1a1a1a;
            border-radius: 4px;
            text-align: center;
        }
        .flag {
            color: #ffcc00;
            font-weight: bold;
            font-size: 1.1em;
            margin-top: 10px;
        }
        .hint {
            color: #666;
            font-size: 0.8em;
            text-align: center;
            margin-top: 20px;
        }
        a { color: #00ff41; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>🔒 Secure Login</h2>
        <form method="POST" action="">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter username" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" required>

            <button type="submit">LOGIN</button>
        </form>

        <?php if ($message): ?>
            <div class="message"><?php echo $message; ?></div>
        <?php endif; ?>

        <?php if ($flag): ?>
            <div class="flag">🚩 <?php echo htmlspecialchars($flag); ?></div>
        <?php endif; ?>

        <p class="hint">
            Hint: There are 3 users in the database. One of them is hidden.<br>
            Can you log in without knowing the password?<br><br>
            <a href="/">← Back to CTF Home</a>
        </p>
    </div>
</body>
</html>
