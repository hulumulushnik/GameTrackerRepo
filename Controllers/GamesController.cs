using Lesson_6_GameTracker_.Context;
using Lesson_6_GameTracker_.Models;
using Microsoft.AspNetCore.Mvc;

namespace Lesson_6_GameTracker_.Controllers
{
    public class GamesController : Controller
    {
        private readonly AppDbContext _context;
        public GamesController(AppDbContext context)
        {
            _context = context;
        }
        public IActionResult Index()
        {
            var status = Environment.GetEnvironmentVariable("Api__Status");
            var token = Environment.GetEnvironmentVariable("Token");
            ViewBag.ApiKey = Environment.GetEnvironmentVariable("PAYMENT__APIKEY");
            ViewBag.ApiStatus = status;
            ViewBag.Token = token;

            var games = _context.Games.ToList();
            return View(games);
        }
        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Create(Game game)
        {
            if (game != null && !string.IsNullOrEmpty(game.Title))
            {
                _context.Games.Add(game);
                _context.SaveChanges();
                return RedirectToAction(nameof(Index));
            }
            return View(game);
        }
    }
}
