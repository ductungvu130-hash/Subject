using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;

[ApiController]
[Route("api/[controller]")]
public class PurchaseOrdersController : ControllerBase
{
    private readonly AppDbContext _context;
    public PurchaseOrdersController(AppDbContext context) => _context = context;

    [HttpGet]
    [Authorize(Roles = "___VaiTroAdmin___")]
    public async Task<IActionResult> GetAllPurchaseOrders()
    {
        var PurchaseOrders = await _context.PurchaseOrders.Include(o => o.PurchaseItems).ToListAsync();
        return Ok(PurchaseOrders);
    }

    [HttpPost]
    [Authorize]
    public async Task<IActionResult> CreatePurchaseOrder([FromBody] CreatePurchaseOrderDto dto)
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (userIdClaim == null) return Unauthorized();
        int userId = int.Parse(userIdClaim);

        var PurchaseOrder = new PurchaseOrder { UserId = userId, OrderDate = DateTime.Now, Status = "Pending" };

        decimal total = 0;
        foreach (var i in dto.Items)
        {
            var entity = await _context.Pets.FindAsync(i.PetId);
            if (entity == null)
                return BadRequest(new { message = $"Pet {i.PetId} khong ton tai" });
            if (i.Quantity <= 0)
                return BadRequest(new { message = "Quantity phai > 0" });
            if (entity.Quantity < i.Quantity)
                return BadRequest(new { message = $"Khong du hang cho {entity.Name}" });

            var PurchaseOrderItem = new PurchaseItem
            {
                PetId = entity.Id,
                Quantity = i.Quantity,
                UnitPrice = entity.Price   // gia HIEN TAI, khong phai gia da luu san
            };
            total += PurchaseOrderItem.Quantity * PurchaseOrderItem.UnitPrice;
            PurchaseOrder.PurchaseItems.Add(PurchaseOrderItem);
            entity.Quantity -= i.Quantity;
        }
        PurchaseOrder.TotalAmount = total;

        _context.PurchaseOrders.Add(PurchaseOrder);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetPurchaseOrderById), new { id = PurchaseOrder.Id }, PurchaseOrder);
    }

    [HttpGet("{id}")]
    [Authorize]
    public async Task<IActionResult> GetPurchaseOrderById(int id)
    {
        var PurchaseOrder = await _context.PurchaseOrders.Include(o => o.PurchaseItems).FirstOrDefaultAsync(o => o.Id == id);
        if (PurchaseOrder == null) return NotFound();
        return Ok(PurchaseOrder);
    }

    [HttpGet("user/{userId}")]
    [Authorize]
    public async Task<IActionResult> GetByUser(int userId)
    {
        var tokenUserId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (tokenUserId != userId.ToString()) return Forbid();
        // ___NEU_DE_CHO_PHEP_ADMIN_XEM_HO___: them dieu kien Role=="___VaiTroAdmin___" o day (xem Phan B)

        var PurchaseOrders = await _context.PurchaseOrders.Include(o => o.PurchaseItems)
            .Where(o => o.UserId == userId).ToListAsync();
        return Ok(PurchaseOrders);
    }
}

public class CreatePurchaseOrderDto { public List<PurchaseOrderItemDto> Items { get; set; } }
public class PurchaseOrderItemDto { public int PetId { get; set; } public int Quantity { get; set; } }
