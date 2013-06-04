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
                 color: "dark-green",
                 team: team
Teammate.create! name: "Pat",
                 initials: "PW",
                 roles: ["tech_lead", "teammate"],
                 color: "pink",
                 team: team
Teammate.create! name: "Steve",
                 initials: "SF",
                 roles: ["tech_lead", "teammate", "product_manager"],
                 color: "black",
                 team: team
Teammate.create! name: "Krys",
                 initials: "KT",
                 roles: ["teammate", "product_manager"],
                 color: "orange",
                 team: team
Teammate.create! name: "Tim",
                 initials: "TS",
                 roles: ["teammate", "product_manager"],
                 color: "baby-blue",
                 team: team
Teammate.create! name: "Taurus",
                 initials: "TC",
                 roles: ["teammate", "tech_lead"],
                 color: "salmon",
                 team: team
Teammate.create! name: "Craig",
                 initials: "CM",
                 roles: ["teammate", "tech_lead"],
                 color: "yellow",
                 team: team
Teammate.create! name: "Mathieu",
                 initials: "ML",
                 roles: ["teammate", "tech_lead"],
                 color: "purple",
                 team: team
Teammate.create! name: "Anand",
                 initials: "AH",
                 roles: ["teammate", "product_manager"],
                 color: "old-pink",
                 team: team
Teammate.create! name: "Denise",
                 initials: "DG",
                 roles: ["teammate"],
                 color: "dark-purple",
                 team: team
Teammate.create! name: "Kate",
                 initials: "KB",
                 roles: ["teammate"],
                 color: "dark-beige",
                 team: team
Teammate.create! name: "Andy",
                 initials: "AC",
                 roles: ["product_manager"],
                 color: "dark-blue",
                 team: team
Teammate.create! name: "Ben",
                 initials: "BC",
                 roles: ["product_manager", "teammate"],
                 color: "light-green",
                 team: team
