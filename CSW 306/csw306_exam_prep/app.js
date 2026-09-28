// app.js - Enhanced Application Logic, Quiz Engine, Mock Generator, and Deep-Dive Knowledge Database (Aligned with Labs 1-8)

// 1. Exam Solutions Database (Fruits, Pets, HR)
const examSolutions = {
    fruits: {
        title: "Fruits Store Management Software",
        quarter: "Quarter 1 - Academic Year: 2025 - 2026",
        courseCode: "CSW 306",
        duration: "120'",
        examCode: "01",
        questions: {
            q1: {
                title: "Question 1: Database, Model and DbContext Design (30 marks)",
                desc: "Thiết kế lớp Category, Fruit, User, Order, OrderItem và AppDbContext đúng chuẩn Code-First với Data Annotations.",
                code: `// Models/Category.cs
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace FruitsStore.Models
{
    [Table("Categories")]
    public class Category
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Tên danh mục là bắt buộc.")]
        [StringLength(50, ErrorMessage = "Tên danh mục không được vượt quá 50 ký tự.")]
        public string Name { get; set; }

        [StringLength(255)]
        public string Description { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        [JsonIgnore] // Tránh lỗi vòng lặp Cyclic Reference khi serialize JSON
        public ICollection<Fruit> Fruits { get; set; } = new List<Fruit>();
    }
}

// Models/Fruit.cs
namespace FruitsStore.Models
{
    [Table("Fruits")]
    public class Fruit
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Tên trái cây là bắt buộc.")]
        [StringLength(100, ErrorMessage = "Tên trái cây không quá 100 ký tự.")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Giá bán là bắt buộc.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "Giá bán phải lớn hơn 0.")]
        [Column(TypeName = "decimal(10,2)")]
        public decimal Price { get; set; }

        public float StockQuantity { get; set; } = 0f;

        [Required]
        public int CategoryId { get; set; }

        [ForeignKey("CategoryId")]
        public Category Category { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}

// Data/AppDbContext.cs
using Microsoft.EntityFrameworkCore;

namespace FruitsStore.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Fruit> Fruits { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            // Cấu hình Default value cho các trường ngày tạo
            modelBuilder.Entity<User>().Property(u => u.CreatedAt).HasDefaultValueSql("GETDATE()");
            modelBuilder.Entity<Category>().Property(c => c.CreatedAt).HasDefaultValueSql("GETDATE()");
            modelBuilder.Entity<Fruit>().Property(f => f.CreatedAt).HasDefaultValueSql("GETDATE()");
            modelBuilder.Entity<Order>().Property(o => o.CreatedAt).HasDefaultValueSql("GETDATE()");
            modelBuilder.Entity<OrderItem>().Property(oi => oi.CreatedAt).HasDefaultValueSql("GETDATE()");
        }
    }
}`
            },
            q2: {
                title: "Question 2: Repository Layer (Generic Pattern - Lab 8) (30 marks)",
                desc: "Triển khai mẫu Generic Repository (Lab 8) áp dụng cụ thể cho Fruit và User để tối ưu tái sử dụng code.",
                code: `// Repositories/IRepository.cs (Khuôn mẫu Generic Interface chuẩn từ Lab 8)
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FruitsStore.Repositories
{
    public interface IRepository<T> where T : class
    {
        Task<IEnumerable<T>> GetAllAsync();
        Task<T?> GetByIdAsync(int id);
        Task<T> AddAsync(T entity);
        Task<T?> UpdateAsync(int id, T entity);
        Task<bool> DeleteAsync(int id);
    }
}

// Repositories/FruitRepository.cs (Triển khai IRepository<Fruit>)
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using FruitsStore.Data;
using FruitsStore.Models;

namespace FruitsStore.Repositories
{
    public class FruitRepository : IRepository<Fruit>
    {
        private readonly AppDbContext _context;

        public FruitRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Fruit>> GetAllAsync()
        {
            return await _context.Fruits.Include(f => f.Category).ToListAsync();
        }

        public async Task<Fruit?> GetByIdAsync(int id)
        {
            return await _context.Fruits.Include(f => f.Category)
                                         .FirstOrDefaultAsync(f => f.Id == id);
        }

        public async Task<Fruit> AddAsync(Fruit entity)
        {
            await _context.Fruits.AddAsync(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Fruit?> UpdateAsync(int id, Fruit entity)
        {
            var existing = await _context.Fruits.FindAsync(id);
            if (existing == null) return null;

            existing.Name = entity.Name;
            existing.Price = entity.Price;
            existing.StockQuantity = entity.StockQuantity;
            existing.CategoryId = entity.CategoryId;

            _context.Entry(existing).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var fruit = await _context.Fruits.FindAsync(id);
            if (fruit == null) return false;

            _context.Fruits.Remove(fruit);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}`
            },
            q3: {
                title: "Question 3: API Controller & JWT Business Logic (30 marks)",
                desc: "Xây dựng REST Controller quản lý đơn hàng OrdersController và xử lý JWT AuthController.",
                code: `// Controllers/FruitsController.cs
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using FruitsStore.Models;
using FruitsStore.Repositories;

namespace FruitsStore.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class FruitsController : ControllerBase
    {
        private readonly IRepository<Fruit> _fruitRepo;

        public FruitsController(IRepository<Fruit> fruitRepo)
        {
            _fruitRepo = fruitRepo;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetBookById(int id) // Đặt tên giống Lab 8
        {
            var fruit = await _fruitRepo.GetByIdAsync(id);
            if (fruit == null) return NotFound(new { message = "Không tìm thấy sản phẩm." });
            return Ok(fruit);
        }

        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> CreateFruit([FromBody] Fruit fruit)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            var created = await _fruitRepo.AddAsync(fruit);
            return CreatedAtAction(nameof(GetBookById), new { id = created.Id }, created);
        }
    }
}`
            },
            q4: {
                title: "Question 4: xUnit Testing & Integration Testing (Lab 7) (10 marks)",
                desc: "Viết Unit Test với Moq và Integration Test sử dụng WebApplicationFactory theo chuẩn Lab 7.",
                code: `// 1. Tests/Controllers/FruitsControllerTests.cs (Unit Test)
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;
using FruitsStore.Controllers;
using FruitsStore.Models;
using FruitsStore.Repositories;

namespace FruitsStore.Tests
{
    public class FruitsControllerTests
    {
        private readonly Mock<IRepository<Fruit>> _mockRepo;
        private readonly FruitsController _controller;

        public FruitsControllerTests()
        {
            _mockRepo = new Mock<IRepository<Fruit>>();
            _controller = new FruitsController(_mockRepo.Object);
        }

        [Fact]
        public async Task GetById_ReturnsNotFound_WhenFruitDoesNotExist()
        {
            // Arrange
            _mockRepo.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Fruit)null);

            // Act
            var result = await _controller.GetBookById(99);

            // Assert
            var notFoundResult = Assert.IsType<NotFoundObjectResult>(result);
        }

        [Fact]
        public async Task GetById_ReturnsFruit_WhenFruitExists()
        {
            // Arrange
            var sample = new Fruit { Id = 1, Name = "Apple", Price = 2.5m };
            _mockRepo.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(sample);

            // Act
            var result = await _controller.GetBookById(1);

            // Assert
            var okResult = Assert.IsType<OkObjectResult>(result);
            var returned = Assert.IsType<Fruit>(okResult.Value);
            Assert.Equal("Apple", returned.Name);
        }
    }
}

// 2. Tests/Integration/FruitsApiIntegrationTests.cs (Integration Test)
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace FruitsStore.Tests.Integration
{
    public class FruitsApiIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly HttpClient _client;

        public FruitsApiIntegrationTests(WebApplicationFactory<Program> factory)
        {
            _client = factory.CreateClient();
        }

        [Fact]
        public async Task GetFruits_ReturnsSuccessAndJSON()
        {
            // Act
            var response = await _client.GetAsync("/api/fruits");

            // Assert
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);
            Assert.Equal("application/json; charset=utf-8", response.Content.Headers.ContentType.ToString());
        }
    }
}`
            }
        }
    },
    pets: {
        title: "Pet Store Management Software",
        quarter: "Quarter 3 - Academic year: 2025 - 2026",
        courseCode: "CSW 306",
        duration: "120'",
        examCode: "01",
        questions: {
            q1: {
                title: "Question 1: Database, Model and DbContext Design (30 marks)",
                desc: "Thiết kế các thực thể (Models) cho cửa hàng thú cưng, các ràng buộc dữ liệu và DbContext.",
                code: `// Models/PetCategory.cs
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace PetStore.Models
{
    [Table("PetCategories")]
    public class PetCategory
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Name is required.")]
        [StringLength(50)]
        public string Name { get; set; }

        [StringLength(255)]
        public string Description { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        [JsonIgnore]
        public ICollection<Pet> Pets { get; set; } = new List<Pet>();
    }
}

// Models/Pet.cs
namespace PetStore.Models
{
    [Table("Pets")]
    public class Pet
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Name is required.")]
        [StringLength(100)]
        public string Name { get; set; }

        [Required(ErrorMessage = "Breed is required.")]
        [StringLength(100)]
        public string Breed { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Age must be a positive value.")]
        public int Age { get; set; }

        [Required]
        [Range(0.01, double.MaxValue, ErrorMessage = "Price must be positive.")]
        [Column(TypeName = "decimal(10,2)")]
        public decimal Price { get; set; }

        [Required]
        public int CategoryId { get; set; }

        [ForeignKey("CategoryId")]
        public PetCategory Category { get; set; }

        public int Quantity { get; set; } = 0;

        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}`
            },
            q2: {
                title: "Question 2: Repository Layer (Generic Pattern - Lab 8) (30 marks)",
                desc: "Thiết kế IRepository và triển khai PetRepository kết nối cơ sở dữ liệu bằng AppDbContext bất đồng bộ.",
                code: `// Repositories/IRepository.cs (Generic Pattern chuẩn)
using System.Collections.Generic;
using System.Threading.Tasks;

namespace PetStore.Repositories
{
    public interface IRepository<T> where T : class
    {
        Task<IEnumerable<T>> GetAllAsync();
        Task<T?> GetByIdAsync(int id);
        Task<T> AddAsync(T entity);
        Task<T?> UpdateAsync(int id, T entity);
        Task<bool> DeleteAsync(int id);
    }
}

// Repositories/PetRepository.cs
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PetStore.Data;
using PetStore.Models;

namespace PetStore.Repositories
{
    public class PetRepository : IRepository<Pet>
    {
        private readonly AppDbContext _context;

        public PetRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Pet>> GetAllAsync()
        {
            return await _context.Pets.Include(p => p.Category).ToListAsync();
        }

        public async Task<Pet?> GetByIdAsync(int id)
        {
            return await _context.Pets.Include(p => p.Category)
                                       .FirstOrDefaultAsync(p => p.Id == id);
        }

        public async Task<Pet> AddAsync(Pet entity)
        {
            await _context.Pets.AddAsync(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Pet?> UpdateAsync(int id, Pet entity)
        {
            var existing = await _context.Pets.FindAsync(id);
            if (existing == null) return null;

            existing.Name = entity.Name;
            existing.Breed = entity.Breed;
            existing.Age = entity.Age;
            existing.Price = entity.Price;
            existing.Quantity = entity.Quantity;
            existing.CategoryId = entity.CategoryId;

            _context.Entry(existing).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var pet = await _context.Pets.FindAsync(id);
            if (pet == null) return false;

            _context.Pets.Remove(pet);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}`
            },
            q3: {
                title: "Question 3: API Controller (30 marks)",
                desc: "Xây dựng các REST APIs quản lý Pets, tạo đơn đặt hàng PurchaseOrders và xử lý kho.",
                code: `// Controllers/PetsController.cs
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using PetStore.Models;
using PetStore.Repositories;

namespace PetStore.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PetsController : ControllerBase
    {
        private readonly IRepository<Pet> _petRepo;

        public PetsController(IRepository<Pet> petRepo)
        {
            _petRepo = petRepo;
        }

        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> GetAll()
        {
            var pets = await _petRepo.GetAllAsync();
            var result = pets.Select(p => new {
                id = p.Id,
                name = p.Name,
                breed = p.Breed,
                age = p.Age,
                price = p.Price,
                quantity = p.Quantity,
                categoryId = p.CategoryId,
                categoryName = p.Category?.Name
            });
            return Ok(result);
        }

        [HttpGet("{id}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetBookById(int id)
        {
            var p = await _petRepo.GetByIdAsync(id);
            if (p == null) return NotFound(new { message = "Không tìm thấy." });
            return Ok(new {
                id = p.Id,
                name = p.Name,
                breed = p.Breed,
                price = p.Price,
                categoryName = p.Category?.Name
            });
        }
    }
}`
            },
            q4: {
                title: "Question 4: xUnit Testing & Integration Testing (Lab 7) (10 marks)",
                desc: "Xây dựng các test case kiểm tra Controller (Unit Test) và API (Integration Test) bám sát yêu cầu Lab 7.",
                code: `// Tests/Controllers/PetsControllerTests.cs (Unit Test)
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;
using PetStore.Controllers;
using PetStore.Models;
using PetStore.Repositories;

namespace PetStore.Tests
{
    public class PetsControllerTests
    {
        private readonly Mock<IRepository<Pet>> _mockRepo;
        private readonly PetsController _controller;

        public PetsControllerTests()
        {
            _mockRepo = new Mock<IRepository<Pet>>();
            _controller = new PetsController(_mockRepo.Object);
        }

        [Fact]
        public async Task GetById_ReturnsNotFound_WhenPetDoesNotExist()
        {
            _mockRepo.Setup(repo => repo.GetByIdAsync(99)).ReturnsAsync((Pet)null);

            var result = await _controller.GetBookById(99);

            Assert.IsType<NotFoundObjectResult>(result);
        }

        [Fact]
        public async Task GetById_ReturnsPet_WhenPetExists()
        {
            var sample = new Pet { Id = 1, Name = "Buddy", Breed = "Husky", Price = 600m };
            _mockRepo.Setup(repo => repo.GetByIdAsync(1)).ReturnsAsync(sample);

            var result = await _controller.GetBookById(1);

            var okResult = Assert.IsType<OkObjectResult>(result);
        }
    }
}`
            }
        }
    },
    hr: {
        title: "Human Resource Management System",
        quarter: "Quarter 4 - Academic year: 2024 - 2025",
        courseCode: "CSW 306",
        duration: "120'",
        examCode: "01",
        questions: {
            q1: {
                title: "Question 1: Database, Model and DbContext Design (20 marks)",
                desc: "Thiết kế lớp Employee và Department có quan hệ một-nhiều (One Department has many Employees).",
                code: `// Models/Employee.cs
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HRSystem.Models
{
    [Table("Employees")]
    public class Employee
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Fullname is required.")]
        [StringLength(200, ErrorMessage = "Fullname cannot exceed 200 characters.")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Invalid email format.")]
        public string Email { get; set; }

        [Required(ErrorMessage = "StartDate is required.")]
        public DateTime StartDate { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        [ForeignKey("DepartmentId")]
        public Department Department { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}`
            },
            q2: {
                title: "Question 2: Repository and Service Layer (Generic Pattern - Lab 8) (25 marks)",
                desc: "Triển khai lớp Repository và Service để quản lý nhân viên (Employee) bám sát cấu trúc Lab 8.",
                code: `// Repositories/IRepository.cs (Generic Interface)
using System.Collections.Generic;
using System.Threading.Tasks;

namespace HRSystem.Repositories
{
    public interface IRepository<T> where T : class
    {
        Task<IEnumerable<T>> GetAllAsync();
        Task<T?> GetByIdAsync(int id);
        Task<T> AddAsync(T entity);
        Task<T?> UpdateAsync(int id, T entity);
        Task<bool> DeleteAsync(int id);
    }
}

// Repositories/EmployeeRepository.cs
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using HRSystem.Data;
using HRSystem.Models;

namespace HRSystem.Repositories
{
    public class EmployeeRepository : IRepository<Employee>
    {
        private readonly AppDbContext _context;
        public EmployeeRepository(AppDbContext context) => _context = context;

        public async Task<IEnumerable<Employee>> GetAllAsync()
        {
            return await _context.Employees.Include(e => e.Department).ToListAsync();
        }

        public async Task<Employee?> GetByIdAsync(int id)
        {
            return await _context.Employees.Include(e => e.Department)
                                           .FirstOrDefaultAsync(e => e.Id == id);
        }

        public async Task<Employee> AddAsync(Employee entity)
        {
            await _context.Employees.AddAsync(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<Employee?> UpdateAsync(int id, Employee entity)
        {
            var existing = await _context.Employees.FindAsync(id);
            if (existing == null) return null;

            existing.FullName = entity.FullName;
            existing.Email = entity.Email;
            existing.StartDate = entity.StartDate;
            existing.DepartmentId = entity.DepartmentId;

            _context.Entry(existing).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return existing;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var emp = await _context.Employees.FindAsync(id);
            if (emp == null) return false;
            _context.Employees.Remove(emp);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}`
            },
            q3: {
                title: "Question 3: API Controller & Nested JSON (40 marks)",
                desc: "Thiết kế EmployeesController và giải quyết yêu cầu lồng ghép dữ liệu (Nested JSON Input/Output) cho Department.",
                code: `// Controllers/EmployeesController.cs
using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using HRSystem.Models;
using HRSystem.Repositories;
using HRSystem.Data;
using Microsoft.EntityFrameworkCore;

namespace HRSystem.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeesController : ControllerBase
    {
        private readonly IRepository<Employee> _empRepo;
        private readonly AppDbContext _context;

        public EmployeesController(IRepository<Employee> empRepo, AppDbContext context)
        {
            _empRepo = empRepo;
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> CreateEmployee([FromBody] EmployeeCreateRequest request)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            if (request.StartDate > DateTime.Now) return BadRequest("StartDate không được trong tương lai.");

            if (request.Department == null || string.IsNullOrEmpty(request.Department.Name))
                return BadRequest("Thông tin phòng ban bắt buộc.");

            var deptName = request.Department.Name.Trim();
            var department = await _context.Departments
                .FirstOrDefaultAsync(d => d.Name.ToLower() == deptName.ToLower());

            if (department == null)
            {
                department = new Department { Name = deptName };
                _context.Departments.Add(department);
                await _context.SaveChangesAsync();
            }

            var employee = new Employee
            {
                FullName = request.FullName,
                Email = request.Email,
                StartDate = request.StartDate,
                DepartmentId = department.Id
            };

            await _empRepo.AddAsync(employee);

            return CreatedAtAction("GetBookById", new { id = employee.Id }, new {
                id = employee.Id,
                fullName = employee.FullName,
                email = employee.Email,
                startDate = employee.StartDate,
                department = new {
                    id = department.Id,
                    name = department.Name
                }
            });
        }
    }
}`
            },
            q4: {
                title: "Question 4: xUnit Testing & Integration Testing (Lab 7) (15 marks)",
                desc: "Xây dựng các unit test kiểm thử Controller và integration test chạy pipeline giả lập bám sát Lab 7.",
                code: `// Tests/Controllers/EmployeesControllerTests.cs
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;
using HRSystem.Controllers;
using HRSystem.Models;
using HRSystem.Repositories;
using HRSystem.Data;

namespace HRSystem.Tests
{
    public class EmployeesControllerTests
    {
        private readonly Mock<IRepository<Employee>> _mockRepo;
        private readonly Mock<AppDbContext> _mockContext;
        private readonly EmployeesController _controller;

        public EmployeesControllerTests()
        {
            _mockRepo = new Mock<IRepository<Employee>>();
            _mockContext = new Mock<AppDbContext>();
            _controller = new EmployeesController(_mockRepo.Object, _mockContext.Object);
        }
        
        // Cấu trúc kiểm thử xUnit tương ứng
    }
}`
            }
        }
    }
};

// 2. Deep-Dive Knowledge Review Database (Aligned 1-to-1 with Labs 1-8)
const knowledgeReview = [
    {
        id: "lab1_2",
        title: "1. C# & Object-Oriented Programming (Lab 1 & 2)",
        desc: "Khái quát toàn bộ cơ chế của C# cơ bản, lập trình hướng đối tượng (OOP), interface, abstract class, record, event và delegate.",
        theory: `<h3>Cơ chế C# & Lập trình hướng đối tượng chuyên sâu</h3>
<p>Lớp học CSW 306 đi sâu vào các đặc tính cốt lõi của OOP trên nền tảng .NET:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>Encapsulation (Đóng gói) & Property Validation</strong>: Sử dụng Custom Getters/Setters để bảo vệ dữ liệu, tránh gán giá trị không hợp lệ (ví dụ: cấm nhập số âm cho năm xuất bản sách hoặc số lượng bản sao có sẵn trong thư viện).</li>
    <li><strong>Interface (Giao diện)</strong>: Định nghĩa các hợp đồng hành vi không lưu trạng thái (ví dụ: <code>IPrintable</code>, <code>IMemberActions</code>). Giúp xây dựng liên kết lỏng (loose coupling) trong ứng dụng.</li>
    <li><strong>Inheritance (Kế thừa) & Polymorphism (Đa hình)</strong>: Lớp con kế thừa thuộc tính và ghi đè (override) phương thức ảo (virtual) hoặc trừu tượng (abstract) của lớp cha (ví dụ: <code>PremiumMember</code> ghi đè hành vi mượn sách của lớp cơ sở <code>Member</code>).</li>
    <li><strong>Abstract Class (Lớp trừu tượng)</strong>: Đóng vai trò là bản thiết kế chung, không thể khởi tạo trực tiếp và bắt buộc các lớp con phải triển khai (implement) các hàm trừu tượng của nó (ví dụ: lớp giao dịch <code>Transaction</code> chứa hàm abstract <code>Execute()</code>).</li>
</ul>
<h3 class="mt-4">Records vs Classes (Lab 2)</h3>
<p>Lab 2 giới thiệu <strong>Record</strong> - một tính năng mới trong C# dùng cho các đối tượng lưu trữ dữ liệu bất biến (immutable data):</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>Class</strong> sử dụng cơ chế so sánh bằng tham chiếu (Reference Equality - hai đối tượng bằng nhau khi và chỉ khi cùng trỏ tới một vùng nhớ RAM).</li>
    <li><strong>Record</strong> sử dụng cơ chế so sánh bằng giá trị (Value Equality - hai đối tượng record bằng nhau nếu toàn bộ thuộc tính của chúng có giá trị giống nhau). Hỗ trợ cú pháp đột biến không phá hủy thông qua toán tử <code>with</code> (ví dụ: <code>var record2 = record1 with { Author = "Jane" };</code>).</li>
</ul>
<h3 class="mt-4">Delegates & Events (Lab 2)</h3>
<p>Lab 2 yêu cầu triển khai cơ chế ủy quyền sự kiện để thông báo khi mượn sách:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>Delegate (Ủy quyền)</strong>: Con trỏ hàm an toàn (typesafe), đại diện cho một danh sách các phương thức có cùng chữ ký.</li>
    <li><strong>Event (Sự kiện)</strong>: Triển khai mô hình Publisher-Subscriber. Lớp <code>Library</code> định nghĩa sự kiện <code>public event Action&lt;Book, Member&gt; OnBookBorrowed;</code> và kích hoạt nó khi thực hiện mượn sách. Các lớp thông báo sẽ đăng ký lắng nghe thông qua toán tử <code>+=</code> để gửi email hoặc ghi log tự động.</li>
</ul>`,
        code: `// Minh họa Record và Event từ Lab 2
public record BookRecord(string ISBN, string Title, string Author);

public class Library
{
    public string LibraryName { get; set; }
    
    // Khai báo Delegate Event
    public event Action<BookRecord, string> OnBookBorrowed;

    public void ProcessBorrowing(BookRecord book, string memberName)
    {
        Console.WriteLine($"Mượn sách: {book.Title} bởi {memberName}");
        
        // Kích hoạt sự kiện (nếu có subscriber đăng ký)
        OnBookBorrowed?.Invoke(book, memberName);
    }
}

// Đăng ký sự kiện trong Program.cs:
// library.OnBookBorrowed += (book, member) => Console.WriteLine($"[Email] Gửi thư mượn sách {book.Title}...");`,
        pitfalls: `<h4>⚠️ Lỗi Thường Gặp & Lưu Ý Khi Đi Thi:</h4>
<ol class="list-decimal pl-5 space-y-2 mt-2">
    <li><strong>Không kiểm tra null trước khi gọi Invoke Event</strong>: Nếu gọi trực tiếp <code>OnBookBorrowed(book, member)</code> mà không có đối tượng nào đăng ký lắng nghe sự kiện, chương trình sẽ lập tức báo lỗi <code>NullReferenceException</code>. Luôn sử dụng toán tử <code>OnBookBorrowed?.Invoke(...)</code>.</li>
    <li><strong>Viết sai cú pháp so sánh Record và Class</strong>: Hiểu sai cơ chế so sánh tham chiếu của Class và so sánh giá trị của Record sẽ bị mất điểm trong các câu hỏi trắc nghiệm lý thuyết.</li>
</ol>`
    },
    {
        id: "lab3",
        title: "2. ASP.NET Core API Basics (Lab 3)",
        desc: "Thiết kế bộ điều khiển (Controllers), thiết lập định tuyến RESTful APIs cơ bản và trả về JSON thô không qua database.",
        theory: `<h3>Định tuyến & Thiết kế Controller hành vi RESTful</h3>
<p>Lab 3 là bước đầu tiên tiếp cận Web API, thực hiện thao tác dữ liệu tạm thời (InMemory list) để nắm vững các HTTP verbs:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>Routing</strong>: Khai báo router ở mức class thông qua <code>[Route("api/[controller]")]</code>.</li>
    <li><strong>HTTP Verbs</strong>:
        <ul class="list-none pl-4 space-y-0.5">
            <li>- <code>GET /api/books</code>: Trả về toàn bộ danh sách sách (HTTP 200 Ok).</li>
            <li>- <code>GET /api/books/{id}</code>: Tìm kiếm sách theo ID, trả về 404 NotFound nếu không tồn tại.</li>
            <li>- <code>POST /api/books</code>: Thêm sách mới, đọc JSON từ request body bằng <code>[FromBody]</code>.</li>
            <li>- <code>PUT /api/books/{id}</code>: Cập nhật thông tin sách theo ID.</li>
            <li>- <code>DELETE /api/books/{id}</code>: Xóa sách ra khỏi danh sách tạm thời.</li>
        </ul>
    </li>
</ul>`,
        code: `[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase
{
    // Danh sách tĩnh lưu trên RAM tạm thời phục vụ Lab 3
    private static readonly List<Book> _books = new List<Book>
    {
        new Book { Id = 1, Title = "Clean Code", Author = "Robert C. Martin", Year = 2008 }
    };

    [HttpGet("{id}")]
    public IActionResult GetBookById(int id)
    {
        var book = _books.FirstOrDefault(b => b.Id == id);
        if (book == null) return NotFound(); // Trả về 404
        return Ok(book); // Trả về 200
    }

    [HttpPost]
    public IActionResult AddBook([FromBody] Book newBook)
    {
        _books.Add(newBook);
        return CreatedAtAction(nameof(GetBookById), new { id = newBook.Id }, newBook); // Trả về 201
    }
}`,
        pitfalls: `<h4>⚠️ Lỗi Thường Gặp & Lưu Ý Khi Đi Thi:</h4>
<ol class="list-decimal pl-5 space-y-2 mt-2">
    <li><strong>Nhầm lẫn giữa các Http status code trả về</strong>: Khi POST thành công bắt buộc phải trả về 201 Created bằng hàm <code>CreatedAtAction()</code> thay vì 200 Ok. Khi PUT/DELETE thành công nên trả về 204 NoContent hoặc Ok kèm DTO.</li>
    <li><strong>Quên [FromBody]</strong>: Khiến ASP.NET Core không đọc được dữ liệu JSON từ body gửi lên, tham số model nhận vào trong Controller sẽ bị null.</li>
</ol>`
    },
    {
        id: "lab4",
        title: "3. EF Core Code-First Design (Lab 4)",
        desc: "Thiết lập cấu trúc CSDL bằng SQL Server, tạo Migrations và thiết lập ràng buộc dữ liệu quan hệ một-nhiều.",
        theory: `<h3>Kết nối Database & Code-First Migrations</h3>
<p>Lab 4 nâng cấp hệ thống từ InMemory sang kết nối trực tiếp với SQL Server:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>Đăng ký DbContext</strong>: Khai báo chuỗi kết nối trong <code>appsettings.json</code> và đăng ký dịch vụ SqlServer trong <code>Program.cs</code> thông qua <code>builder.Services.AddDbContext</code>.</li>
    <li><strong>Cơ cấu Migration</strong>: Sử dụng công cụ Entity Framework Core CLI để theo dõi sự thay đổi mô hình lớp C# và sinh ra các câu lệnh SQL Server tương ứng:
        <pre class="dracula-code p-2 rounded mt-1 font-mono text-[11px]">
dotnet ef migrations add InitialCreate
dotnet ef database update</pre>
    </li>
    <li><strong>Cấu hình Navigation Properties</strong>: Khai báo thuộc tính điều hướng một-nhiều (ví dụ: <code>Book</code> có khóa ngoại <code>CategoryId</code> trỏ tới thực thể <code>Category</code>).</li>
</ul>`,
        code: `// Cấu hình kết nối SQL Server chuẩn trong Program.cs của Lab 4
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DBConnection")));

// Cấu hình appsettings.json
{
  "ConnectionStrings": {
    "DBConnection": "Server=localhost;Database=LibraryDb;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}`,
        pitfalls: `<h4>⚠️ Lỗi Thường Gặp & Lưu Ý Khi Đi Thi:</h4>
<ol class="list-decimal pl-5 space-y-2 mt-2">
    <li><strong>Lỗi chưa chạy Migration đã chạy ứng dụng</strong>: Gây ra lỗi <em>"Cannot open database requested by the login..."</em> hoặc bảng dữ liệu không tồn tại. Luôn kiểm tra xem đã chạy lệnh <code>update-database</code> hay chưa.</li>
    <li><strong>Quên cấu hình TrustServerCertificate=True trong Connection String</strong>: Từ .NET 8, driver kết nối mặc định yêu cầu SSL mã hóa. Nếu SQL Server local không có chứng chỉ bảo mật, kết nối sẽ lập tức bị từ chối.</li>
</ol>`
    },
    {
        id: "lab5_auth",
        title: "4. JWT Authentication & Policy Authorization (Lab 5)",
        desc: "Xác thực danh tính người dùng bằng chuỗi Token Stateless, cấu hình phân quyền nâng cao dựa theo Claims và Custom Policy.",
        theory: `<h3>Triển khai JWT & Claims trong Lab 5</h3>
<p>Lab 5 chuyển đổi hệ thống API bảo mật tĩnh sang cơ chế phi trạng thái Stateless JWT:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>JWT Settings</strong>: Cấu hình SecretKey, Issuer, Audience, ExpiryMinutes trong file cấu hình.</li>
    <li><strong>Phân quyền dựa theo Policy (Chính sách)</strong>:
        <ul class="list-none pl-4 space-y-0.5">
            <li>- <em>ActiveUserOnly</em>: Yêu cầu claim <code>IsActive == True</code>.</li>
            <li>- <em>AdminOrLibrarian</em>: Yêu cầu Role là Admin hoặc Librarian.</li>
            <li>- <em>MinimumMembership</em>: Sử dụng Custom Handler tính khoảng cách số ngày đăng ký kể từ ngày tạo tài khoản.</li>
            <li>- <em>ManageActiveCategories</em>: Phối hợp nhiều điều kiện (Role Admin + Claim CanManageCategories).</li>
        </ul>
    </li>
</ul>`,
        code: `// Ví dụ đăng ký các Policies phức tạp của Lab 5 trong Program.cs
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("ActiveUserOnly", policy => policy.RequireClaim("IsActive", "True"));
    options.AddPolicy("AdminOrLibrarian", policy => policy.RequireRole("Admin", "Librarian"));
    options.AddPolicy("VerifiedEmailOnly", policy => policy.RequireClaim("EmailConfirmed", "True"));
});

// Sử dụng bảo mật Endpoint trong Controllers
[HttpGet("dashboard")]
[Authorize(Policy = "ActiveUserOnly")] // Áp dụng chính sách hoạt động
public IActionResult GetDashboard()
{
    return Ok("Chào mừng người dùng đang hoạt động!");
}`,
        pitfalls: `<h4>⚠️ Lỗi Thường Gặp & Lưu Ý Khi Đi Thi:</h4>
<ol class="list-decimal pl-5 space-y-2 mt-2">
    <li><strong>Lỗi 401 Unauthorized khi gửi thiếu từ khóa Bearer</strong>: Client khi gửi token trong Authorization Header bắt buộc phải có tiền tố <code>Bearer [token]</code>. Nếu viết thiếu từ khóa hoặc thiếu dấu cách, server sẽ không giải mã được.</li>
    <li><strong>Không tiêm Custom AuthorizationHandler dưới dạng Singleton/Transient</strong>: Nếu viết Custom Policy Handler mà quên đăng ký <code>builder.Services.AddSingleton&lt;IAuthorizationHandler, MyHandler&gt;()</code>, chính sách đó sẽ luôn báo lỗi 500 hoặc 403.</li>
</ol>`
    },
    {
        id: "lab5_6_signalr",
        title: "5. Real-Time Hub with SignalR (Lab 5 & 6)",
        desc: "Thiết lập hệ thống chat thời gian thực và quản lý danh sách kết nối đa luồng an toàn bằng ConcurrentDictionary.",
        theory: `<h3>SignalR Chat & Quản lý kết nối</h3>
<p>Lab 5 & 6 hướng dẫn xây dựng Hub chat thời gian thực yêu cầu đăng nhập:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>Hub Authentication</strong>: Cấu hình sự kiện <code>OnMessageReceived</code> của JWT Bearer trong Program.cs để bóc tách mã truy cập (access_token) truyền qua URL Query String khi bắt đầu bắt tay kết nối WebSockets.</li>
    <li><strong>Thread-Safe Connection Tracking</strong>: Dùng lớp <code>ConcurrentDictionary</code> để lưu trữ thông tin kết nối an toàn tránh hiện tượng tranh chấp luồng dữ liệu (Race Condition).</li>
</ul>`,
        code: `// Đăng ký SignalR lấy Token từ Query string
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options => {
        options.TokenValidationParameters = new TokenValidationParameters { /* Cấu hình khóa */ };
        options.Events = new JwtBearerEvents {
            OnMessageReceived = context => {
                var accessToken = context.Request.Query["access_token"];
                var path = context.HttpContext.Request.Path;
                if (!string.IsNullOrEmpty(accessToken) && path.StartsWithSegments("/chathub")) {
                    context.Token = accessToken; // Gán token cho hệ thống xác thực
                }
                return Task.CompletedTask;
            }
        };
    });`,
        pitfalls: `<h4>⚠️ Lỗi Thường Gặp & Lưu Ý Khi Đi Thi:</h4>
<ol class="list-decimal pl-5 space-y-2 mt-2">
    <li><strong>Lỗi gọi HttpContext.User bên ngoài luồng kết nối</strong>: Trong SignalR Hub, để lấy thông tin người dùng hiện tại, phải sử dụng thuộc tính <code>Context.User</code> có sẵn của Hub thay vì dùng <code>User</code> của Controller.</li>
</ol>`
    },
    {
        id: "lab4_5_files",
        title: "6. Safe File Uploads & OS I/O (Lab 4 & 5)",
        desc: "Tiếp nhận tệp bằng IFormFile, lưu trữ vật lý trên server và xử lý dọn dẹp file rác khi thực hiện lệnh xóa cứng.",
        theory: `<h3>Quản lý file vật lý & Xóa cứng</h3>
<p>Các bài Lab yêu cầu lưu trữ ảnh bìa sách hoặc tệp PDF tài liệu lên server máy chủ:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>wwwroot</strong>: Thư mục chứa các tệp tĩnh được cấu hình qua middleware <code>app.UseStaticFiles()</code>.</li>
    <li><strong>Xóa tệp vật lý</strong>: Khi Hard Delete sách, bắt buộc phải giải phóng dung lượng ổ cứng bằng cách xóa tệp vật lý tương ứng.</li>
</ul>`,
        code: `// Code dọn dẹp file vật lý từ Lab 4/5
var wwwRootPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
if (!string.IsNullOrEmpty(book.Avatar))
{
    var avatarFullPath = Path.Combine(wwwRootPath, book.Avatar.TrimStart('/'));
    if (System.IO.File.Exists(avatarFullPath))
    {
        System.IO.File.Delete(avatarFullPath); // Xóa file vật lý khỏi server
    }
}`,
        pitfalls: `<h4>⚠️ Lỗi Thường Gặp & Lưu Ý Khi Đi Thi:</h4>
<ol class="list-decimal pl-5 space-y-2 mt-2">
    <li><strong>Không kiểm tra sự tồn tại của file trước khi xóa</strong>: Gọi lệnh <code>File.Delete()</code> trực tiếp trên đường dẫn không tồn tại sẽ gây ra lỗi crash chương trình. Luôn check <code>File.Exists()</code> trước.</li>
</ol>`
    },
    {
        id: "lab7_testing",
        title: "7. Unit Testing & Integration Testing (Lab 7)",
        desc: "Đặc biệt quan trọng: Ôn tập viết Unit Test bằng xUnit + Moq và viết Integration Test giả lập pipeline HTTP.",
        theory: `<h3>Kiểm thử phần mềm Web API chuyên sâu</h3>
<p>Lab 7 là bài lab trọng tâm ôn tập thi cuối kỳ, yêu cầu thiết lập hệ thống kiểm thử toàn diện:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>Unit Test (Kiểm thử đơn vị)</strong>: Kiểm tra độc lập một đơn vị nhỏ nhất (thường là một Action trong Controller). Sử dụng thư viện <strong>Moq</strong> để giả lập hành vi của tầng Repository hay DbContext mà không tương tác với cơ sở dữ liệu thật.</li>
    <li><strong>Arrange-Act-Assert (AAA)</strong>: Quy chuẩn viết test:
        <ul class="list-none pl-4 space-y-0.5">
            <li>- <em>Arrange</em>: Chuẩn bị dữ liệu giả, mock các phụ thuộc.</li>
            <li>- <em>Act</em>: Thực thi hàm cần kiểm tra.</li>
            <li>- <em>Assert</em>: Kiểm chứng kết quả đầu ra (so sánh trạng thái trả về).</li>
        </ul>
    </li>
    <li><strong>Integration Test (Kiểm thử tích hợp)</strong>: Kiểm tra sự phối hợp của cả hệ thống HTTP pipeline. Sử dụng <code>WebApplicationFactory&lt;Program&gt;</code> để khởi tạo một máy chủ ảo chạy ngầm và cấu hình cơ sở dữ liệu In-Memory (SQL tạm thời chạy trên RAM) để test thực tế các yêu cầu gửi nhận HTTP.</li>
</ul>`,
        code: `// Minh họa viết Test kiểm thử tích hợp (Lab 7)
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

public class CustomWebApplicationFactory<TProgram> : WebApplicationFactory<TProgram> where TProgram : class
{
    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureServices(services =>
        {
            // Cấu hình cơ sở dữ liệu ảo In-Memory chạy trên RAM
            services.AddDbContext<AppDbContext>(options =>
            {
                options.UseInMemoryDatabase("InMemoryDbForTesting");
            });
        });
    }
}

public class BooksApiIntegrationTests : IClassFixture<CustomWebApplicationFactory<Program>>
{
    private readonly HttpClient _client;
    public BooksApiIntegrationTests(CustomWebApplicationFactory<Program> factory) => _client = factory.CreateClient();

    [Fact]
    public async Task GET_Books_Returns200OK()
    {
        var response = await _client.GetAsync("/api/books");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode); // Kiểm tra mã trạng thái
    }
}`,
        pitfalls: `<h4>⚠️ Lỗi Thường Gặp & Lưu Ý Khi Đi Thi:</h4>
<ol class="list-decimal pl-5 space-y-2 mt-2">
    <li><strong>Chạy kiểm thử tích hợp ghi đè lên Database thật</strong>: Nếu không cấu hình ghi đè dịch vụ DbContext sang In-Memory trong CustomWebApplicationFactory, các integration test sẽ thực thi lệnh trên database thật, gây lỗi sai lệch dữ liệu sản xuất.</li>
    <li><strong>Không Mock các API được đánh dấu bảo mật</strong>: Khi test các endpoint có [Authorize], integration test sẽ trả về 401 Unauthorized. Cần viết helper tự động đính kèm JWT Bearer Token giả lập vào HttpClient trước khi gọi API.</li>
</ol>`
    },
    {
        id: "lab8_repo",
        title: "8. Generic Repository Pattern (Lab 8)",
        desc: "Đặc biệt quan trọng: Ôn tập thiết kế khuôn mẫu IRepository để tái sử dụng mã nguồn và quản lý DI.",
        theory: `<h3>Mẫu thiết kế Generic Repository</h3>
<p>Lab 8 là bài ôn tập trọng tâm cuối kỳ thứ 2, giúp tinh gọn kiến trúc dữ liệu:</p>
<ul class="list-disc pl-5 space-y-1">
    <li><strong>Mục đích</strong>: Tránh việc viết lặp đi lặp lại các phương thức CRUD giống hệt nhau (GetAll, GetById, Add, Update, Delete) cho nhiều thực thể khác nhau (Fruit, Category, User, Order).</li>
    <li><strong>Ràng buộc Generic</strong>: Sử dụng mệnh đề <code>where T : class</code> để chỉ định kiểu dữ liệu truyền vào bắt buộc phải là một lớp đối tượng.</li>
    <li><strong>Dependency Injection</strong>: Đăng ký kiểu generic mở rộng trong <code>Program.cs</code>:
        <pre class="dracula-code p-2 rounded mt-1 font-mono text-[11px]">
builder.Services.AddScoped(typeof(IRepository<>), typeof(Repository<>));</pre>
    </li>
</ul>`,
        code: `// Định nghĩa Interface Generic Repository từ Lab 8
public interface IRepository<T> where T : class
{
    Task<IEnumerable<T>> GetAllAsync();
    Task<T?> GetByIdAsync(int id);
    Task<T> AddAsync(T entity);
    Task<T?> UpdateAsync(int id, T entity);
    Task<bool> DeleteAsync(int id);
}

// Triển khai Repository dạng Generic dùng chung cho mọi Model
public class Repository<T> : IRepository<T> where T : class
{
    protected readonly AppDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public Repository(AppDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>(); // Lấy DbSet tương ứng động
    }

    public async Task<IEnumerable<T>> GetAllAsync() => await _dbSet.ToListAsync();
    public async Task<T?> GetByIdAsync(int id) => await _dbSet.FindAsync(id);
    public async Task<T> AddAsync(T entity) {
        await _dbSet.AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }
    // ... Triển khai Update, Delete tương tự
}`,
        pitfalls: `<h4>⚠️ Lỗi Thường Gặp & Lưu Ý Khi Đi Thi:</h4>
<ol class="list-decimal pl-5 space-y-2 mt-2">
    <li><strong>Thiết lập sai kiểu đăng ký DI</strong>: Viết sai cú pháp đăng ký Generic mở rộng trong Program.cs khiến hệ thống báo lỗi không thể tạo kiểu cho repository.</li>
    <li><strong>Sử dụng FindAsync trên các thực thể có quan hệ phức tạp</strong>: Hàm <code>FindAsync()</code> của DbSet chỉ tìm theo khóa chính và không tự động JOIN tải dữ liệu liên quan. Nếu muốn lấy kèm dữ liệu thực thể con, bắt buộc phải dùng <code>Include()</code> kết hợp với <code>FirstOrDefaultAsync()</code>.</li>
</ol>`
    }
];

// Active State
let currentExam = 'fruits';
let currentTab = 'review'; // Start in Knowledge Review tab by default!
let activeReviewId = 'lab1_2';
let activeReviewSubtab = 'theory';
let currentQuizIndex = 0;
let userAnswers = [];

// Initialize
window.addEventListener('DOMContentLoaded', () => {
    switchExam('fruits');
    switchTab('review'); // Default tab
    renderKnowledgeReviewMenu();
    showReviewTopic('lab1_2');
    renderCheatSheets();
    initQuiz();
    
    document.getElementById('btn-generate-mock').addEventListener('click', generateMockExam);
});

// Switch Semesters/Exams
window.switchExam = function(examId) {
    currentExam = examId;
    
    // Toggle active classes on exam buttons
    const exams = ['fruits', 'pets', 'hr'];
    exams.forEach(ex => {
        const btn = document.getElementById(`exam-tab-${ex}`);
        if (btn) {
            if (ex === examId) {
                btn.className = 'px-4 py-1.5 rounded-md text-xs font-medium transition-all segment-active';
            } else {
                btn.className = 'px-3 py-1.5 bg-slate-800 hover:bg-slate-700 text-gray-300 rounded transition text-xs font-semibold';
            }
        }
    });
    
    renderExamPaper(examId);
    renderSolutions(examId);
};

// Switch between Tabs
window.switchTab = function(tabId) {
    currentTab = tabId;
    
    // Set visibility of tab content sections
    const tabs = ['review', 'practice', 'cheatsheet', 'mock', 'quiz'];
    tabs.forEach(t => {
        const section = document.getElementById(`tab-content-${t}`);
        if (section) {
            section.classList.toggle('hidden', t !== tabId);
        }
        
        const btn = document.getElementById(`tab-btn-${t}`);
        if (btn) {
            if (t === tabId) {
                btn.className = "w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium sidebar-btn-active transition shadow-sm";
            } else {
                btn.className = "w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium sidebar-btn-inactive transition";
            }
        }
    });
};

// Print Exam Paper
window.printExam = function() {
    window.print();
};

// Render EIU Exam Paper replica (fruits, pets, hr)
function renderExamPaper(examId) {
    const container = document.getElementById('exam-paper-container');
    
    if (examId === 'fruits') {
        container.innerHTML = `
            <div class="eiu-exam-paper p-8 bg-transparent border border-slate-300 shadow-md max-w-4xl mx-auto rounded">
                <div class="flex justify-between items-start border-b border-black pb-4 mb-4">
                    <div class="text-center w-1/2">
                        <div class="font-bold text-sm">TRƯỜNG ĐẠI HỌC QUỐC TẾ MIỀN ĐÔNG</div>
                        <div class="font-bold text-xs text-blue-800">EASTERN INTERNATIONAL UNIVERSITY</div>
                        <div class="mt-2 text-xs font-semibold">School of Computing and Information Technology</div>
                    </div>
                    <div class="text-center w-1/2">
                        <div class="font-bold text-sm">FINAL EXAM PAPER</div>
                        <div class="font-bold text-xs">Quarter: 1 – Academic year: 2025 – 2026</div>
                    </div>
                </div>
                
                <div class="grid grid-cols-2 gap-y-1 gap-x-8 text-xs border-b border-black pb-4 mb-4">
                    <div><strong>Course code:</strong> CSW 306</div>
                    <div><strong>Exam code:</strong> 01</div>
                    <div><strong>Course name:</strong> Backend Development</div>
                    <div><strong>Duration:</strong> 120'</div>
                    <div><strong>Type of Exam:</strong> Open book / Practice on Computer</div>
                    <div><strong>Maximum mark:</strong> 100</div>
                </div>

                <div class="text-xs mb-4">
                    <h4 class="font-bold underline">Instructions:</h4>
                    <ul class="list-disc pl-5 space-y-1">
                        <li>Non-programming calculator: <em>Yes ☑ | No ☐</em></li>
                        <li>This paper consists of 3 questions. This paper carries 100 marks:
                            <ul class="list-none pl-4 mt-1 font-semibold">
                                <li>Question 1 (30 marks)</li>
                                <li>Question 2 (30 marks)</li>
                                <li>Question 3 (40 marks)</li>
                            </ul>
                        </li>
                    </ul>
                </div>

                <div class="border-t border-dashed border-black my-4"></div>

                <div class="mt-4">
                    <h3 class="font-bold text-center text-sm underline mb-4">FRUITS STORE MANAGEMENT SOFTWARE</h3>
                    <p class="text-xs mb-4">Company ProMaxSuperUltraBeauty wants to build an internal Web API system to manage their fruit store and employees.</p>

                    <h4 class="font-bold text-xs mt-4">Question 1: Database, Model and DbContext Design (30 marks)</h4>
                    <p class="text-xs"><strong>Task:</strong> Design the core database and model for the Fruit Store Management System.</p>
                    
                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: User</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity / Auto-increment</td></tr>
                                <tr><td>FullName</td><td>NVARCHAR(200)</td><td></td></tr>
                                <tr><td>Email</td><td>NVARCHAR(255)</td><td>NOT NULL, UNIQUE, Email format validation</td></tr>
                                <tr><td>Password</td><td>NVARCHAR(MAX)</td><td>NOT NULL</td></tr>
                                <tr><td>Role</td><td>NVARCHAR(20)</td><td>NOT NULL: 'Admin' / 'User'</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: Categories</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>Name</td><td>NVARCHAR(50)</td><td>NOT NULL, UNIQUE</td></tr>
                                <tr><td>Description</td><td>NVARCHAR(255)</td><td>Optional</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: Fruits</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>Name</td><td>NVARCHAR(100)</td><td>NOT NULL</td></tr>
                                <tr><td>Price</td><td>DECIMAL(10,2)</td><td>NOT NULL, positive</td></tr>
                                <tr><td>StockQuantity</td><td>FLOAT</td><td>Default: 0</td></tr>
                                <tr><td>CategoryId</td><td>INT</td><td>FK → Categories(Id), NOT NULL</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: Orders</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>UserId</td><td>INT</td><td>FK → Users(Id), NOT NULL</td></tr>
                                <tr><td>OrderDate</td><td>DATETIME</td><td>NOT NULL, cannot be in future</td></tr>
                                <tr><td>TotalAmount</td><td>DECIMAL(10,2)</td><td>Computed or calculated</td></tr>
                                <tr><td>Status</td><td>NVARCHAR(20)</td><td>e.g., 'Pending', 'Completed', 'Cancelled'</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: OrderItems</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>OrderId</td><td>INT</td><td>FK → Orders(Id), NOT NULL</td></tr>
                                <tr><td>FruitId</td><td>INT</td><td>FK → Fruits(Id), NOT NULL</td></tr>
                                <tr><td>Quantity</td><td>INT</td><td>NOT NULL, positive</td></tr>
                                <tr><td>UnitPrice</td><td>DECIMAL(10,2)</td><td>Price at time of order</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <h4 class="font-bold text-xs mt-6">Question 2: Repository Layer (30 marks)</h4>
                    <p class="text-xs">Create <strong>IFruitRepository</strong> and <strong>FruitRepository</strong>: GetAll(), GetById(int id), Add(Fruit fruit), Update(Fruit fruit), Delete(int id), GetByCategoryId(int categoryId) — all methods must use AppDbContext. Repositories for Category, User, Orders, OrderItems are optional (same pattern).</p>

                    <h4 class="font-bold text-xs mt-6">Question 3: API Controller (40 marks)</h4>
                    <p class="text-xs font-semibold mb-1">1. FruitsController</p>
                    <table class="mt-1 mb-3">
                        <thead><tr><th>Method</th><th>Route</th><th>Description</th></tr></thead>
                        <tbody>
                            <tr><td>GET</td><td>/api/fruits</td><td>Fruits with category info (nested or flat accepted)</td></tr>
                            <tr><td>GET</td><td>/api/fruits/{id}</td><td>Return fruit by ID</td></tr>
                            <tr><td>POST</td><td>/api/fruits</td><td>Create new fruit</td></tr>
                            <tr><td>PUT</td><td>/api/fruits/{id}</td><td>Update fruit</td></tr>
                            <tr><td>DELETE</td><td>/api/fruits/{id}</td><td>Delete fruit</td></tr>
                        </tbody>
                    </table>
                    <p class="text-xs font-semibold mb-1">2. OrdersController</p>
                    <table class="mt-1 mb-3">
                        <thead><tr><th>Method</th><th>Route</th><th>Description</th></tr></thead>
                        <tbody>
                            <tr><td>GET</td><td>/api/orders</td><td>List orders (include items)</td></tr>
                            <tr><td>POST</td><td>/api/orders</td><td>Create new order with a list of order items</td></tr>
                            <tr><td>GET</td><td>/api/orders/user/{userId}</td><td>Get orders by user (must match JWT userId)</td></tr>
                        </tbody>
                    </table>
                    <p class="text-xs">When creating an order: extract userId from JWT, set orderDate = current server time, status = "Pending", calculate unitPrice from current Fruit.Price and totalAmount = Σ(quantity × unitPrice); validate fruitId exists, quantity &gt; 0, and stock is sufficient.</p>
                    <p class="text-xs mt-2"><strong>3. AuthController:</strong> POST /api/auth/login — returns a JWT token. &nbsp; <strong>4. CategoryController:</strong> GET /api/categories — list all categories.</p>
                    <p class="text-xs mt-2"><strong>Authorization:</strong> Admin creates/updates/deletes fruits and views all orders. Authenticated users can create orders. Users view only their own orders. Public (no login) can view fruits and categories.</p>

                    <div class="bg-slate-100 border border-slate-300 rounded p-3 mt-4 text-xs">
                        <p class="font-bold underline mb-1">IMPORTANT NOTES</p>
                        <p>Manually create test users in the database: at least 1 Admin (Role = "Admin") and 1 Normal user (Role = "User"). Plain-text passwords are OK for testing.</p>
                        <p class="mt-1">Example: <strong>admin@test.com</strong> / admin123 / Admin — <strong>user@test.com</strong> / user123 / User. Include these users in the database backup submission.</p>
                    </div>

                    <div class="mt-8 flex justify-between items-center text-xs">
                        <div>
                            <p class="font-bold text-center">Cuong Nguyen Xuan</p>
                            <p class="italic text-gray-500 text-center">Lecturer's signature</p>
                        </div>
                        <div class="font-bold text-slate-700">------ The End ------</div>
                    </div>
                </div>
            </div>
        `;
    } else if (examId === 'pets') {
        container.innerHTML = `
            <div class="eiu-exam-paper p-8 bg-transparent border border-slate-300 shadow-md max-w-4xl mx-auto rounded">
                <div class="flex justify-between items-start border-b border-black pb-4 mb-4">
                    <div class="text-center w-1/2">
                        <div class="font-bold text-sm">TRƯỜNG ĐẠI HỌC QUỐC TẾ MIỀN ĐÔNG</div>
                        <div class="font-bold text-xs text-blue-800">EASTERN INTERNATIONAL UNIVERSITY</div>
                        <div class="mt-2 text-xs font-semibold">School of Computing and Information Technology</div>
                    </div>
                    <div class="text-center w-1/2">
                        <div class="font-bold text-sm">FINAL EXAM PAPER</div>
                        <div class="font-bold text-xs">Quarter: 3 – Academic year: 2025 – 2026</div>
                    </div>
                </div>
                
                <div class="grid grid-cols-2 gap-y-1 gap-x-8 text-xs border-b border-black pb-4 mb-4">
                    <div><strong>Course code:</strong> CSW 306</div>
                    <div><strong>Exam code:</strong> 01</div>
                    <div><strong>Course name:</strong> Backend Development</div>
                    <div><strong>Duration:</strong> 120'</div>
                    <div><strong>Type of Exam:</strong> Open book / Practice on Computer</div>
                    <div><strong>Maximum mark:</strong> 100</div>
                </div>

                <div class="text-xs mb-4">
                    <h4 class="font-bold underline">Instructions:</h4>
                    <ul class="list-disc pl-5 space-y-1">
                        <li>Non-programming calculator: <em>Yes ☑ | No ☐</em></li>
                        <li>This paper consists of 4 questions. This paper carries 100 marks:
                            <ul class="list-none pl-4 mt-1 font-semibold">
                                <li>Question 1 (30 marks)</li>
                                <li>Question 2 (30 marks)</li>
                                <li>Question 3 (30 marks)</li>
                                <li>Question 4 (10 marks)</li>
                            </ul>
                        </li>
                    </ul>
                </div>

                <div class="border-t border-dashed border-black my-4"></div>

                <div class="mt-4">
                    <h3 class="font-bold text-center text-sm underline mb-4">PET STORE MANAGEMENT SOFTWARE</h3>
                    <p class="text-xs mb-4">Company <strong>HappyPaws</strong> wants to build an internal Web API system to manage pets, pet categories, customers, and pet purchase transactions.</p>

                    <h4 class="font-bold text-xs mt-4">Question 1: Database, Model and DbContext Design (30 marks)</h4>
                    <ol class="list-decimal pl-5 text-xs space-y-2 mt-2">
                        <li>Create classes & relationships:
                            <ul class="list-disc pl-5 mt-1">
                                <li>A Pet belongs to one PetCategory. PetCategory has many Pets.</li>
                                <li>A User has one Role stored as a property ("Admin", "Customer").</li>
                                <li>A PurchaseOrder belongs to one User. Contains many PurchaseItems.</li>
                                <li>A PurchaseItem belongs to one PurchaseOrder and one Pet.</li>
                            </ul>
                        </li>
                        <li>Data Annotations / Validation:
                            <ul class="list-disc pl-5 mt-1">
                                <li>Pet: Name (required, max 100 chars), Price (required, positive).</li>
                                <li>PetCategory: Name (required, max 50 chars).</li>
                                <li>User: FullName (required, max 200 chars), Email (required, valid email), Role (required).</li>
                                <li>PurchaseOrder: OrderDate cannot be a future date.</li>
                            </ul>
                        </li>
                        <li>Create AppDbContext and declare: DbSet&lt;Pet&gt;, DbSet&lt;PetCategory&gt;, DbSet&lt;User&gt;, DbSet&lt;PurchaseOrder&gt;, DbSet&lt;PurchaseItem&gt;.</li>
                    </ol>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: User</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>FullName</td><td>NVARCHAR(200)</td><td>NOT NULL</td></tr>
                                <tr><td>Email</td><td>NVARCHAR(255)</td><td>NOT NULL, UNIQUE</td></tr>
                                <tr><td>Password</td><td>NVARCHAR(MAX)</td><td>NOT NULL</td></tr>
                                <tr><td>Role</td><td>NVARCHAR(20)</td><td>NOT NULL ('Admin', 'Customer')</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: PetCategories</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>Name</td><td>NVARCHAR(50)</td><td>NOT NULL, UNIQUE</td></tr>
                                <tr><td>Description</td><td>NVARCHAR(255)</td><td>Optional</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: Pets</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>Name</td><td>NVARCHAR(100)</td><td>NOT NULL</td></tr>
                                <tr><td>Breed</td><td>NVARCHAR(100)</td><td>NOT NULL</td></tr>
                                <tr><td>Age</td><td>INT</td><td>Positive value</td></tr>
                                <tr><td>Price</td><td>DECIMAL(10,2)</td><td>NOT NULL, Positive</td></tr>
                                <tr><td>CategoryId</td><td>INT</td><td>FK → PetCategories(Id), NOT NULL</td></tr>
                                <tr><td>Quantity</td><td>INT</td><td>Default 0</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: PurchaseOrders</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>UserId</td><td>INT</td><td>FK → Users(Id), NOT NULL</td></tr>
                                <tr><td>OrderDate</td><td>DATETIME</td><td>NOT NULL</td></tr>
                                <tr><td>TotalAmount</td><td>DECIMAL(10,2)</td><td>Calculated</td></tr>
                                <tr><td>Status</td><td>NVARCHAR(20)</td><td>Pending / Completed / Cancelled</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-4">
                        <span class="text-xs font-semibold">Table: PurchaseItems</span>
                        <table class="mt-1">
                            <thead>
                                <tr><th>Field</th><th>Type</th><th>Constraints / Notes</th></tr>
                            </thead>
                            <tbody>
                                <tr><td>Id</td><td>INT</td><td>PK, Identity</td></tr>
                                <tr><td>PurchaseOrderId</td><td>INT</td><td>FK → PurchaseOrders(Id), NOT NULL</td></tr>
                                <tr><td>PetId</td><td>INT</td><td>FK → Pets(Id), NOT NULL</td></tr>
                                <tr><td>Quantity</td><td>INT</td><td>Positive value</td></tr>
                                <tr><td>UnitPrice</td><td>DECIMAL(10,2)</td><td>Pet price at purchase time</td></tr>
                                <tr><td>CreatedAt</td><td>DATETIME</td><td>Default GETDATE()</td></tr>
                            </tbody>
                        </table>
                    </div>

                    <h4 class="font-bold text-xs mt-6">Question 2: Repository Layer (30 marks)</h4>
                    <p class="text-xs">Create <strong>IPetRepository</strong> and <strong>PetRepository</strong> (CRUD + GetByCategoryId). Implement the <strong>User repository layer</strong> as well. All methods use AppDbContext and async/await.</p>

                    <h4 class="font-bold text-xs mt-6">Question 3: API Controller and Security (30 marks)</h4>
                    <p class="text-xs">Create RESTful APIs for managing Pets and Purchase Orders. Use [Required]/[Range]/[EmailAddress]; return 400 for invalid data, 404 for missing resources. Implement JWT Authentication + Role-based Authorization: <strong>Admin</strong> creates/updates/deletes pets and views all orders; <strong>Customer</strong> creates orders and views only their own; <strong>Guest</strong> can view pets and categories.</p>

                    <h4 class="font-bold text-xs mt-6">Question 4: Project Documentation Report (10 marks)</h4>
                    <p class="text-xs">Prepare a report document (.docx) describing your implementation and testing process: <strong>Section 1</strong> Database Design (2 marks) — screenshots of tables, relationships, sample data; <strong>Section 2</strong> Project Structure (3 marks) — screenshots of Solution Explorer, Models, DbContext, Repositories, Controllers; <strong>Section 3</strong> API Testing Results (5 marks) — screenshots of Login/JWT, GET/POST/PUT/DELETE Pets, POST Order, and Admin vs Customer authorization tests (each showing Request URL, HTTP Method, Request Body, Response Data).</p>

                    <div class="bg-slate-100 border border-slate-300 rounded p-3 mt-4 text-xs">
                        <p class="font-bold underline mb-1">IMPORTANT NOTES</p>
                        <p>Create test users directly in SQL Server via SSMS: at least 1 Admin (Role = "Admin") and 1 Customer (Role = "Customer"). Password hashing is optional.</p>
                        <p class="mt-1">Example: <strong>admin@test.com</strong> / 123 / Admin — <strong>customer@test.com</strong> / 123 / Customer. Include these users in the database backup submission.</p>
                    </div>

                    <div class="mt-8 flex justify-between items-center text-xs">
                        <div>
                            <p class="font-bold text-center">Cuong Nguyen Xuan</p>
                            <p class="italic text-gray-500 text-center">Lecturer's signature</p>
                        </div>
                        <div class="font-bold text-slate-700">------ The End ------</div>
                    </div>
                </div>
            </div>
        `;
    } else {
        container.innerHTML = `
            <div class="eiu-exam-paper p-8 bg-transparent border border-slate-300 shadow-md max-w-4xl mx-auto rounded">
                <div class="flex justify-between items-start border-b border-black pb-4 mb-4">
                    <div class="text-center w-1/2">
                        <div class="font-bold text-sm">TRƯỜNG ĐẠI HỌC QUỐC TẾ MIỀN ĐÔNG</div>
                        <div class="font-bold text-xs text-blue-800">EASTERN INTERNATIONAL UNIVERSITY</div>
                        <div class="mt-2 text-xs font-semibold">School of Computing and Information Technology</div>
                    </div>
                    <div class="text-center w-1/2">
                        <div class="font-bold text-sm">FINAL EXAM PAPER</div>
                        <div class="font-bold text-xs">Quarter: 4 – Academic year: 2024 – 2025</div>
                    </div>
                </div>
                
                <div class="grid grid-cols-2 gap-y-1 gap-x-8 text-xs border-b border-black pb-4 mb-4">
                    <div><strong>Course code:</strong> CSW 306</div>
                    <div><strong>Exam code:</strong> 01</div>
                    <div><strong>Course name:</strong> Backend Development</div>
                    <div><strong>Duration:</strong> 120'</div>
                    <div><strong>Type of Exam:</strong> Opened book / Practice on Computer</div>
                    <div><strong>Maximum mark:</strong> 100</div>
                </div>

                <div class="text-xs mb-4">
                    <h4 class="font-bold underline">Instructions:</h4>
                    <ul class="list-disc pl-5 space-y-1">
                        <li>Non-programming calculator: <em>Yes ☑ | No ☐</em></li>
                        <li>This paper consists of 5 questions. This paper carries 100 marks:
                            <ul class="list-none pl-4 mt-1 font-semibold">
                                <li>Question 1 (20 marks)</li>
                                <li>Question 2 (25 marks)</li>
                                <li>Question 3 (40 marks)</li>
                                <li>Question 4 (15 marks)</li>
                            </ul>
                        </li>
                    </ul>
                </div>

                <div class="border-t border-dashed border-black my-4"></div>

                <div class="mt-4">
                    <h3 class="font-bold text-center text-sm underline mb-4">HUMAN RESOURCE MANAGEMENT SYSTEM</h3>
                    <p class="text-xs mb-4">XYZ wants to build an internal Web API system to manage employees and departments.</p>

                    <h4 class="font-bold text-xs mt-4">Question 1: Database, Model and DbContext Design (20 marks)</h4>
                    <p class="text-xs">One department has many employees. Employee belongs to one department. Validations: FullName (max 200 chars), Email (valid email format), StartDate (not in the future).</p>

                    <h4 class="font-bold text-xs mt-6">Question 2: Repository and Service Layer (25 marks)</h4>
                    <p class="text-xs">Create IEmployeeRepository/EmployeeRepository and IEmployeeService/EmployeeService with standard CRUD + GetByDepartmentId.</p>

                    <h4 class="font-bold text-xs mt-6">Question 3: API Controller (40 marks)</h4>
                    <p class="text-xs">Create EmployeesController with standard CRUD endpoints. GET api/employees must return nested department name.</p>

                    <h4 class="font-bold text-xs mt-6">Question 4: Advanced: Nested JSON Handling (15 marks)</h4>
                    <p class="text-xs">Allow nested JSON input when creating employees, e.g. <code>{ "fullName", "email", "startDate", "department": { "name": "IT" } }</code>. If the department does not exist, create a new one; if it already exists, assign the employee to it. Return employee data with nested department information when calling GET /api/employees.</p>

                    <div class="mt-8 flex justify-between items-center text-xs">
                        <div>
                            <p class="font-bold text-center">Cuong Nguyen Xuan</p>
                            <p class="italic text-gray-500 text-center">Lecturer's signature</p>
                        </div>
                        <div class="font-bold text-slate-700">------ The End ------</div>
                    </div>
                </div>
            </div>
        `;
    }
}

// Render Knowledge Review split-pane left-column menu index
function renderKnowledgeReviewMenu() {
    const container = document.getElementById('knowledge-review-container');
    if (!container) return;
    
    container.className = "flex flex-col lg:flex-row border border-white/10 rounded-xl overflow-hidden bg-transparent shadow-xl h-[560px]";
    
    container.innerHTML = `
        <!-- Left Index Menu Pane -->
        <div class="w-full lg:w-72 bg-black/20 border-r border-white/10 overflow-y-auto flex-shrink-0">
            <div class="p-4 border-b border-white/10 bg-transparent/20">
                <span class="text-xs font-bold text-gray-500 uppercase tracking-wider">Cấu Trúc Lớp Học (Lab 1-8)</span>
            </div>
            <div class="divide-y divide-slate-900/50" id="review-topics-list">
                ${knowledgeReview.map(topic => `
                    <button onclick="showReviewTopic('${topic.id}')" id="topic-item-${topic.id}" class="w-full text-left p-4 text-xs font-medium doc-sidebar-item-inactive transition flex items-center justify-between">
                        <span>${topic.title}</span>
                        <i class="fas fa-chevron-right text-[10px] opacity-30"></i>
                    </button>
                `).join('')}
            </div>
        </div>
        
        <!-- Right Article Viewport Pane -->
        <div class="flex-1 flex flex-col bg-transparent overflow-hidden">
            <!-- Article Subtab bar -->
            <div class="flex border-b border-white/10 bg-black/40 text-xs px-6 py-2 gap-6 select-none flex-shrink-0">
                <button onclick="setReviewSubtab('theory')" id="subtab-theory" class="py-2 font-medium subtab-active transition">
                    <i class="fas fa-book-reader mr-1.5"></i> Lý thuyết chuyên sâu
                </button>
                <button onclick="setReviewSubtab('code')" id="subtab-code" class="py-2 font-medium subtab-inactive transition">
                    <i class="fas fa-code-branch mr-1.5"></i> Cú pháp & Code mẫu
                </button>
                <button onclick="setReviewSubtab('pitfalls')" id="subtab-pitfalls" class="py-2 font-medium subtab-inactive transition text-violet-400">
                    <i class="fas fa-exclamation-triangle mr-1.5 text-violet-400"></i> Tránh bẫy phòng thi
                </button>
            </div>
            
            <!-- Article Scrollable Content Area -->
            <div class="flex-1 p-6 overflow-y-auto text-sm leading-relaxed" id="topic-viewport-body">
                <!-- Data injected dynamically -->
            </div>
        </div>
    `;
}

// Show selected topic in viewport
window.showReviewTopic = function(topicId) {
    activeReviewId = topicId;
    
    knowledgeReview.forEach(topic => {
        const btn = document.getElementById(`topic-item-${topic.id}`);
        if (btn) {
            btn.className = topic.id === topicId ? 
                "w-full text-left p-4 text-xs font-medium doc-sidebar-item-active transition flex items-center justify-between" :
                "w-full text-left p-4 text-xs font-medium doc-sidebar-item-inactive transition flex items-center justify-between";
        }
    });
    
    renderActiveSubtabContent();
};

// Set subtab (theory, code, pitfalls) in active topic view
window.setReviewSubtab = function(subtabId) {
    activeReviewSubtab = subtabId;
    
    const subtabs = ['theory', 'code', 'pitfalls'];
    subtabs.forEach(sub => {
        const btn = document.getElementById(`subtab-${sub}`);
        if (btn) {
            if (sub === subtabId) {
                btn.className = "py-2 font-medium subtab-active transition";
            } else {
                btn.className = "py-2 font-medium subtab-inactive transition";
            }
        }
    });
    
    renderActiveSubtabContent();
};

// Render active topic's active subtab content in right pane
function renderActiveSubtabContent() {
    const topic = knowledgeReview.find(t => t.id === activeReviewId);
    const viewport = document.getElementById('topic-viewport-body');
    if (!topic || !viewport) return;
    
    if (activeReviewSubtab === 'theory') {
        viewport.innerHTML = `
            <div class="space-y-4 text-gray-200 prose max-w-none text-xs">
                <h3 class="text-base font-bold text-cyan-400 border-b border-white/10 pb-2 mb-3"><i class="fas fa-file-invoice mr-2"></i> ${topic.title}</h3>
                ${topic.theory}
            </div>
        `;
    } else if (activeReviewSubtab === 'code') {
        viewport.innerHTML = `
            <div class="space-y-4 text-xs">
                <div class="flex items-center justify-between border-b border-white/10 pb-2 mb-3">
                    <h3 class="text-base font-bold text-cyan-400"><i class="fas fa-terminal mr-2"></i> Minh Họa Code Mẫu C#</h3>
                    <button onclick="copyToClipboard('active-topic-code')" class="bg-transparent border border-gray-200 text-gray-300 hover:bg-black/20 shadow-sm px-2.5 py-1 text-xs rounded flex items-center gap-1.5 shadow transition">
                        <i class="far fa-copy"></i> Copy
                    </button>
                </div>
                <pre class="bg-black/20 text-gray-200 p-4 rounded-lg font-mono overflow-x-auto max-h-[380px] border border-white/10 leading-relaxed select-all" id="active-topic-code">${escapeHtml(topic.code)}</pre>
            </div>
        `;
    } else if (activeReviewSubtab === 'pitfalls') {
        viewport.innerHTML = `
            <div class="space-y-4 text-gray-200 text-xs">
                <h3 class="text-base font-bold text-violet-400 border-b border-white/10 pb-2 mb-3"><i class="fas fa-exclamation-triangle mr-2"></i> Lưu ý / Tránh bẫy trong phòng thi</h3>
                <div class="bg-violet-900/20 border border-violet-500/30 p-4 rounded-lg text-gray-300">
                    ${topic.pitfalls}
                </div>
            </div>
        `;
    }
}

// Render guided C# solutions
function renderSolutions(examId) {
    const data = examSolutions[examId];
    const container = document.getElementById('solutions-container');
    
    container.innerHTML = `
        <div class="space-y-6">
            <div class="flex justify-between items-center bg-transparent border border-white/10 p-4 rounded-lg shadow-sm">
                <div>
                    <h3 class="text-base font-bold text-cyan-400">Lời giải chi tiết: ${data.title}</h3>
                    <p class="text-xs text-gray-500">Kiến trúc tách biệt, an toàn, sử dụng đúng cú pháp quy định trong các bài Lab từ 1 đến 8.</p>
                </div>
            </div>
            
            <div class="space-y-4">
                ${Object.keys(data.questions).map(key => {
                    const q = data.questions[key];
                    return `
                        <div class="tech-glass rounded-xl overflow-hidden">
                            <button onclick="toggleAccordion('${key}')" class="w-full text-left p-4 bg-black/40 border-b border-white/10 flex justify-between items-center hover:bg-white/5 transition">
                                <span class="font-semibold text-gray-200 text-sm">${q.title}</span>
                                <i id="icon-${key}" class="fas fa-chevron-down text-gray-500"></i>
                            </button>
                            <div id="content-${key}" class="hidden p-4 space-y-3">
                                <p class="text-gray-500 text-xs italic">${q.desc}</p>
                                <div class="relative">
                                    <button onclick="copyToClipboard('${key}-code')" class="absolute top-2 right-2 bg-transparent border border-gray-200 text-gray-300 hover:bg-black/20 shadow-sm px-2.5 py-1 text-xs rounded flex items-center gap-1.5 shadow z-10">
                                        <i class="far fa-copy"></i> Copy
                                    </button>
                                    <pre class="bg-black/20 text-gray-200 p-4 rounded-lg text-xs font-mono overflow-x-auto max-h-96 leading-relaxed select-all" id="${key}-code">${escapeHtml(q.code)}</pre>
                                </div>
                            </div>
                        </div>
                    `;
                }).join('')}
            </div>
        </div>
    `;
}

// Toggle solutions accordion
window.toggleAccordion = function(key) {
    const el = document.getElementById(`content-${key}`);
    const icon = document.getElementById(`icon-${key}`);
    if (el.classList.contains('hidden')) {
        el.classList.remove('hidden');
        icon.className = 'fas fa-chevron-up text-gray-300';
    } else {
        el.classList.add('hidden');
        icon.className = 'fas fa-chevron-down text-gray-500';
    }
};

// Render Cheat Sheets
function renderCheatSheets() {
    const container = document.getElementById('cheatsheet-container');
    container.innerHTML = cheatSheets.map((sheet, index) => `
        <div class="bg-transparent border border-white/10 rounded-lg shadow-sm p-5 space-y-3">
            <h4 class="font-bold text-gray-200 text-sm border-b border-white/10 pb-2">${sheet.title}</h4>
            <p class="text-gray-500 text-xs">${sheet.desc}</p>
            <div class="relative">
                <button onclick="copyToClipboard('cheat-${index}-code')" class="absolute top-2 right-2 bg-transparent border border-gray-200 text-gray-300 hover:bg-black/20 shadow-sm px-2.5 py-1 text-xs rounded flex items-center gap-1.5 shadow z-10">
                    <i class="far fa-copy"></i> Copy
                </button>
                <pre class="bg-black/20 text-gray-200 p-4 rounded-lg text-xs font-mono overflow-x-auto max-h-80 leading-relaxed select-all" id="cheat-${index}-code">${escapeHtml(sheet.code)}</pre>
            </div>
        </div>
    `).join('');
}

// Mock Exam Generator
function generateMockExam() {
    const randomTheme = businessThemes[Math.floor(Math.random() * businessThemes.length)];
    const mockContainer = document.getElementById('mock-exam-paper');
    
    mockContainer.innerHTML = `
        <div class="eiu-exam-paper p-8 bg-transparent border border-slate-300 shadow-md max-w-4xl mx-auto rounded">
            <div class="flex justify-between items-start border-b border-black pb-4 mb-4">
                <div class="text-center w-1/2">
                    <div class="font-bold text-sm">TRƯỜNG ĐẠI HỌC QUỐC TẾ MIỀN ĐÔNG</div>
                    <div class="font-bold text-xs text-blue-800">EASTERN INTERNATIONAL UNIVERSITY</div>
                    <div class="mt-2 text-xs font-semibold">School of Computing and Information Technology</div>
                </div>
                <div class="text-center w-1/2">
                    <div class="font-bold text-sm">FINAL EXAM PAPER</div>
                    <div class="font-bold text-xs">Quarter: Mock Practice – Academic year: 2026 – 2027</div>
                </div>
            </div>
            
            <div class="grid grid-cols-2 gap-y-1 gap-x-8 text-xs border-b border-black pb-4 mb-4">
                <div><strong>Course code:</strong> CSW 306</div>
                <div><strong>Exam code:</strong> MOCK-${Math.floor(Math.random() * 900) + 100}</div>
                <div><strong>Course name:</strong> Backend Development</div>
                <div><strong>Duration:</strong> 120'</div>
                <div><strong>Type of Exam:</strong> Open book / Practice on Computer</div>
                <div><strong>Maximum mark:</strong> 100</div>
            </div>

            <div class="border-t border-dashed border-black my-4"></div>

            <div class="mt-4">
                <h3 class="font-bold text-center text-sm underline mb-4">${randomTheme.name.toUpperCase()}</h3>
                <p class="text-xs mb-4">Hãy xây dựng hệ thống quản lý RESTful API để giải quyết bài toán nghiệp vụ cho chủ đề trên.</p>

                <h4 class="font-bold text-xs mt-4">Question 1: Database, Model and DbContext Design (30 marks)</h4>
                <ol class="list-decimal pl-5 text-xs space-y-2 mt-2">
                    <li>Tạo cấu trúc thực thể cho các Models: <strong>${randomTheme.models.join(', ')}</strong>.</li>
                    <li>Thiết lập quan hệ:
                        <ul class="list-disc pl-5 mt-1">
                            ${randomTheme.relationships.map(r => `<li>${r}</li>`).join('')}
                        </ul>
                    </li>
                </ol>

                <h4 class="font-bold text-xs mt-6">Question 2: Repository Layer (30 marks)</h4>
                <p class="text-xs">Triển khai interface và lớp Repository cho thực thể <strong>${randomTheme.models[0]}</strong> với đầy đủ phương thức CRUD bất đồng bộ.</p>

                <h4 class="font-bold text-xs mt-6">Question 3: API Controller & Security (40 marks)</h4>
                <p class="text-xs">Xây dựng API Controller lớp Endpoint tương ứng:</p>
                <table class="mt-2">
                    <thead>
                        <tr><th>Method</th><th>Route</th><th>Description</th></tr>
                    </thead>
                    <tbody>
                        ${randomTheme.endpoints.map(e => `
                            <tr>
                                <td><span class="font-bold text-slate-800">${e.method}</span></td>
                                <td><code>${e.route}</code></td>
                                <td>${e.desc}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>

                <div class="mt-8 flex justify-between items-center text-xs">
                    <div>
                        <p class="font-bold text-center">Cuong Nguyen Xuan</p>
                        <p class="italic text-gray-500 text-center">Lecturer's signature</p>
                    </div>
                    <div class="font-bold text-slate-700">------ End of Mock Exam ------</div>
                </div>
            </div>
        </div>
    `;
    
    document.getElementById('mock-print-wrapper').classList.remove('hidden');
}

// Initialize Quiz
function initQuiz() {
    currentQuizIndex = 0;
    userAnswers = Array(quizQuestions.length).fill(null);
    showQuestion(0);
    updateQuizProgress();
    
    document.getElementById('quiz-prev').addEventListener('click', () => navigateQuiz(-1));
    document.getElementById('quiz-next').addEventListener('click', () => navigateQuiz(1));
    document.getElementById('quiz-submit').addEventListener('click', submitQuiz);
    document.getElementById('quiz-reset').addEventListener('click', resetQuiz);
}

// Display Quiz Question
function showQuestion(index) {
    currentQuizIndex = index;
    const q = quizQuestions[index];
    const container = document.getElementById('quiz-question-container');
    
    container.innerHTML = `
        <div class="space-y-4">
            <div class="flex items-start gap-3">
                <span class="bg-indigo-900/50 text-cyan-400 text-xs font-semibold px-2.5 py-1 rounded-full border border-indigo-500/20">Câu ${index + 1}/${quizQuestions.length}</span>
                <h4 class="text-sm font-semibold text-cyan-400">${q.question}</h4>
            </div>
            
            <div class="space-y-2 mt-4">
                ${q.options.map((opt, oIdx) => {
                    const isSelected = userAnswers[index] === oIdx;
                    return `
                        <label onclick="selectQuizOption(${index}, ${oIdx})" class="flex items-center gap-3 p-3 rounded-lg border cursor-pointer hover:bg-white/5 transition ${isSelected ? 'border-indigo-500 bg-indigo-950/20' : 'border-white/10 bg-black/20'}">
                            <input type="radio" name="question-${index}" ${isSelected ? 'checked' : ''} class="text-indigo-600 focus:ring-indigo-500 h-4 w-4 border-slate-700 bg-transparent">
                            <span class="text-xs text-gray-300">${opt}</span>
                        </label>
                    `;
                }).join('')}
            </div>
        </div>
    `;
    
    document.getElementById('quiz-prev').disabled = index === 0;
    document.getElementById('quiz-next').classList.toggle('hidden', index === quizQuestions.length - 1);
    document.getElementById('quiz-submit').classList.toggle('hidden', index !== quizQuestions.length - 1);
}

// Navigate Quiz Question
function navigateQuiz(dir) {
    const nextIdx = currentQuizIndex + dir;
    if (nextIdx >= 0 && nextIdx < quizQuestions.length) {
        showQuestion(nextIdx);
        updateQuizProgress();
    }
}

// Select option
window.selectQuizOption = function(qIdx, oIdx) {
    userAnswers[qIdx] = oIdx;
    showQuestion(qIdx);
    updateQuizProgress();
};

// Update ProgressBar
function updateQuizProgress() {
    const pct = ((currentQuizIndex + 1) / quizQuestions.length) * 100;
    const progressEl = document.getElementById('quiz-progress');
    if (progressEl) progressEl.style.width = `${pct}%`;
}

// Submit Quiz
function submitQuiz() {
    let score = 0;
    const resultsContainer = document.getElementById('quiz-results');
    resultsContainer.innerHTML = '';
    
    quizQuestions.forEach((q, idx) => {
        const uAns = userAnswers[idx];
        const isCorrect = uAns === q.answer;
        if (isCorrect) score++;
        
        resultsContainer.innerHTML += `
            <div class="p-4 border rounded-lg ${isCorrect ? 'border-green-800 bg-green-950/10' : 'border-red-800 bg-red-950/10'} space-y-2 text-xs">
                <div class="flex items-center justify-between">
                    <span class="font-bold text-cyan-400">${idx + 1}: ${isCorrect ? '🟢 Đúng' : '🔴 Sai'}</span>
                    <span class="text-gray-500">Đáp án: ${q.options[q.answer]}</span>
                </div>
                <p class="text-gray-300 font-medium">${q.question}</p>
                ${!isCorrect && uAns !== null ? `<p class="text-red-400">Bạn đã chọn: ${q.options[uAns]}</p>` : ''}
                ${uAns === null ? `<p class="text-gray-500">Bạn chưa trả lời câu này.</p>` : ''}
                <div class="bg-black/20 p-2.5 rounded text-gray-500 italic">
                    <strong>Giải thích:</strong> ${q.explanation}
                </div>
            </div>
        `;
    });
    
    document.getElementById('quiz-main-container').classList.add('hidden');
    document.getElementById('quiz-results-container').classList.remove('hidden');
    document.getElementById('quiz-score-badge').innerText = `Điểm số: ${score}/${quizQuestions.length} (${Math.round((score/quizQuestions.length)*100)}%)`;
}

// Reset Quiz
function resetQuiz() {
    document.getElementById('quiz-main-container').classList.remove('hidden');
    document.getElementById('quiz-results-container').classList.add('hidden');
    initQuiz();
}

// Copy Code Helper
window.copyToClipboard = function(elementId) {
    const text = document.getElementById(elementId).innerText;
    navigator.clipboard.writeText(text).then(() => {
        const btn = event.target.closest('button');
        const oldHtml = btn.innerHTML;
        btn.innerHTML = `<i class="fas fa-check text-green-500"></i> Copied!`;
        setTimeout(() => {
            btn.innerHTML = oldHtml;
        }, 1500);
    }).catch(err => {
        console.error('Error copying code: ', err);
    });
};

// Utilities
function escapeHtml(string) {
    const htmlEscapes = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#x27;',
        '/': '&#x2F;'
    };
    return string.replace(/[&<>"'/]/g, (match) => htmlEscapes[match]);
}
