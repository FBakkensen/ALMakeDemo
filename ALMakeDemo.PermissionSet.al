// Permission set for ALMakeDemo extension
// Provides access to custom objects and required data

namespace DefaultPublisher.ALMakeDemo;

using Microsoft.CRM.Contact;
using Microsoft.CRM.BusinessRelation;

permissionset 50100 "ALMakeDemo"
{
    Caption = 'ALMakeDemo', Locked = true;
    Permissions = 
        page "Contact FactBox" = X,
        tabledata Contact = R,
        tabledata "Contact Business Relation" = R;
}