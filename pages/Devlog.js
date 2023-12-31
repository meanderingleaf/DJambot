import Head from 'next/head'
import { useRouter } from 'next/router'
import { PrismaClient } from '@prisma/client';

export default function Devlog({grams, username}) {
    return(<div class="container">
           
                <div class="gramHeader">{username}'s devgrams </div>

                  {grams.map((gram, ind) => {
                      let vidEl = ind < grams.length - 1 ?  <div class="media-left"><video className="gramVid" src={gram.gramPath} width="100%" controls></video></div>: "";
                      return (
                        <div class = "main panel panel-default p-2">
                        <div class = "panel-body p-2">
                          
                          <div class="d-flex flex-column flex-wrap ml-2"><span class="font-weight-bold">{gram.time}</span></div>
                          <div class="media">

                            <div class="media-body">
                            {vidEl}
                            </div>
                          </div>
                          <div>
                            {
                              gram.critMessages.map( (msg) => {
                                
                                return(<div class="post"><span>{msg.sender} : { msg.message }</span></div>);
                              })
                            }
                          </div>
                        </div></div>
                        )
                  })}
                              

        </div>);
}

export async function getServerSideProps(context) {
  let uid  = Number(context.query.user);
  const prisma = new PrismaClient();
  let user  = await prisma.User.findFirst({ where: { id: Number(uid) }});
  console.log(user);
  let grams = await prisma.GramVid.findMany({ where: { userId: uid }, include: { critMessages: true } });
  grams.map(g => {
    
      g.time = `${g.time.getMonth()} / ${g.time.getDate()} / ${g.time.getHours()}`; //Math.floor(g.time / 1000);
      g.critMessages.map(c => {
        c.time = Math.floor(c.time / 1000);
        return c;
      })
    
      return g;
  })

  grams.push(grams.shift())


  return { props: {  grams, username: user.name  } }
}