team = Team.create! name: "Testing"

account = Account.create! email: "admin@example.com", password: "secret", team_id: team.id
account.activate!

Teammate.create! name: "Admin", roles: ["tech_lead", "product_manager"], account_id: account.id, team_id: team.id
Teammate.create! name: "Tim", roles: ["product_manager"], team_id: team.id
Teammate.create! name: "Steve", roles: ["tech_lead", "product_manager"], team_id: team.id
Teammate.create! name: "Pat", roles: ["tech_lead"], team_id: team.id
