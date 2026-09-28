setTimeout(() => {
            document.querySelectorAll(".hidden").forEach(alert => {
                alert.style.display = "none";
            });
        }, 5000);