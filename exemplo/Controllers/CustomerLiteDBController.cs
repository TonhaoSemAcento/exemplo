using exemplo.Models;
using LiteDB;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace exemplo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomerLiteDBController : ControllerBase
    {
        private readonly ILogger<CustomerLiteDBController> _logger;
        private readonly string path;

        public CustomerLiteDBController(ILogger<CustomerLiteDBController> logger)
        {
            _logger = logger;
            path = Directory.GetCurrentDirectory()+ @"\MyData.db";
            Console.WriteLine(path);
        }

        [HttpGet(Name = "GetCustomerLiteDB")]
        public IEnumerable<Customer> Get()
        {
            using (var db = new LiteDatabase(path))
            {
                var col = db.GetCollection<Customer>("customers");

                var results = col.Query()
                    .ToList();
                Console.WriteLine(results);
                return results;
            }
        }

        [HttpPost(Name = "PostCustomerLiteDB")]
        public IEnumerable<Customer> Post(Customer customer)
        {
            using (var db = new LiteDatabase(path))
            {
                var col = db.GetCollection<Customer>("customers");

                col.Insert(customer);
                var results = col.Query()
                    .Where(x=>x.Name == customer.Name)
                    .ToList();
                return results;
            }
        }
    }
}
