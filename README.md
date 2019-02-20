# README

Run `rake owl_party:work[https://target-site.com/]`

Then, to download the URLs saved to the database, run `rake owl_party:rip`. Both rake commands can be run simultaneously in separate terminal tabs.

You may need to `chmod 777 public` so your rake user has the permission to write to your public folder.

You also may want to tweak the `remove_comments` method in `lib/tasks/owl_party.rake` to remove URLs following a certain pattern so that you can parse out comment or other URLs that you don't want to download.