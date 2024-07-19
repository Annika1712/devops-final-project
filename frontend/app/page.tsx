import Link from "next/link"

import { siteConfig } from "@/config/site"
import { buttonVariants } from "@/components/ui/button"

export default function IndexPage() {
  return (
    <section className="container grid items-center gap-6 pb-8 pt-6 md:py-10">
      <div className="flex max-w-[980px] flex-col items-start gap-2">
        <h1 className="text-3xl font-extrabold leading-tight tracking-tighter md:text-4xl">
          A lightweight expense tracker app <br className="hidden sm:inline" />
          built with NextJs and Tailwind CSS.
        </h1>
        <p className="max-w-[700px] text-lg text-muted-foreground">
        Freely manage your expenses in a secure way
        </p>
      </div>
      <div className="flex gap-4">
      <Link
          href={siteConfig.links.home}
         
          rel="noreferrer"
          className={buttonVariants()}
        >
          Get Started
        </Link>
       
      
      </div>
    </section>
  )
}
