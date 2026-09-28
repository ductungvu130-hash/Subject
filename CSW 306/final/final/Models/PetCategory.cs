
using System.ComponentModel.DataAnnotations;

public class PetCategory
{
    public int Id { get; set; }

    [Required, MaxLength(50)]
    public string Name { get; set; }

    [MaxLength(255)]
    public string? Description { get; set; }


    public DateTime CreatedAt { get; set; } = DateTime.Now;

    public ICollection<Pet> Pets { get; set; } = new List<Pet>();
}
