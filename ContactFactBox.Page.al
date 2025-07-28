// Contact FactBox for Customer List
// Shows contacts associated with the selected customer via Contact Business Relation

namespace DefaultPublisher.ALMakeDemo;

using Microsoft.CRM.Contact;
using Microsoft.CRM.BusinessRelation;

page 50101 "Contact FactBox"
{
    Caption = 'Contacts';
    PageType = ListPart;
    SourceTable = "Contact Business Relation";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact number.';
                }
                field(ContactName; GetContactName())
                {
                    ApplicationArea = All;
                    Caption = 'Contact Name';
                    ToolTip = 'Specifies the contact name.';
                }
                field(ContactType; GetContactType())
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the contact type (Company or Person).';
                }
                field(ContactPhone; GetContactPhone())
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the contact phone number.';
                }
                field(ContactEmail; GetContactEmail())
                {
                    ApplicationArea = All;
                    Caption = 'E-Mail';
                    ToolTip = 'Specifies the contact email address.';
                }
            }
        }
    }

    local procedure GetContactName(): Text[100]
    var
        Contact: Record Contact;
    begin
        if Contact.Get(Rec."Contact No.") then
            exit(Contact.Name);
        exit('');
    end;

    local procedure GetContactType(): Text[30]
    var
        Contact: Record Contact;
    begin
        if Contact.Get(Rec."Contact No.") then
            exit(Format(Contact.Type));
        exit('');
    end;

    local procedure GetContactPhone(): Text[30]
    var
        Contact: Record Contact;
    begin
        if Contact.Get(Rec."Contact No.") then
            exit(Contact."Phone No.");
        exit('');
    end;

    local procedure GetContactEmail(): Text[80]
    var
        Contact: Record Contact;
    begin
        if Contact.Get(Rec."Contact No.") then
            exit(Contact."E-Mail");
        exit('');
    end;
}