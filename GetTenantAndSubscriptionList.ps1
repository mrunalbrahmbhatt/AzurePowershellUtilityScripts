#Purpose : Gets the Tenant and Subscription list in single table.
#User has to be Global Admin, Owner otherwise they will only get the list which are accessible to them and may not get full list.

#Connect-AzAccount

$tenants = Get-AzTenant 
$subscriptions = Get-AzSubscription | Sort-Object -Property TenantId 

#$tenants | Format-Table -AutoSize
#$subscriptions | Format-Table -AutoSize

#Empty list array.
$list = @()

#Combining tenant and subscription details.
foreach ($t in $tenants)
{
    foreach ($s in $subscriptions)
    {
        # decide whether to join
        if ($t.Id -eq $s.TenantId)
        {
                #Subscriptions attached with the Tenancy.
                $list += New-Object PSObject -Property @{
                TenandId = $t.Id;
                TenantName  = $t.Name;
                TenantCategory  = $t.Category;
                TenantDomains  = $t.Domains;
                SubId = $s.Id;
                SubName = $s.Name;
                SubState = $s.State;
            };
        }
        else
        {
            #No Subscriptions attached.
            $list += New-Object PSObject -Property @{
                TenandId = $t.Id;
                TenantName  = $t.Name;
                TenantCategory  = $t.Category;
                TenantDomains  = $t.Domains;
                SubId = '---';
                SubName = '---';
                SubState = '---';
                };
                break;
        }
    }
    #Adding new line.
    $list += New-Object PSObject -Property @{TenandId = '';};
}

#Print Tenant and Subscription in single line.
$list | Select-Object -Property TenandId,TenantName,TenantDomains,SubId,SubName,SubState | Format-Table -Wrap -AutoSize
