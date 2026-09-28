let strings = ["1234", "1234abc", "0.15", "3.14ivan", "Infinity", "99999999999999999999"];
let tbody = document.querySelector("tbody");
for (let each of strings) {
    let tr = document.createElement("tr");
    let parsedInt = parseInt(each);
    let parsedFloat = parseFloat(each);
    let number = Number(each);
    let plusStr = +each;
    let orStr = each | 0;
    tr.innerHTML = `
        <td>${each}</td>
        <td>${parsedInt}</td>
        <td>${parsedFloat}</td>
        <td>${number}</td>
        <td>${plusStr}</td>
        <td>${orStr}</td>
    `;
    tbody.appendChild(tr);
}
let allTr = document.querySelectorAll("tr");
for (let each of allTr) {
    each.children[0].style.textAlign = "left";
        }