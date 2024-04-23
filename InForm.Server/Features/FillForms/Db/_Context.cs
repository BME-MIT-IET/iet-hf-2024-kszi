using InForm.Server.Features.FillForms.Db;
using Microsoft.EntityFrameworkCore;

namespace InForm.Server.Db;

public partial class InFormDbContext {
    [ModelConfiguration]
    private static void ConfigureFormFills(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<FillData>()
                    .UseTpcMappingStrategy();
        modelBuilder.Entity<MultiChoiceFillData>()
                    .HasMany(x => x.Selected)
                    .WithOne(x => x.FillData)
                    .OnDelete(DeleteBehavior.Cascade);
        modelBuilder.Entity<MultiChoiceFillSelection>()
                    .HasOne(x => x.Option)
                    .WithMany();
    }

#nullable disable
    /// <summary>
    ///     The db set for bare fill data entities.
    /// </summary>
    public DbSet<FillData> FillData { get; set; }

    /// <summary>
    ///     The db set for the string fill data entities.
    /// </summary>
    public DbSet<StringFillData> StringFillData { get; set; }

    /// <summary>
    ///     The db set for the multi choice data entities.
    /// </summary>
    public DbSet<MultiChoiceFillData> MultiChoiceFillDatas { get; set; }

    /// <summary>
    ///     The db set for the multi choice fill selection entities.
    /// </summary>
    public DbSet<MultiChoiceFillSelection> MultiChoiceFillSelections { get; set; }
}
