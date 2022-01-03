## Download Action

Use Github Action to download the file, and upload them to the corresponding Github repository, support`Http`,`Https`,`Ftp`,`Ftps`,`BitTorrent`protocols.

### Usage

```yaml
on: push
jobs:
  wget:
    runs-on: ubuntu-latest
    steps:
    - name: clone repository
      uses: actions/checkout@v2
    - name: download
      uses: iamazy/download-action@main
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        url: 'https://github.com/dreamnettech/waifu2x-chainer/releases/download/v0.1.0/waifu2x-v0.1.0-macos-cpuonly.7z 
              magnet:?xt=urn:btih:KRWPCX3SJUM4IMM4YF5RPHL6ANPYTQPU'
        actor: ${{ github.actor }}
        repo: ${{ github.repository }}
```
