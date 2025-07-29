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

    var
        Contact: Record Contact;
        ContactLoaded: Boolean;

    trigger OnAfterGetRecord()
    begin
        LoadContact();
    end;

    local procedure LoadContact()
    begin
        ContactLoaded := Contact.Get(Rec."Contact No.");
    end;

    local procedure GetContactName(): Text[100]
    begin
        if ContactLoaded then
            exit(Contact.Name);
        exit('');
    end;

    local procedure GetContactType(): Text[30]
    begin
        if ContactLoaded then
            exit(Format(Contact.Type));
        exit('');
    end;

    local procedure GetContactPhone(): Text[30]
    begin
        if ContactLoaded then
            exit(Contact."Phone No.");
        exit('');
    end;

    local procedure GetContactEmail(): Text[80]
    begin
        if ContactLoaded then
            exit(Contact."E-Mail");
        exit('');
    end;
}