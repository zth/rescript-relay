/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

module.exports = {
  title: "RescriptRelay",
  tagline:
    "Production ready, batteries included GraphQL frontend framework for ReScript",
  url: "https://rescript-relay-documentation.vercel.app/",
  baseUrl: "/",
  favicon: "img/favicon.png",
  organizationName: "zth", // Usually your GitHub org/user name.
  projectName: "rescript-relay", // Usually your repo name.
  themeConfig: {
    navbar: {
      title: "RescriptRelay",
      items: [
        { to: "docs/start-here", label: "Docs", position: "left" },
        { to: "blog", label: "Blog", position: "left" },
        { to: "showcases", label: "Showcases", position: "left" },
        { to: "community", label: "Community", position: "left" },
        {
          href: "https://github.com/zth/rescript-relay",
          label: "GitHub",
          position: "right",
        },
      ],
    },
    googleAnalytics: {
      trackingID: "UA-205541354-1",
      // Optional fields.
      anonymizeIP: true, // Should IPs be anonymized?
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Docs",
          items: [
            {
              label: "Docs",
              to: "docs/introduction",
            },
          ],
        },
        {
          title: "Community",
          items: [
            {
              label: "Discord",
              href: "https://discord.gg/wzj4EN8XDc",
            },
          ],
        },
        {
          title: "Social",
          items: [
            {
              label: "Blog",
              to: "blog",
            },
          ],
        },
      ],
      copyright: `Built with Docusaurus.`,
    },
  },
  presets: [
    [
      "@docusaurus/preset-classic",
      {
        docs: {
          sidebarPath: require.resolve("./sidebars.js"),
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      },
    ],
  ],
};
