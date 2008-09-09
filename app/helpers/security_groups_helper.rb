module SecurityGroupsHelper
  def format_permissions(permissions)
    permissions.map do |permission|
      if permission.has_key?(:group)
        "Group: #{permission[:group]}, Owner: #{permission[:owner]}<br />"
      else
        "Protocol: #{permission[:protocol]}, CIDR IP: #{permission[:cidr_ips]}, From Port: #{permission[:from_port]}, To Port: #{permission[:to_port]}<br />"
      end
    end.join("")
  end
end
