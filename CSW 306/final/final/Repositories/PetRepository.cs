using Microsoft.EntityFrameworkCore;

public class PetRepository : IPetRepository
{
    private readonly AppDbContext _context;
    public PetRepository(AppDbContext context) => _context = context;

    public async Task<List<Pet>> GetAll() =>
        await _context.Pets.Include(x => x.PetCategory).ToListAsync();

    public async Task<Pet?> GetById(int id) =>
        await _context.Pets.Include(x => x.PetCategory)
            .FirstOrDefaultAsync(x => x.Id == id);

    public async Task Add(Pet entity)
    {
        _context.Pets.Add(entity);
        await _context.SaveChangesAsync();
    }

    public async Task Update(Pet entity)
    {
        _context.Pets.Update(entity);
        await _context.SaveChangesAsync();
    }

    public async Task Delete(int id)
    {
        var entity = await _context.Pets.FindAsync(id);
        if (entity != null)
        {
            _context.Pets.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }

    public async Task<List<Pet>> GetByCategoryId(int categoryId) =>
        await _context.Pets.Where(x => x.CategoryId == categoryId).ToListAsync();
}
