account = Account.create! email: "admin@example.com", password: "secret"
account.activate!

Teammate.create! name: "Admin", roles: ["tech_lead", "product_manager"], account_id: account.id
Teammate.create! name: "Tim", roles: ["product_manager"]
Teammate.create! name: "Steve", roles: ["tech_lead", "product_manager"]
Teammate.create! name: "Pat", roles: ["tech_lead"]
