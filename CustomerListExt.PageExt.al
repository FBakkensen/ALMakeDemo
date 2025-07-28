// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

namespace DefaultPublisher.ALMakeDemo;

using Microsoft.Sales.Customer;

pageextension 50100 CustomerListExt extends "Customer List"
{
    layout
    {
        addlast(content)
        {
            field(BalanceDue; Rec."Balance Due")
            {
                ApplicationArea = All;
                Caption = 'Balance Due';
                ToolTip = 'Shows the outstanding balance amount for the customer';
            }
        }
        
        addfirst(factboxes)
        {
            part(CustomerContacts; "Customer Contacts FactBox")
            {
                ApplicationArea = All;
                Caption = 'Customer Contacts';
                SubPageLink = "No." = field("No.");
                SubPageView = where("Link to Table" = const(Customer));
            }
        }
    }

    trigger OnOpenPage();
    begin
        Message('App published: Hello world');
    end;
}
