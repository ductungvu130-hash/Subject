let newHref = "https://www.youtube.com/";
let allLinks = document.querySelectorAll("a");
for (let each of allLinks) {
    each.href = newHref;
}