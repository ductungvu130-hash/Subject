using System.ComponentModel.DataAnnotations;

public class User
{
    public int Id { get; set; }

    [Required, MaxLength(200)]
    public string FullName { get; set; }

    [Required, EmailAddress, MaxLength(255)]
    public string Email { get; set; }

    [Required]
    public string Password { get; set; }

    [Required]
    public string Role { get; set; }   // "Admin"/"User" hoac "Admin"/"Customer" - xem Phan B

    public DateTime CreatedAt { get; set; } = DateTime.Now;
}

