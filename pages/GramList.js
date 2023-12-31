import Head from 'next/head'
import { PrismaClient } from '@prisma/client';

export default function GramList({grams}) {
    return(<div>
        Hi!
        {grams[0].title}
    </div>);
}

export async function getServerSideProps(context) {
  const prisma = new PrismaClient()
  const grams = await prisma.gram.findMany();
  return { props: { grams } }
}