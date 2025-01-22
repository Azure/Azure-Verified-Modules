+++
categories = ["explanation", "howto"]
description = "Add further code to your site"
options = ["relearn.dependencies"]
title = "Extending Scripts"
weight = 2
+++

A common question is how to add extra CSS styles or JavaScript to your site. This depends on what you need.

## Adding JavaScript or Stylesheets to All Pages

To add JavaScript files or CSS stylesheets to every page, you can include them in `layouts/partials/custom-header.html` or `layouts/partials/custom-footer.html`.

However, this can make your site larger than necessary if these files are only needed on a few pages. The next section explains how to add dependencies only when needed.

## Custom Shortcodes with Dependencies

Some shortcodes need extra JavaScript and CSS files. The theme only loads these when the shortcode is used. You can use this for your own shortcodes too.

For example, to create a shortcode called `myshortcode` that needs the `jquery` library:

1. Create the shortcode file `layouts/shortcodes/myshortcode.html` and add the folloging line somewhere:

    ````go {title="layouts/shortcodes/myshortcode.html"}
    ...
    {{- .Page.Store.Set "hasMyShortcode" true }}
    ...
    ````

2. {{% badge style="cyan" icon="gears" title=" " %}}Option{{% /badge %}} Add this to your `hugo.toml`:

    {{< multiconfig file=hugo >}}
    [params.relearn.dependencies]
      [params.relearn.dependencies.myshortcode]
        name = 'MyShortcode'
    {{< /multiconfig >}}

3. Create loader file `layouts/partials/dependencies/myshortcode.html`:

    ````go {title="layouts/partials/dependencies/myshortcode.html"}
    {{- if eq .location "footer" }}
      <script src="https://www.unpkg.com/jquery/dist/jquery.js"></script>
    {{- end }}
    ````

Important notes:

- Character casing is relevant!
- The `name` in `hugo.toml` must match the `Store` key used in the shortcode file, prefixed with a `has`.
- The key of `relearn.dependencies` must match the loader file name.

See the `math`, `mermaid`, and `openapi` shortcodes for examples.

{{% notice note %}}
For advanced customization, you can use the dependency loader in your own partials:

````go
{{- partial "dependencies.gotmpl" (dict "page" . "location" "mylocation") }}
````
{{% /notice %}}

Give a unique name for the `location` parameter when you call it, so you can distinguish your loaders behavior depending on the location it was called from.
