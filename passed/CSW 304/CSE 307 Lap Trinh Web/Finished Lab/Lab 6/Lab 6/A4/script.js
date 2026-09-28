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

for (let i = 0; i < 8; i++) {
    let productHTML = `
        <div class="col-md-3 col-6">
            <div class="card">
                <img src="${images}" class="card-img-top" alt="" />
                <span class="giam-gia">10%</span>
                <div class="card-body">
                    <p class="card-text">${names[i]}</p>
                    <h6 class="card-title">VS03${i}</h6>
                    <p class="old-price">890,000 đ</p>
                    <h5 class="card-title">${prices[i]}</h5>
                </div>
            </div>
        </div>
    `;
    productRow.innerHTML += productHTML;
}
