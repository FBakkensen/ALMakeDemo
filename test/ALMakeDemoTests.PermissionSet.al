// Permission set for the ALMakeDemo test app

namespace DefaultPublisher.ALMakeDemo.Tests;

permissionset 50150 "ALMakeDemo Tests"
{
    Assignable = true;
    Caption = 'ALMakeDemo Tests', Locked = true;
    Permissions =
        codeunit "Contact FactBox Tests" = X;
}
