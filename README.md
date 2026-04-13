# UAH-IS-Project-2

## Database requirements

1. An **analyst** may report or respond to **one or many incidents**, depending on the number of security events they are assigned to handle. Each **incident**, however, must be associated with **one and only one** analyst who takes primary responsibility for its initial response.
2. An **incident** may trigger **one or many alerts**, as multiple detection tools may flag different signals for the same security event. Each **alert** must be associated with **one and only one incident** to ensure proper traceability.
3. An **incident** may involve **one or many actions** taken as part of the response process, such as isolating a device, notifying users, or patching vulnerabilities. Each **action** must be linked to **exactly one incident**.
4. An **analyst** may perform **multiple actions** as part of responding to various incidents. Each **action** must be carried out by **one and only one analyst**.
5. A **threat indicator** (such as an IP address, domain, or file hash) may appear in **multiple incidents**, and an **incident** may contain **multiple threat indicators**. This many-to-many relationship allows share intelligence across cases.
6. Each **severity level** defined in the SLA policy (e.g., Critical, High, Medium, Low) must have a corresponding **response time limit** expressed in hours. These SLA rules are stored separately and must be applied when computing deadlines for incident response

