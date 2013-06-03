team = Team.create! name: "Testing"

account = Account.create! email: "admin@example.com", password: "secret", team_id: team.id
account.activate!

Story.create! description: "As Ryan, I can compensate caring advisors properly on thursday morning, because we have migrated contact owners to follow the new rules",
              points: 3,
              team: team
Story.create! description: "LAUNCH: benchmark tour complete lead status, hosted unsub page and back end, email-only leads funx, SEM form, qualification required flag, mediawhiz pixel, prefill zip code",
              points: 5,
              team: team
Story.create! description: "Babysit new provider integrations: seniorstar, legend, fivestar dupes, benchmark tours complete",
              points: 2,
              team: team
Story.create! description: "ROLLOVER: As a user who has previously been call centered, I get call centered again when I submit a new inquiry, because we've implemented a call request model.",
              points: 8,
              team: team
Story.create! description: "As a CSR, I get inbound calls via five9",
              points: 1,
              team: team
Story.create! description: "SPEC: Rev in Advisor Tool to support one-page operation and tracking/viewing more interactions",
              points: 0,
              team: team
Story.create! description: "SPEC: As a CSR setting a valid status, I am required to enter a message.",
              points: 0,
              team: team

Teammate.create! name: "Admin",
                 initials: "ADM",
                 roles: ["admin"],
                 color: "red",
                 account: account,
                 team: team
Teammate.create! name: "Chris",
                 initials: "CE",
                 roles: ["tech_lead", "teammate"],
                 color: "#334a14",
                 team: team
Teammate.create! name: "Pat",
                 initials: "PW",
                 roles: ["tech_lead", "teammate"],
                 color: "#efa4ce",
                 team: team
Teammate.create! name: "Steve",
                 initials: "SF",
                 roles: ["tech_lead", "teammate", "product_manager"],
                 color: "black",
                 team: team
Teammate.create! name: "Krys",
                 initials: "KT",
                 roles: ["teammate", "product_manager"],
                 color: "#f29c33",
                 team: team
Teammate.create! name: "Tim",
                 initials: "TS",
                 roles: ["teammate", "product_manager"],
                 color: "#508de5",
                 team: team
Teammate.create! name: "Taurus",
                 initials: "TC",
                 roles: ["teammate", "tech_lead"],
                 color: "#f8cc9e",
                 team: team
Teammate.create! name: "Craig",
                 initials: "CM",
                 roles: ["teammate", "tech_lead"],
                 color: "#fff733",
                 team: team
Teammate.create! name: "Mathieu",
                 initials: "ML",
                 roles: ["teammate", "tech_lead"],
                 color: "#b0abd5",
                 team: team
Teammate.create! name: "Anand",
                 initials: "AH",
                 roles: ["teammate", "product_manager"],
                 color: "#b782a1",
                 team: team
Teammate.create! name: "Denise",
                 initials: "DG",
                 roles: ["teammate"],
                 color: "#722c80",
                 team: team
Teammate.create! name: "Kate",
                 initials: "KB",
                 roles: ["teammate"],
                 color: "#aea54b",
                 team: team
Teammate.create! name: "Andy",
                 initials: "AC",
                 roles: ["product_manager"],
                 color: "#093764",
                 team: team
Teammate.create! name: "Ben",
                 initials: "BB",
                 roles: ["product_manager"],
                 color: "#80f200",
                 team: team
