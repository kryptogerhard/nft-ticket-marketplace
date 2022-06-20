/* pages/_app.js */
import '../styles/globals.css'
import Link from 'next/link'

function MyApp({ Component, pageProps }) {
  return (
    <div>
      <nav className="border-b p-6, bg-cyan-900">
        <p className="text-4xl font-bold, pb-5 text-amber-700 pt-2 pl-5"> NFT-Ticket Marketplace</p>
        <div className="flex mt-6, text-2xl pb-2 pl-5">
          <Link href="/">
            <a className="mr-4 text-amber-700">
              Home
            </a>
          </Link>
          <Link href="/create-nft-ticket">
            <a className="mr-6 text-amber-700">
              Sell NFT Tickets
            </a>
          </Link>
          <Link href="/my-nft-tickets">
            <a className="mr-6 text-amber-700">
              My NFT Tickets
            </a>
          </Link>
          <Link href="/dashboard">
            <a className="mr-6 text-amber-700">
              Dashboard
            </a>
          </Link>
        </div>
      </nav>
      <div className="bg-zinc-300">
      <Component {...pageProps} />
      </div>
    </div>
  )
}

export default MyApp