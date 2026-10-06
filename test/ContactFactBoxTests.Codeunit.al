// Tests for the Contact FactBox shown on the Customer List

namespace DefaultPublisher.ALMakeDemo.Tests;

using DefaultPublisher.ALMakeDemo;
using Microsoft.CRM.BusinessRelation;
using Microsoft.CRM.Contact;
using System.TestLibraries.Utilities;

codeunit 50150 "Contact FactBox Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure FactBoxShowsDetailsOfLinkedContact()
    var
        ContactFactBox: TestPage "Contact FactBox";
    begin
        // [GIVEN] A person contact linked to customer C0001
        CreateContact('CT0001', 'Jane Doe', "Contact Type"::Person, '+47 12345678', 'jane@example.com');
        CreateBusinessRelation('CT0001', 'C0001');

        // [WHEN] The FactBox is opened for customer C0001
        ContactFactBox.OpenView();
        ContactFactBox.Filter.SetFilter("Link to Table", Format("Contact Business Relation Link To Table"::Customer));
        ContactFactBox.Filter.SetFilter("No.", 'C0001');
        ContactFactBox.First();

        // [THEN] The contact's details are shown
        LibraryAssert.AreEqual('CT0001', ContactFactBox."Contact No.".Value(), 'Contact No.');
        LibraryAssert.AreEqual('Jane Doe', ContactFactBox.ContactName.Value(), 'Contact Name');
        LibraryAssert.AreEqual(Format("Contact Type"::Person), ContactFactBox.ContactType.Value(), 'Type');
        LibraryAssert.AreEqual('+47 12345678', ContactFactBox.ContactPhone.Value(), 'Phone No.');
        LibraryAssert.AreEqual('jane@example.com', ContactFactBox.ContactEmail.Value(), 'E-Mail');
        ContactFactBox.Close();
    end;

    [Test]
    procedure FactBoxShowsBlankDetailsWhenContactIsMissing()
    var
        ContactFactBox: TestPage "Contact FactBox";
    begin
        // [GIVEN] A business relation pointing at a contact that does not exist
        CreateBusinessRelation('CT9999', 'C0002');

        // [WHEN] The FactBox is opened for customer C0002
        ContactFactBox.OpenView();
        ContactFactBox.Filter.SetFilter("No.", 'C0002');
        ContactFactBox.First();

        // [THEN] The contact fields are blank instead of failing
        LibraryAssert.AreEqual('CT9999', ContactFactBox."Contact No.".Value(), 'Contact No.');
        LibraryAssert.AreEqual('', ContactFactBox.ContactName.Value(), 'Contact Name');
        LibraryAssert.AreEqual('', ContactFactBox.ContactType.Value(), 'Type');
        LibraryAssert.AreEqual('', ContactFactBox.ContactPhone.Value(), 'Phone No.');
        LibraryAssert.AreEqual('', ContactFactBox.ContactEmail.Value(), 'E-Mail');
        ContactFactBox.Close();
    end;

    // Test fixtures assign fields directly: Validate() would run No. Series and
    // e-mail checks that need setup data the tests don't care about.
#pragma warning disable PC0037
    local procedure CreateContact(ContactNo: Code[20]; ContactName: Text[100]; ContactType: Enum "Contact Type"; PhoneNo: Text[30]; Email: Text[80])
    var
        Contact: Record Contact;
    begin
        Contact.Init();
        Contact."No." := ContactNo;
        Contact.Name := ContactName;
        Contact.Type := ContactType;
        Contact."Phone No." := PhoneNo;
        Contact."E-Mail" := Email;
        Contact.Insert(false);
    end;

    local procedure CreateBusinessRelation(ContactNo: Code[20]; CustomerNo: Code[20])
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        ContactBusinessRelation.Init();
        ContactBusinessRelation."Contact No." := ContactNo;
        ContactBusinessRelation."Business Relation Code" := 'CUST';
        ContactBusinessRelation."Link to Table" := ContactBusinessRelation."Link to Table"::Customer;
        ContactBusinessRelation."No." := CustomerNo;
        ContactBusinessRelation.Insert(false);
    end;
#pragma warning restore PC0037
}
