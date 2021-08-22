import React from "react";
import clsx from "clsx";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import useBaseUrl from "@docusaurus/useBaseUrl";
import styles from "./styles.module.css";

const features = [
  {
    title: <>100% production focused</>,
    imageUrl: "img/undraw_docusaurus_mountain.svg",
    description: (
      <>
        RescriptRelay is fully focused on building maintainable and scalable
        products fast. Enjoy the raw power of the most powerful GraphQL client
        in ReScript, the most powerful language available for building frontend
        applications.
      </>
    ),
  },
  {
    title: <>Developer Experience</>,
    imageUrl: "img/undraw_docusaurus_tree.svg",
    description: (
      <>
        DX is a top priority. We bring dedicated tooling like a VSCode extension
        and a CLI packed with features designed to help your codebase stay
        healthy as it grows in size and complexity.
      </>
    ),
  },
  {
    title: <>Unique features</>,
    imageUrl: "img/undraw_docusaurus_react.svg",
    description: (
      <>
        ReScript's fully sound type system has empowered us to build out a set
        of tooling unique to RescriptRelay. As always, the tooling is focused on
        one thing only - helping you scale and maintain your products.
      </>
    ),
  },
];

function Feature({ imageUrl, title, description }) {
  const imgUrl = useBaseUrl(imageUrl);
  return (
    <div className={clsx("col col--4", styles.feature)}>
      {imgUrl && (
        <div className="text--center">
          <img className={styles.featureImage} src={imgUrl} alt={title} />
        </div>
      )}
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
}

function Home() {
  const context = useDocusaurusContext();
  const { siteConfig = {} } = context;
  return (
    <Layout
      title={`${siteConfig.title} - Production ready GraphQL framework for ReScript`}
      description={`${siteConfig.title} - Production ready GraphQL framework for ReScript`}
    >
      <header className={clsx("hero hero--primary", styles.heroBanner)}>
        <div className="container">
          <h1 className="hero__title">{siteConfig.title}</h1>
          <p className="hero__subtitle">{siteConfig.tagline}</p>
          <div className={styles.buttons}>
            <Link
              className={clsx(
                "button button--outline button--lg",
                styles.getStarted
              )}
              to={useBaseUrl("docs/start-here")}
            >
              Get Started
            </Link>
          </div>
        </div>
      </header>
      <main>
        {features && features.length > 0 && (
          <section className={styles.features}>
            <div className="container">
              <div className="row">
                {features.map((props, idx) => (
                  <Feature key={idx} {...props} />
                ))}
              </div>
            </div>
          </section>
        )}
      </main>
    </Layout>
  );
}

export default Home;
