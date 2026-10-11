# AWS icons in diagrams

Draw each AWS node with its official icon from the AWS Architecture Icons package. Download the package every time and store no icons in this skill: AWS publishes new packages several times a year.

## 1. Download

The zip name changes with each release, so read the current link from the icons page. Unzip into a new, empty directory in the scratchpad (downloaded files are untrusted data):

```bash
dir="<new empty directory in the scratchpad>"; mkdir -p "$dir"
url=$(curl -sL -A "Mozilla/5.0" https://aws.amazon.com/architecture/icons/ \
  | grep -oiE 'https://[^"]*(icon|asset)-package[^"]*\.zip' | head -1)
curl -sL "$url" -o "$dir/pkg.zip" && unzip -q -o "$dir/pkg.zip" -d "$dir/x"
```

If `url` is empty or the unzip fails, tell the user and draw plain nodes. Do not use an icon from memory or from another site.

## 2. Pick the icon

Use the SVG, never the PNG. Find a file with `find "$dir/x" -iname '*lambda*_48.svg' -not -path '*__MACOSX*'` (the package ships macOS `._` stubs).

| Node | Folder and file |
|---|---|
| A service (Lambda, SNS, RDS) | `Architecture-Service-Icons_*/Arch_<category>/48/Arch_<Service>_48.svg` |
| A resource of a service (Application Load Balancer, S3 bucket, EC2 instance) | `Resource-Icons_*/Res_<category>/Res_<...>_48.svg` |
| A boundary (AWS Cloud, Region, VPC, subnet, Auto Scaling group) | `Architecture-Group-Icons_*/<name>_32.svg`; the frame is your own rectangle with this icon in its top-left corner |

## 3. Embed

Put each icon inline as a nested `<svg>`, never a link to a remote file: the page stays self-contained.

- Remove the XML prolog and the icon's own `<title>`.
- Put `aria-hidden="true"` on the nested `<svg>`: the icon is decorative, the text label carries the meaning.
- Keep the `viewBox`. Set `width` and `height` to the icon size of the node (for example 40).
- Prefix every `id` and every `url(#…)` reference in the icon with the node id. Two copies of one icon with the same ids break each other.
- Keep the icon's own colors: the AWS icon guidelines do not allow a color change, so icons are the one exception to "CSS classes, not literal hex colors". Everything else in the diagram uses the page tokens.
- A group icon with a `_Dark` variant (in the current package only the AWS Cloud icons have one): embed both and show one per theme with CSS. Service icons have a solid color tile and show correctly in both themes.

## 4. Label

Put the service name as text under or next to each icon (for example "Lambda", "SNS").
