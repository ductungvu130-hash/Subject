using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

public class Pet
{
    public int Id { get; set; }

    [Required, MaxLength(100)]
    public string Name { get; set; }   // VD: Name

    [Required, MaxLength(100)]
    public string Breed { get; set; }

    [Range(1, int.MaxValue, ErrorMessage = "Age must be a positive value.")]
    public int? Age { get; set; }


    [Required]
    [Column(TypeName = "decimal(10, 2)")]
    [Range(0.01, double.MaxValue, ErrorMessage = "Price need to be greater than 0")]
    public decimal Price { get; set; }

    [Required]
    public int CategoryId { get; set; } 
    [ForeignKey("CategoryId")]
    public PetCategory? PetCategory{ get; set; }

    public int Quantity { get; set; } = 0;

    public DateTime CreatedAt { get; set; } = DateTime.Now;
}
