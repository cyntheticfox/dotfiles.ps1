#Requires -Version '5.1'

function git_main_branch() {
  [OutputType([String])]
  param()

  git rev-parse --git-dir *>$null

  if (!$?) {
    return $null
  }

  [String[]]$refs = @(
    'refs/heads/main',
    'refs/heads/trunk',
    'refs/remotes/origin/main',
    'refs/remotes/origin/trunk',
    'refs/remotes/upstream/main',
    'refs/remotes/upstream/trunk'
  )

  $null = $refs.ForEach({
      $null = git show-ref -q --verify $_

      if ($?) {
        return (Split-Path $_ -Leaf)
      }
    })

  return 'master'
}

function git_develop_branch() {
  [OutputType([String])]
  param()

  git rev-parse --git-dir *>$null

  if (!$?) {
    return $null
  }

  [String[]]$refs = @(
    'refs/heads/dev',
    'refs/heads/devel',
    'refs/heads/development'
  )

  $null = $refs.ForEach({
      $null = git show-ref -q --verify $_

      if ($?) {
        return $branch
      }
    })

  return 'develop'
}

function git_current_branch() {
  [OutputType([String])]
  param()

  [String]$ref = git symbolic-ref --quiet HEAD 2>$null

  if (!$?) {
    [String]$ref = git rev-parse --short HEAD 2>$null

    if (!$?) {
      return $null
    }
  }

  return $ref.Replace('refs/heads/', '')
}

$null = Get-Alias 'g' -ErrorAction SilentlyContinue

if (-not $?) {
  New-Alias 'g' 'git'
}

function ga() {
  git add @args
}

function gaa() {
  git add --all @args
}

function gapa() {
  git add --patch @args
}

function gau() {
  git add --update @args
}

function gav() {
  git add --verbose @args
}

function gap() {
  git apply @args
}

function gapt() {
  git apply --3way @args
}

function gb() {
  git branch @args
}

function gba() {
  git branch --all @args
}

function gbd() {
  git branch -d @args
}

function gbda() {
  [String[]]$branches = git branch --no-color --merged

  $branches.Where({ $_ -notmatch "^[+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$" }).ForEach({ $_.Trim() }).Where({ $_ -ne '' })
}

function gbD() {
  git branch -D @args
}

function gbnm() {
  git branch --no-merged @args
}

function gbr() {
  git branch --remote @args
}

function gbs() {
  git bisect @args
}

function gbsb() {
  git bisect bad @args
}

function gbsg() {
  git bisect good @args
}

function gbsr() {
  git bisect reset @args
}

function gbss() {
  git bisect start @args
}

function gc() {
  git commit --verbose @args
}

function gc!() {
  git commit --verbose --amend @args
}

function gca() {
  git commit --verbose --all @args
}

function gca!() {
  git commit --verbose --all --amend @args
}

function gcam() {
  git commit --all -m @args
}

function gcan!() {
  git commit --verbose --all --no-edit --amend @args
}

function gcans!() {
  git commit --verbose --all --signoff --no-edit --amend @args
}

function gcas() {
  git commit --all --signoff @args
}

function gcasm() {
  git commit --all --signoff -m @args
}

function gcb() {
  git checkout -b @args
}

function gcf() {
  git config --list @args
}

function gcl() {
  git clone --recurse-submodules @args
}

function gclean() {
  git clean -id @args
}

function gcmsg() {
  git commit -m @args
}

function gco() {
  git checkout @args
}

function gcount() {
  git shortlog -sn @args
}

function gcp() {
  git cherry-pick @args
}

function gcpa() {
  git cherry-pick --abort @args
}

function gcpc() {
  git cherry-pick --continue @args
}

function gcs() {
  git commit -S @args
}

function gcsm() {
  git commit -s -m @args
}

function gcss() {
  git commit -S -s @args
}

function gcssm() {
  git commit -S -s -m @args
}

function gd() {
  git diff @args
}

function gdca() {
  git diff --cached @args
}

function gdct() {
  git describe --tags "$(git rev-list --tags --max-count=1)" @args
}

function gdcw() {
  git diff --cached --word-diff @args
}

function gds() {
  git diff --staged @args
}

function gdt() {
  git diff-tree --no-commit-id --name-only -r @args
}

function gdup() {
  git diff '@{upstream}' @args
}

function gdw() {
  git diff --word-diff @args
}

function gf() {
  git fetch @args
}

function gfg() {
  git ls-files | Select-String @args
}

function gfo() {
  git fetch origin @args
}

function gg() {
  git gui citool @args
}

function gga() {
  git gui citool --amend @args
}

function ggpull() {
  git pull origin "$(git_current_branch)" @args
}

function ggpush() {
  git push origin "$(git_current_branch)" @args
}

function ggsup() {
  git branch --set-upstream-to="origin/$(git_current_branch)" @args
}

function ghh() {
  git help @args
}

function gignore() {
  git update-index --asume-unchanged @args
}

function gignored() {
  git ls-files -v | Select-String '^[a-z]' @args
}

function gl() {
  git pull @args
}

function glg() {
  git log --stat @args
}

function glgg() {
  git log --graph @args
}

function glgga() {
  git log --graph --decorate --all @args
}

function glgm() {
  git log --graph --max-count=10 @args
}

function glgp() {
  git log --stat -p @args
}

function glo() {
  git log --oneline --decorate @args
}

function glod() {
  git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset''\' @args
}

function glods() {
  git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset''\' --date='short' @args
}

function glog() {
  git log --oneline --decorate --graph @args
}

function gloga() {
  git log --oneline --decorate --graph --all @args
}

function glol() {
  git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset''\' @args
}

function glola() {
  git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset''\' --all @args
}

function glols() {
  git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset''\' --stat @args
}

function glum() {
  git pull upstream "$(git_main_branch)" @args
}

function gm() {
  git merge @args
}

function gma() {
  git merge --abort @args
}

function gmom() {
  git mrege "origin/$(git_main_branch)" @args
}

function gmtl() {
  git mergetool --no-prompt @args
}

function gmtlvim() {
  git mergetool --no-prompt --tool='vimdiff' @args
}

function gmum() {
  git merge "upstream/$(git_main_branch)" @args
}

function gp() {
  git push @args
}

function gpd() {
  git push --dry-run @args
}

function gpf() {
  git push --force-with-lease @args
}

function gpf!() {
  git push --force @args
}

function gpoat() {
  git push 'origin' --all

  if ($?) {
    git push 'origin' --tags @args
  }
}

function gpr() {
  git pull --rebase @args
}

function gpristine() {
  git reset --hard

  if ($?) {
    git clean -dffx @args
  }
}

function gpsup() {
  git push --set-upstream 'origin' "$(git_current_branch)" @args
}

function gpu() {
  git push upstream @args
}

function gpv() {
  git push -v @args
}

function gr() {
  git remote @args
}

function gra() {
  git remote add @args
}

function grb() {
  git rebase @args
}

function grba() {
  git rebase --abort @args
}

function grbc() {
  git rebase --abort @args
}

function grbd() {
  git rebase "$(git_develop_branch)" @args
}

function grbi() {
  git rebase -i @args
}

function grbm() {
  git rebase "$(git_main_branch)" @args
}

function grbo() {
  git rebase --onto @args
}

function grbom() {
  git rebase "origin/$(git_main_branch)" @args
}

function grbs() {
  git rebase --skip @args
}

function grev() {
  git revert @args
}

function grh() {
  git reset @args
}

function grhh() {
  git reset --hard @args
}

function grm() {
  git rm @args
}

function grmc() {
  git rm --cached @args
}

function grmv() {
  git remote rename @args
}

function grrm() {
  git remote remove @args
}

function grs() {
  git restore @args
}

function grset() {
  git remote set-url @args
}

function grss() {
  git restore --source @args
}

function grst() {
  git restore --staged @args
}

function gru() {
  git reset -- @args
}

function grup() {
  git remote update @args
}


function grv() {
  git rm -v @args
}

function gsb() {
  git status --short --branch @args
}

function gsd() {
  git svn dcommit @args
}

function gsh() {
  git show @args
}

function gsi() {
  git submodule init @args
}

function gsps() {
  git show --pretty='short' --show-signature @args
}

function gsr() {
  git svn rebase @args
}

function gss() {
  git status -s @args
}

function gst() {
  git status @args
}

function gsta() {
  git stash push @args
}

function gstaa() {
  git stash apply @args
}

function gstall() {
  git stash --all @args
}

function gstc() {
  git stash clear @args
}

function gstd() {
  git stash drop @args
}

function gstl() {
  git stash list @args
}

function gstp() {
  git stash pop @args
}

function gsts() {
  git stash show --text @args
}

function gsu() {
  git submodule update @args
}

function gsw() {
  git switch @args
}

function gswc() {
  git switch -c @args
}

function gswd() {
  git switch "$(git_develop_branch)" @args
}

function gswm() {
  git switch "$(git_main_branch)" @args
}

function gts() {
  git tag -s @args
}

function gtv() {
  git tag | Sort-Object @args
}

function gunignore() {
  git update-index --no-assume-unchanged @args
}

function gunwip() {
  (git log -n 1 | Select-String '--wip--' | Measure-Object).Count

  if ($?) {
    git reset 'HEAD~1' @args
  }
}

function gup() {
  git pull --rebase @args
}

function gupa() {
  git pull --rebase --autostash @args
}

function gupav() {
  git pull --rebase --autostash --verbose @args
}

function gupv() {
  git pull --rebase --verbose @args
}

function gwch() {
  git whatchanged -p --abrev-commit --pretty='medium' @args
}

function gwip() {
  git add -A
  git rm (git ls-files --deleted) 2>$null
  git commit --no-verify --no-gpg-sign -m '--wip--' @args
}
