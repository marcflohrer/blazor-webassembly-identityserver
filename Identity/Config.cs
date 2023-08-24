using Duende.IdentityServer.Models;
using System.Collections.Generic;

namespace Identity;

public class Config
{
    public static List<IdentityResource> GetIdentityResources() => new List<IdentityResource> {
                    new IdentityResources.OpenId(),
                    new IdentityResources.Profile(),
                    new IdentityResources.Email(),
                    new IdentityResources.Phone()
                };
}

