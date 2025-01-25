-- Define network variables
HOME_NET = '192.168.190.128'
EXTERNAL_NET = '!$HOME_NET'

include 'snort_defaults.lua'
-- IPS configuration
ips = 
{
    rules = [[
        include /usr/local/etc/rules/local.rules
    ]],
    variables =
    {
        nets =
        {
            EXTERNAL_NET = EXTERNAL_NET,
            HOME_NET = HOME_NET
        },
        ports =
        {
        HTTP_PORTS = HTTP_PORTS
       }
    }
}

-- Enable logging
alert_json = 
{
    file = true,
    fields = 'timestamp  proto  src_addr msg rule action priority',
    limit = 10
}
