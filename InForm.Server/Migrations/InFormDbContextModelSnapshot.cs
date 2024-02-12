﻿// <auto-generated />
using System;
using InForm.Server.Db;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace InForm.Server.Migrations
{
    [DbContext(typeof(InFormDbContext))]
    partial class InFormDbContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasDefaultSchema("InForm")
                .HasAnnotation("ProductVersion", "8.0.1")
                .HasAnnotation("Relational:MaxIdentifierLength", 63);

            NpgsqlModelBuilderExtensions.UseIdentityByDefaultColumns(modelBuilder);

            modelBuilder.HasSequence("FillDataSequence");

            modelBuilder.Entity("InForm.Server.Features.FillForms.Db.Fill", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<long>("Id"));

                    b.HasKey("Id");

                    b.ToTable("Fill", "InForm");
                });

            modelBuilder.Entity("InForm.Server.Features.FillForms.Db.FillData", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint")
                        .HasDefaultValueSql("nextval('\"InForm\".\"FillDataSequence\"')");

                    NpgsqlPropertyBuilderExtensions.UseSequence(b.Property<long>("Id"));

                    b.Property<long>("FillId")
                        .HasColumnType("bigint");

                    b.HasKey("Id");

                    b.HasIndex("FillId");

                    b.ToTable((string)null);

                    b.UseTpcMappingStrategy();
                });

            modelBuilder.Entity("InForm.Server.Features.Forms.Db.Form", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<long>("Id"));

                    b.Property<Guid>("IdGuid")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("uuid");

                    b.Property<string>("PasswordHash")
                        .HasMaxLength(120)
                        .HasColumnType("character varying(120)");

                    b.Property<string>("Subtitle")
                        .HasMaxLength(128)
                        .HasColumnType("character varying(128)");

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasMaxLength(64)
                        .HasColumnType("character varying(64)");

                    b.HasKey("Id");

                    b.ToTable("Forms", "InForm");
                });

            modelBuilder.Entity("InForm.Server.Features.Forms.Db.FormElementBase", b =>
                {
                    b.Property<long>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("bigint");

                    NpgsqlPropertyBuilderExtensions.UseIdentityByDefaultColumn(b.Property<long>("Id"));

                    b.Property<string>("Discriminator")
                        .IsRequired()
                        .HasMaxLength(21)
                        .HasColumnType("character varying(21)");

                    b.Property<long>("ParentFormId")
                        .HasColumnType("bigint");

                    b.Property<bool>("Required")
                        .HasColumnType("boolean");

                    b.Property<string>("Subtitle")
                        .HasMaxLength(256)
                        .HasColumnType("character varying(256)");

                    b.Property<string>("Title")
                        .IsRequired()
                        .HasMaxLength(128)
                        .HasColumnType("character varying(128)");

                    b.HasKey("Id");

                    b.HasIndex("ParentFormId");

                    b.ToTable("FormElementBases", "InForm");

                    b.HasDiscriminator<string>("Discriminator").HasValue("FormElementBase");

                    b.UseTphMappingStrategy();
                });

            modelBuilder.Entity("InForm.Server.Features.FillForms.Db.StringFillData", b =>
                {
                    b.HasBaseType("InForm.Server.Features.FillForms.Db.FillData");

                    b.Property<long?>("ParentElementId")
                        .HasColumnType("bigint");

                    b.Property<string>("Value")
                        .HasColumnType("text");

                    b.HasIndex("ParentElementId");

                    b.ToTable("StringFillData", "InForm");
                });

            modelBuilder.Entity("InForm.Server.Features.Forms.Db.StringFormElement", b =>
                {
                    b.HasBaseType("InForm.Server.Features.Forms.Db.FormElementBase");

                    b.Property<int?>("MaxLength")
                        .HasColumnType("integer");

                    b.Property<bool>("RenderAsTextArea")
                        .HasColumnType("boolean");

                    b.HasDiscriminator().HasValue("StringFormElement");
                });

            modelBuilder.Entity("InForm.Server.Features.FillForms.Db.FillData", b =>
                {
                    b.HasOne("InForm.Server.Features.FillForms.Db.Fill", "Fill")
                        .WithMany()
                        .HasForeignKey("FillId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Fill");
                });

            modelBuilder.Entity("InForm.Server.Features.Forms.Db.FormElementBase", b =>
                {
                    b.HasOne("InForm.Server.Features.Forms.Db.Form", "ParentForm")
                        .WithMany("FormElementBases")
                        .HasForeignKey("ParentFormId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("ParentForm");
                });

            modelBuilder.Entity("InForm.Server.Features.FillForms.Db.StringFillData", b =>
                {
                    b.HasOne("InForm.Server.Features.Forms.Db.StringFormElement", "ParentElement")
                        .WithMany("FillData")
                        .HasForeignKey("ParentElementId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.Navigation("ParentElement");
                });

            modelBuilder.Entity("InForm.Server.Features.Forms.Db.Form", b =>
                {
                    b.Navigation("FormElementBases");
                });

            modelBuilder.Entity("InForm.Server.Features.Forms.Db.StringFormElement", b =>
                {
                    b.Navigation("FillData");
                });
#pragma warning restore 612, 618
        }
    }
}
