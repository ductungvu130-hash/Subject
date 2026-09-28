/* RoomieCoin - shared front-end helpers (demo, dữ liệu lưu trong localStorage) */
(function () {
  "use strict";

  var RC = {};

  /* ---------- Toast ---------- */
  function ensureToastHost() {
    var host = document.getElementById("rc-toast-host");
    if (!host) {
      host = document.createElement("div");
      host.id = "rc-toast-host";
      host.style.cssText = [
        "position:fixed", "right:16px", "bottom:16px", "z-index:9999",
        "display:flex", "flex-direction:column", "gap:8px",
        "align-items:flex-end", "pointer-events:none"
      ].join(";");
      document.body.appendChild(host);
    }
    return host;
  }

  RC.toast = function (message, type) {
    type = type || "success";
    var colors = { success: "#0f9d58", error: "#d93025", info: "#1a73e8" };
    var host = ensureToastHost();
    var el = document.createElement("div");
    el.textContent = message;
    el.style.cssText = [
      "background:" + (colors[type] || colors.success),
      "color:#fff", "padding:10px 16px", "border-radius:10px",
      "font-family:'Inter',sans-serif", "font-size:14px", "font-weight:500",
      "box-shadow:0 8px 24px rgba(0,0,0,0.18)", "max-width:320px",
      "opacity:0", "transform:translateY(8px)",
      "transition:opacity .2s ease, transform .2s ease", "pointer-events:auto"
    ].join(";");
    host.appendChild(el);
    requestAnimationFrame(function () {
      el.style.opacity = "1";
      el.style.transform = "translateY(0)";
    });
    setTimeout(function () {
      el.style.opacity = "0";
      el.style.transform = "translateY(8px)";
      setTimeout(function () { el.remove(); }, 220);
    }, 2600);
  };

  /* ---------- LocalStorage ---------- */
  RC.get = function (key, fallback) {
    try {
      var raw = localStorage.getItem("rc_" + key);
      return raw === null ? fallback : JSON.parse(raw);
    } catch (e) { return fallback; }
  };
  RC.set = function (key, value) {
    try { localStorage.setItem("rc_" + key, JSON.stringify(value)); }
    catch (e) { /* storage may be unavailable, ignore */ }
  };

  /* ---------- Clipboard ---------- */
  RC.copy = function (text, successMsg) {
    var done = function () { RC.toast(successMsg || ("Đã sao chép: " + text)); };
    var fail = function () {
      var ta = document.createElement("textarea");
      ta.value = text;
      ta.style.position = "fixed";
      ta.style.opacity = "0";
      document.body.appendChild(ta);
      ta.focus();
      ta.select();
      try { document.execCommand("copy"); done(); }
      catch (e) { RC.toast("Không thể sao chép tự động: " + text, "error"); }
      ta.remove();
    };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(done).catch(fail);
    } else { fail(); }
  };

  /* ---------- Currency ---------- */
  RC.formatVND = function (n) {
    n = Number(n) || 0;
    return n.toLocaleString("vi-VN") + " đ";
  };
  RC.parseVND = function (s) {
    return parseInt(String(s).replace(/\D/g, ""), 10) || 0;
  };

  /* ---------- Dark mode (persisted across pages) ---------- */
  RC.applyDarkMode = function () {
    var on = RC.get("dark", false);
    document.documentElement.classList.toggle("dark", !!on);
    return !!on;
  };
  RC.setDarkMode = function (on) {
    RC.set("dark", !!on);
    document.documentElement.classList.toggle("dark", !!on);
  };
  RC.applyDarkMode();

  /* ---------- Simple dropdown menu (for "more_vert" buttons) ---------- */
  RC.openMenu = function (anchorEl, items) {
    var existing = document.getElementById("rc-dropdown-menu");
    if (existing) existing.remove();
    var rect = anchorEl.getBoundingClientRect();
    var menu = document.createElement("div");
    menu.id = "rc-dropdown-menu";
    menu.style.cssText = [
      "position:fixed", "top:" + (rect.bottom + 6) + "px",
      "left:" + Math.max(8, rect.right - 180) + "px",
      "min-width:180px", "background:#fff", "border-radius:10px",
      "box-shadow:0 8px 28px rgba(0,0,0,0.18)", "padding:6px",
      "z-index:9999", "font-family:'Inter',sans-serif"
    ].join(";");
    items.forEach(function (it) {
      var row = document.createElement("button");
      row.type = "button";
      row.textContent = it.label;
      row.style.cssText = [
        "display:block", "width:100%", "text-align:left",
        "padding:9px 12px", "border:none", "background:transparent",
        "border-radius:6px", "font-size:14px", "cursor:pointer",
        "color:" + (it.danger ? "#c62828" : "#121c28")
      ].join(";");
      row.addEventListener("mouseenter", function () { row.style.background = "#eef4ff"; });
      row.addEventListener("mouseleave", function () { row.style.background = "transparent"; });
      row.addEventListener("click", function (e) {
        e.stopPropagation();
        menu.remove();
        if (it.onClick) it.onClick();
      });
      menu.appendChild(row);
    });
    document.body.appendChild(menu);
    setTimeout(function () {
      document.addEventListener("click", function closeOnce() {
        var m = document.getElementById("rc-dropdown-menu");
        if (m) m.remove();
        document.removeEventListener("click", closeOnce);
      });
    }, 0);
  };

  /* ---------- Notification badge (unread count shown on the bell icon) ---------- */
  RC.getUnreadCount = function () {
    return RC.get("notif_unread", 2);
  };
  RC.setUnreadCount = function (n) {
    n = Math.max(0, n);
    RC.set("notif_unread", n);
    RC.syncNotifDot();
  };
  RC.syncNotifDot = function () {
    var count = RC.getUnreadCount();
    document.querySelectorAll("button").forEach(function (btn) {
      var oc = btn.getAttribute("onclick") || "";
      if (oc.indexOf("notifications.html") === -1) return;
      var dot = btn.querySelector("span.bg-error, span.material-symbols-outlined + span");
      if (!dot) return;
      dot.style.display = count > 0 ? "" : "none";
    });
  };

  /* ---------- Expenses store (shared between add-expense.html & history/index) ---------- */
  RC.CATEGORY_ICON = {
    "Ăn uống": "restaurant", "Điện nước": "bolt", "Tiền nhà": "home",
    "Siêu thị": "shopping_cart", "Bảo trì": "plumbing", "Khác": "category"
  };
  RC.addExpense = function (expense) {
    var list = RC.get("expenses", []);
    expense.id = "e" + Date.now();
    list.unshift(expense);
    RC.set("expenses", list);
    return expense;
  };
  RC.getExpenses = function () {
    return RC.get("expenses", []);
  };

  /* ---------- Profile store ---------- */
  RC.getProfile = function () {
    return RC.get("profile", {
      name: "Nguyễn Văn A",
      email: "nguyenvana@example.com",
      phone: "0901234567",
      bank: "tcb",
      account: "19031234567890"
    });
  };
  RC.setProfile = function (p) { RC.set("profile", p); };

  /* ---------- Hidden file input helper (simulated upload) ---------- */
  RC.pickImage = function (onPicked) {
    var input = document.createElement("input");
    input.type = "file";
    input.accept = "image/*";
    input.style.display = "none";
    document.body.appendChild(input);
    input.addEventListener("change", function () {
      if (input.files && input.files[0]) onPicked(input.files[0]);
      input.remove();
    });
    input.click();
  };

  window.RC = RC;

  document.addEventListener("DOMContentLoaded", function () {
    RC.applyDarkMode();
    RC.syncNotifDot();
  });
})();
