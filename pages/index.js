import Head from 'next/head'
import Link from 'next/link'

export default function Home() {
  return (
    <div className="container">
      <Head>
        <title>Create Nooxt App</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Link href="GramList">grams</Link>
    </div>
  )
}
