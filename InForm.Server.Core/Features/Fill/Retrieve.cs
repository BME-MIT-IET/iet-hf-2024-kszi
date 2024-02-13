﻿using InForm.Server.Core.Features.Common;
using System.Text.Json.Serialization;

namespace InForm.Server.Core.Features.Fill;

/// <summary>
///     The request object for querying the answers of a form
/// </summary>
/// <param name="Password">Optional password</param>
public readonly record struct RetrieveFillsRequest(
    Guid Id,
    string? Password
);

/// <summary>
///     Response containing the answers given to a given form.
/// </summary>
/// <param name="Title">The title of the form.</param>
/// <param name="Subtitle">The subtitle of the form</param>
/// <param name="Responses">The list of polymorphic result objects.</param>
public readonly record struct RetrieveFillsResponse(
    string Title,
    string? Subtitle,
    List<ElementResponse> Responses
);

/// <summary>
///     Base class of element specific answers
/// </summary>
/// <param name="Id">The identifier of the form element this response is for.</param>
[JsonPolymorphic(TypeDiscriminatorPropertyName = "$t")]
[JsonDerivedType(typeof(StringElementResponse), "string")]
public abstract record ElementResponse(
    long Id,
    string Title,
    string? Subtitle
) : IVisitable
{
    /// <inheritdoc/>
    public abstract void Accept(IVisitor visitor);

    /// <inheritdoc/>
    public abstract TResult? Accept<TResult>(IVisitor<TResult> visitor) where TResult : notnull;
}

/// <summary>
///     The response element for string fill elements.
/// </summary>
/// <param name="Id">The identifier of the string form element.</param>
/// <param name="Responses">The list of answers and their cardinality.</param>
public record StringElementResponse(
    long Id,
    string Title,
    string? Subtitle,
    Dictionary<string, int> Responses
) : ElementResponse(Id, Title, Subtitle)
{
    /// <inheritdoc/>
    public override void Accept(IVisitor visitor)
    {
        if (visitor is not ITypedVisitor<StringElementResponse> typed) return;
        typed.Visit(this);
    }

    /// <inheritdoc/>
    public override TResult? Accept<TResult>(IVisitor<TResult> visitor) where TResult : default
    {
        if (visitor is not ITypedVisitor<StringElementResponse, TResult> typed) return default;
        return typed.Visit(this);
    }
}
