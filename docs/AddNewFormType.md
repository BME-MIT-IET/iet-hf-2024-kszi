# Add a new form element

Adding a form element type is a meticulous process, and requires adding appropriate types in many places, including multiple DTO-s, the client side model and the Db entity.

This document lists all the things that need to be performed to successfully add a new element type.
This list adds the classes in the order of dependencies, with the most dependent at the start.

## InForm.Server.Core

This project contains the DTO-s.
Since both the server and client depend on this, this is the first step.
Since all actions have their own DTO-s, there is considerable duplication here.

### Create DTO

The DTO-s for the endpoint for creating forms.
The new element's DTO needs to inherit from `CreateFormElement`, and implement the `IVisitable` methods.
Also, the derived type needs to be registered for the JSON serializer, so add the required attribute to `CreateFormElement`.
The discriminator value is irrelevant, just make it unique.

This DTO does not contain any fill related values.

### Get DTO

The DTO-s for the endpoint for requesting and rendering forms.
The new element's DTO inherits from `GetFormElement`, and implements `IVisitable`.
Similarly, for JSON serialization, add the required attribute to `GetFormElement` with an arbitrary but unique discriminator.
It is advised to make it the same as the one chosen previously.

This DTO does not contain any fill related values.

### Fill DTO

The DTO-s for the endpoint for filling in forms.
The new element's *fill data's* DTO needs to inherit from `FillElement`, also implementing `IVisitable`.
Yet again, for JSON serialization, add the required attribute to `FillElement` with an arbitrary but unique discriminator.
It is advised to make it the same as the ones chosen previously.

Take heed that this DTO contains the data expected to be provided by the user filling in the form.
Make sure to allow the genericity you plan to allow with the form element.

## InForm.Client

The client library wrapping the raw HTTP calls to communicate with the server.
Also contains the client side model of the application.

### ElementModel & its validator

Create a new descendant from `ElementModel`, implement the required methods.
This model should hold all the data representing a given entity of the new form element.
This is basically the metadata provided during form creation.
Call this type with a suffix of `Model` to allow understanding its purpose.

Create a new type to hold the data the filling user needs to input.
Call this type with a suffix of `FillData` (without the `Model` suffix).
Add a nullable property to the model class with this field, called `FillData` by convention.

Add validator classes using FluentValidation. 
The model's validator should enforce the correctness of the metadata as provided by the form creator, while the fill data's validator should enforce the fill data conforms to the requirements of the model.
For this the model is a dependency of the fill data validator, see `StringElementModel` and co. for an example how to do this.

### De/Marshalling visitors

Take a look at the visitors in `InForm.Client.Features.Forms.Contracts.Impl`.
These perform the marshalling of the client model entities into DTO-s.

Add to all of these visitors the mappings between the newly created models and the DTOs:
first add the interfaces to the visitor `ITypedVisitor<From, To>` with the new types.
In the `From*DtoVisitor` classes the `From` is the DTO and `To` is the model, these are the demarshalling visitors.
In the `To*DtoVisitor` classes the `From` is the model and `To` is the DTO, these are the marshalling visitors.

Implement the now missing methods.

## InForm.Server

### Element Db type

Add an element form entity type as a descendant of `FormElementBase`, in the Forms\\Db directory.
This should store all the metadata of a form element in the Db for later retrieval.
Add this type to the DbContext partial class' part in the `_Context.cs` file.
Also modify the `LoadAllElementsForForm()` method to also load your new element types.

There should be a `FillData` property as a list of the respective fill data entities created in the following section.

### FillData Db type

Add a fill data entity type as a descendant of `FillData`, in the FillForms\\Db directory.
This should store the responses generated by the filling users.
Add this type to the DbContext partial class's part int the respective directory's `_Context.cs` file.

### De/Marshalling visitors

Add the conversions as required to/from the Db entities to the DTO classes.
The semantics are the same as with the `InForm.Client` project, but now on the server side.

## InForm.Web

### CreateForm feature

Add a razor file in the `CreateForms\\Elements` folder for the newly created element.
It should inherit from `InputBase<NewElementModel>`.
Implement the metadata input used for form creation however you like.
The `TryParseValueFromString` can just throw NIE, it is not used by caller code.

Add the new element's rendering dispatch to `ElementEditor.razor`'s big switch.[^1]

### FillForm feature

Add a razor file in the `FillForms\\Elements` directory.
It should inherit from `InputBase<NewElementFillData>` (note this is the fill data type, **not** the model type.)
Implement the UI.
The `TryParseValueFromString` can just throw NIE, it is not used by caller code.

Add the new element's rendering dispatch to `FillEditor.razor`'s big switch.[^1]



[1]: As of now, this cannot be easily gotten around, so this is the best we can do.
