using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Internal;
using TweetBook.Domain;

namespace TweetBook.Data
{
    public class AppDbContext : IdentityDbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<RefreshToken> RefreshTokens { get; set; }

        public DbSet<Post> Posts { get; set; }

        public DbSet<Comment> Comments { get; set; }

        public dynamic GetDbSet(Type type)
        {            
            var dbSetType = typeof(DbSet<>).MakeGenericType(type);            

            foreach (var property in this.GetType().GetProperties())
            {
                if (property.PropertyType == dbSetType)
                    return property.GetValue(this);
            }

            throw new ArgumentException();
        }

        public object FindByPartialProperties(object entry, Type type)
        {            
            var dbSetType = typeof(DbSet<>).MakeGenericType(type);
            dynamic dbSet = new object();

            foreach (var property in this.GetType().GetProperties())
            {
                if (property.PropertyType == dbSetType)
                {
                    dbSet = property.GetValue(this);
                    break;
                }
            }
                        
                var toReturnType = typeof(List<>).MakeGenericType(type);
                var toReturn = Activator.CreateInstance(toReturnType);
                toReturn = dbSet;

                foreach (var property in type.GetProperties())
                {
                    var tempList = Activator.CreateInstance(toReturnType);

                    var entryValue = entry.GetType().GetProperty(property.Name).GetValue(entry);
                    if (entryValue != null)
                    {

                    }
                }
            


            throw new ArgumentException();
        }

        public object FindByInstanceDraft(dynamic instance, Type type)
        {
            var dbSetType = typeof(DbSet<>).MakeGenericType(type);
            var dbSet = this.GetType().GetProperties()[0].GetValue(this);

            foreach (var property in this.GetType().GetProperties())
            {
                if (property.PropertyType == dbSetType)
                {
                    dbSet = property.GetValue(this);
                    break;
                }
            }

            //var toReturnType = typeof(List<>).MakeGenericType(type);
            //var toReturn = Activator.CreateInstance(toReturnType);
            IEnumerable<dynamic> toReturn = dbSet as IEnumerable<dynamic>;

            foreach (var property in instance.GetType().GetProperties())
            {
                //var listFilteredBy = Activator.CreateInstance(toReturnType);

                var expectedValue = property.GetValue(instance);

                if (expectedValue != null && property.Name != "Id")
                {
                    var listFilteredByProperty = toReturn.Where(x => x.GetType().GetProperty(property.Name).GetValue(x) == expectedValue).ToList();
                    toReturn = toReturn.ToList().Intersect(listFilteredByProperty).ToList();
                }

                if (toReturn.ToList().Count == 0)
                    return toReturn;
            }

            return toReturn;            
        }

        public object FindByInstancePartial(dynamic instance, Type type)
        {            
            var dbSet = GetDbSet(type);
                        
            IEnumerable<dynamic> toReturn = dbSet as IEnumerable<dynamic>;

            foreach (var property in instance.GetType().GetProperties())
            {
                //var listFilteredBy = Activator.CreateInstance(toReturnType);

                var expectedValue = property.GetValue(instance);

                if (expectedValue != null)
                {
                    var listFilteredByProperty = toReturn.Where(x => x.GetType().GetProperty(property.Name).GetValue(x) == expectedValue).ToList();
                    toReturn = toReturn.ToList().Intersect(listFilteredByProperty).ToList();
                }

                if (toReturn.ToList().Count == 0) return toReturn;
            }

            return toReturn;
        }

        public List<dynamic> FindByProperties(Dictionary<string, dynamic> properties, Type type)
        {
            var dbSet = GetDbSet(type);            

            IEnumerable<dynamic> toReturn = dbSet as IEnumerable<dynamic>;

            foreach (var property in properties.Keys)
            {
                var expectedValue = properties[property];

                var listFilteredByProperty = toReturn.Where(x => x.GetType().GetProperty(property).GetValue(x) == expectedValue).ToList();                
                toReturn = toReturn.ToList().Intersect(listFilteredByProperty).ToList();
                
                if (toReturn.ToList().Count == 0) return toReturn.ToList();
            }

            return toReturn.ToList();
        }

        public bool InsertInstanceSet(List<dynamic> instanceList, Type type)
        {
            var dbSet = GetDbSet(type);

            dbSet.AddRange(instanceList);
            this.SaveChanges();

            return true;
        }

        public async Task InsertInstanceSet(List<Dictionary<string, dynamic>> instanceList, Type type)
        {
            var dbSet = GetDbSet(type);

            foreach(var instance in instanceList)
            {
                dynamic recordToInsert = Activator.CreateInstance(type);

                foreach (var property in instance.Keys)
                {
                    recordToInsert.GetType().GetProperty(property).SetValue(recordToInsert, instance[property]);
                }

                await dbSet.AddAsync(recordToInsert);
            }            
            await this.SaveChangesAsync();
        }
    }
}
