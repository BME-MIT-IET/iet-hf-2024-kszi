﻿using InForm.Server.Core.Features.Common;
using InForm.Server.Core.Features.Forms;
using InForm.Server.Features.Forms.Db;

namespace InForm.Server.Features.Forms;

internal class FromCreateDtoVisitor(Form parentForm) : 
    ITypedVisitor<CreateStringElement, StringFormElement>
{
    public StringFormElement Visit(CreateStringElement visited) =>
        new()
        {
            ParentForm = parentForm,
            Title = visited.Title,
            Subtitle = visited.Subtitle,
            RenderAsTextArea = visited.Multiline,
            Required = visited.Required,
            MaxLength = visited.MaxLength
        };
}
