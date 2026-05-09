

using Lesson_6_GameTracker_.Models;
using Microsoft.EntityFrameworkCore;

namespace Lesson_6_GameTracker_.Context
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<Game> Games { get; set; }
    }
}
