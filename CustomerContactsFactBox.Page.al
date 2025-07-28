// Customer Contacts FactBox - Shows contacts related to a customer
// Uses Contact Business Relation table to show customer-contact relationships

namespace DefaultPublisher.ALMakeDemo;

using Microsoft.CRM.BusinessRelation;
using Microsoft.CRM.Contact;

page 50101 "Customer Contacts FactBox"
{
    PageType = ListPart;
    SourceTable = "Contact Business Relation";
    Caption = 'Customer Contacts';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(ContactList)
            {
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    Caption = 'Contact No.';
                    ToolTip = 'Specifies the contact number';
                }
                field(ContactName; ContactName)
                {
                    ApplicationArea = All;
                    Caption = 'Contact Name';
                    ToolTip = 'Specifies the contact name';
                }
                field(ContactType; ContactType)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies whether the contact is a person or company';
                }
                field(ContactPhone; ContactPhone)
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the contact phone number';
                }
                field(ContactEmail; ContactEmail)
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Specifies the contact email address';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenContactCard)
            {
                ApplicationArea = All;
                Caption = 'Open Contact Card';
                ToolTip = 'Open the contact card for the selected contact';

                trigger OnAction()
                var
                    Contact: Record Contact;
                begin
                    if Contact.Get(Rec."Contact No.") then
                        Page.Run(Page::"Contact Card", Contact);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Contact: Record Contact;
    begin
        // Clear variables
        Clear(ContactName);
        Clear(ContactType);
        Clear(ContactPhone);
        Clear(ContactEmail);

        // Get contact information
        if Contact.Get(Rec."Contact No.") then begin
            ContactName := Contact.Name;
            ContactType := Contact.Type;
            ContactPhone := Contact."Phone No.";
            ContactEmail := Contact."E-Mail";
        end;
    end;

    var
        ContactName: Text;
        ContactType: Enum "Contact Type";
        ContactPhone: Text;
        ContactEmail: Text;
}