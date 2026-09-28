using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

public class PurchaseItem
{
    public int Id { get; set; }

    [Required]
    public int OrderId { get; set; }
    [ForeignKey("OrderId")]
    public PurchaseOrder PurchaseOrder { get; set; }

    [Required]
    public int PetId { get; set; }   
    [ForeignKey("PetId")]
    public Pet Pet { get; set; }

    [Range(1, int.MaxValue)]
    public int Quantity { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    [Range(0.01, double.MaxValue)]
    public decimal UnitPrice { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.Now;
}
