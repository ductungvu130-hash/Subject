let names = [
    "Khai trương new hồng phát",
    "Khai trương new hồng phát",
    "Khai trương new hồng phát",
    "Khai trương new hồng phát",
    "Khai trương new hồng phát",
    "Khai trương new hồng phát",
    "Khai trương new hồng phát",
    "Khai trương new hồng phát",
];

let images = "Images/product.png";

let prices = ["100,000 đ", "200,000 đ", "300,000 đ", "400,000 đ", "500,000 đ", "600,000 đ", "700,000 đ", "800,000 đ"];

let productRow = document.getElementById("change-spuc");

// for (let i = 0; i < 8; i++) {
//     let productHTML = `
//         <div class="col-md-3 col-6">
//             <div class="card">
//                 <img src="${images}" class="card-img-top" alt="" />
//                 <span class="giam-gia">10%</span>
//                 <div class="card-body">
//                     <p class="card-text">${names[i]}</p>
//                     <h6 class="card-title">VS03${i}</h6>
//                     <p class="old-price">890,000 đ</p>
//                     <h5 class="card-title">${prices[i]}</h5>
//                 </div>
//             </div>
//         </div>
//     `;
//     productRow.innerHTML += productHTML;
// }

for (let i = 0; i < 8; i++) {
    let firstDiv = document.createElement("div");
    firstDiv.className = "col-md-3 col-6";

    let secondDiv = document.createElement("div");
    secondDiv.className = "card";

    let img = document.createElement("img");
    img.src = images;
    img.className = "card-img-top";

    let span = document.createElement("span");
    span.className = "giam-gia";
    span.textContent = "10%";

    let thirdDiv = document.createElement("div");
    thirdDiv.className = "card-body";

    let firstP = document.createElement("p");
    firstP.className = "card-text";
    firstP.textContent = names[i];

    let h6 = document.createElement("h6");
    h6.className = "card-title";
    h6.textContent = "VS03" + i;

    let secondP = document.createElement("p");
    secondP.className = "old-price";
    secondP.textContent = "890,000 đ";

    let h5 = document.createElement("h5");
    h5.className = "card-title";
    h5.textContent = prices[i];

    thirdDiv.appendChild(firstP);
    thirdDiv.appendChild(h6);
    thirdDiv.appendChild(secondP);
    thirdDiv.appendChild(h5);

    secondDiv.appendChild(img);
    secondDiv.appendChild(span);
    secondDiv.appendChild(thirdDiv);

    firstDiv.appendChild(secondDiv);

    productRow.appendChild(firstDiv);
}
