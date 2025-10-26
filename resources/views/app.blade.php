<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <title>Laravel Inertia Example / render</title>
    @vite('resources/js/app.jsx')
</head>
<body>
    @inertia
</body>
</html>
