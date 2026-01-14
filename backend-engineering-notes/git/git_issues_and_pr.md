# 🔥 How to Write GitHub Issues & PRs (Industry Standard)

Think of:

* **Issue = WHAT + WHY**
* **PR = HOW + PROOF**

---

## 🐞 1️⃣ Writing a GitHub ISSUE (Correct Way)

### ✅ Issue Structure (STANDARD)

```text
Title:
Description:
Steps to Reproduce:
Expected Behavior:
Actual Behavior:
Logs / Screenshots:
Environment:
```

---

### 📝 Example — Bug Issue

**Title**

```
Login API returns 500 for valid user
```

**Description**

```
Login API fails with 500 when valid credentials are provided.
This blocks user authentication.
```

**Steps to Reproduce**

```
1. POST /api/login
2. Send valid email & password
3. Observe response
```

**Expected Behavior**

```
200 OK with JWT token
```

**Actual Behavior**

```
500 Internal Server Error
```

**Logs**

```text
TypeError: cannot read property 'id' of undefined
```

**Environment**

```
Node v18
MongoDB 6
Production
```

---

## ✨ 2️⃣ Feature Request ISSUE

```text
Title: Add password reset functionality

Description:
Users should be able to reset their password via email OTP.

Acceptance Criteria:
- User receives OTP
- OTP expires in 5 mins
- Password updated securely
```

---

## 🔥 3️⃣ Writing a Pull Request (PR) — MOST IMPORTANT

### ✅ PR STRUCTURE (INDUSTRY TEMPLATE)

```text
Title
Description
Changes Made
How to Test
Screenshots / Logs
Related Issues
```

---

### 📝 Example — Feature PR

**Title**

```
feat: add JWT-based authentication
```

**Description**

```
Implements JWT authentication for login and protected routes.
```

**Changes Made**

```
- Added login API
- Implemented JWT middleware
- Added password hashing
```

**How to Test**

```
1. POST /login with valid credentials
2. Use token to access /profile
3. Verify 401 for invalid token
```

**Screenshots / Logs**

```
N/A (API change)
```

**Related Issues**

```
Closes #12
```

🔥 **This will auto-closes issue when merged**

---

## 4️⃣ PR Size Rules (VERY IMPORTANT)

❌ Bad PR:

* 30 files
* Multiple features
* No description

✅ Good PR:

* Single responsibility
* < 500 lines
* Easy to review

---

## 5️⃣ Commit Message Style (CONNECTS ISSUE + PR)

### Conventional Commits (RECOMMENDED)

```text
feat: add login api
fix: handle null user in auth
refactor: clean middleware logic
```

---

## 6️⃣ Linking Issue ↔ PR (INTERVIEW GOLD)

```text
Closes #15
Fixes #20
Resolves #8
```

Why?

* Auto tracking
* Clean history

---

## 7️⃣ Review Checklist (Senior Signal 🚀)

Add in PR:

```text
- [ ] Code follows style guide
- [ ] Tests added
- [ ] No breaking changes
- [ ] Backward compatible
```

---

## 8️⃣ Labels & Assignees (REAL TEAMS)

Labels:

* bug
* enhancement
* urgent
* tech-debt

Assignee:

* Developer responsible

---

## 9️⃣ GitHub ISSUE vs PR 

| Issue      | PR             |
| ---------- | -------------- |
| Problem    | Solution       |
| Discussion | Code           |
| Planning   | Implementation |

---
