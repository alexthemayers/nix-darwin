{
  config,
  lib,
  mattpocockSkills,
  username,
  ...
}:
let
  home = config.users.users.${username}.home;
  # plugin.json is the set upstream ships. misc/ and in-progress/ are not in it.
  plugin = builtins.fromJSON (builtins.readFile (mattpocockSkills + "/.claude-plugin/plugin.json"));
  skillRelPaths = map (lib.removePrefix "./") plugin.skills;
  skillPaths = map (rel: mattpocockSkills + "/${rel}") skillRelPaths;
  skillNames = map baseNameOf skillRelPaths;
in
{
  assertions = [
    {
      assertion = plugin ? skills && builtins.isList plugin.skills && plugin.skills != [ ];
      message = "mattpocock/skills plugin.json has no skills list";
    }
    {
      assertion = lib.all (
        rel: builtins.pathExists (mattpocockSkills + "/${rel}/SKILL.md")
      ) skillRelPaths;
      message = "mattpocock/skills is missing a SKILL.md listed in plugin.json";
    }
    {
      assertion = lib.length (lib.unique skillNames) == lib.length skillNames;
      message = "mattpocock/skills plugin.json has duplicate skill directory names";
    }
  ];

  # Cursor loads ~/.cursor/skills/<name>/SKILL.md. One symlink per skill, because
  # the upstream tree nests them under engineering/ and productivity/.
  # Re-run darwin-rebuild after `nix flake update` to pick up new revisions.
  system.activationScripts.postActivation.text = ''
    skills_dir="${home}/.cursor/skills"
    skills_group="$(/usr/bin/id -gn ${username})"
    /usr/bin/install -d -m 0755 -o ${username} -g "$skills_group" "${home}/.cursor" "$skills_dir"

    manifest="$skills_dir/.mattpocock-managed"
    if [[ -f "$manifest" ]]; then
      while IFS= read -r name || [[ -n "$name" ]]; do
        [[ -z "$name" ]] && continue
        target="$skills_dir/$name"
        if [[ -L "$target" ]]; then
          rm -f "$target"
        fi
      done < "$manifest"
    fi

    linked="$manifest.new"
    : > "$linked"
    ${lib.concatMapStrings (skill: ''
      source=${lib.escapeShellArg skill}
      target="$skills_dir/${baseNameOf skill}"
      if [[ -e "$target" && ! -L "$target" ]]; then
        printf 'cursor skills: leaving %s in place\n' "$target" >&2
      else
        ln -sfn "$source" "$target"
        printf '%s\n' "${baseNameOf skill}" >> "$linked"
      fi
    '') skillPaths}
    mv -f "$linked" "$manifest"
    chown ${username}:"$skills_group" "$manifest"
  '';
}
