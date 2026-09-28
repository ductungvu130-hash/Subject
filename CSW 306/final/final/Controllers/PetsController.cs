using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[ApiController]
[Route("api/[controller]")]
public class PetsController : ControllerBase
{
    private readonly IPetRepository _repo;   
    private readonly AppDbContext _context;
    public PetsController(IPetRepository repo, AppDbContext context)
    {
        _repo = repo; _context = context;
    }

    [HttpGet]
    [AllowAnonymous]
    public async Task<IActionResult> GetAll()
    {
        var list = await _repo.GetAll();
        var result = list.Select(x => new {
            x.Id,
            x.Name,
            x.Breed,
            x.Price,
            CategoryId = x.CategoryId,
            CategoryName = x.PetCategory?.Name
        });
        return Ok(result);
    }

    [HttpGet("{id}")]
    [AllowAnonymous]
    public async Task<IActionResult> GetById(int id)
    {
        var entity = await _repo.GetById(id);
        if (entity == null) return NotFound(new { message = $"Pet {id} not found" });
        return Ok(entity);
    }

    [HttpPost]
    [Authorize(Roles = "Admin")] 
    public async Task<IActionResult> Create([FromBody] Pet entity)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);
        if (!await _context.PetCategories.AnyAsync(c => c.Id == entity.CategoryId))
            return BadRequest(new { message = "CategoryId khong ton tai" });

        await _repo.Add(entity);
        return CreatedAtAction(nameof(GetById), new { id = entity.Id }, entity);
    }

    [HttpPut("{id}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Update(int id, [FromBody] Pet entity)
    {
        if (id != entity.Id) return BadRequest(new { message = "Id khong khop" });
        if (!ModelState.IsValid) return BadRequest(ModelState);

        var existing = await _repo.GetById(id);
        if (existing == null) return NotFound();

        _context.Entry(existing).State = EntityState.Detached;

        if (existing.PetCategory != null)
        {
            _context.Entry(existing.PetCategory).State = EntityState.Detached;
        }

        entity.PetCategory = null;

        await _repo.Update(entity);
        return NoContent();
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Delete(int id)
    {
        var existing = await _repo.GetById(id);
        if (existing == null) return NotFound();

        await _repo.Delete(id);
        return NoContent();
    }
}
