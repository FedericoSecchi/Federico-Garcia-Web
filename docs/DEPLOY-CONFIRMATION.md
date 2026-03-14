# GitHub Pages deploy confirmation – fedegarcia.com

**Repo:** FedericoSecchi/Federico-Garcia-Web  
**Remote:** git@github.com:FedericoSecchi/Federico-Garcia-Web.git  
**Branch:** main  
**Latest push:** 3df5326 (Merge origin/main: keep SEO canonical and meta)

---

## Confirm in GitHub

1. **Settings → Pages**
   - **Source:** Deploy from a branch
   - **Branch:** `main` / **(root)**
   - **Custom domain:** `www.fedegarcia.com`
   - **Enforce HTTPS:** On (after DNS propagates)

2. **DNS (at your registrar)**
   - For `www`: CNAME record → `FedericoSecchi.github.io` (or the host shown in Pages settings)
   - For apex `fedegarcia.com`: use GitHub’s recommended A records if you want the root domain to work

3. **Branch protection (optional)**
   - If you need to force-push in the future, temporarily allow force pushes for `main` in Settings → Branches, then re-enable protection after the push.

---

## Post-push checks

- [x] origin/main updated (3df5326)
- [x] index.html present on main
- [x] CNAME = www.fedegarcia.com
- [x] robots.txt, sitemap.xml, index.html in repo root
