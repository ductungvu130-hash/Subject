document.getElementById('registrationForm').addEventListener('submit', function(event) {
    event.preventDefault();

    document.querySelectorAll('.error').forEach(el => el.textContent = '');

    const fullName = document.getElementById('fullname').value.trim();
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmpassword').value;
    const phone = document.getElementById('phone').value.trim();

    let isValid = true;

    if (fullName === '') {
        document.getElementById('fullnameError').textContent = "Full Name must not be empty.";
        isValid = false;
    }

    if (email === '') {
        document.getElementById('emailError').textContent = "Email must not be empty.";
        isValid = false;
    }

    if (password === '') {
        document.getElementById('passwordError').textContent = "Password must not be empty.";
        isValid = false;
    }

    if (confirmPassword === '') {
        document.getElementById('confirmpasswordError').textContent = "Confirm Password must not be empty.";
        isValid = false;
    }

    if (phone === '') {
        document.getElementById('phoneError').textContent = "Phone Number must not be empty.";
        isValid = false;
    }

    if (password !== '' && confirmPassword !== '' && password !== confirmPassword) {
        document.getElementById('confirmpasswordError').textContent = "Password and Confirm Password must match.";
        isValid = false;
    }

    const phoneRegex = /^\d{10}$/; 
    if (phone !== '' && !phoneRegex.test(phone)) {
        document.getElementById('phoneError').textContent = "Phone Number must be exactly 10 digits long.";
        isValid = false;
    }

    if (isValid) {
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.style.opacity = '0.5';

        setTimeout(() => {
            alert("Registration Successful!");
            submitBtn.style.opacity = '1';
        }, 1000);
    }
});