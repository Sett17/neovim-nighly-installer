# Neovim nightly installer

*Cron ready*

*For Ubuntu/Debian*

This needs the neovim git repo to be under `./source`

## Example cronjob

This builds it every tuesday and fridat at 4am.

```cron
0 4 * * 2,5 path/build-latest-nightly.sh >> path/build.log 2>&1
```
