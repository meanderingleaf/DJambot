import { withSessionSsr } from './withSession';
import { PrismaClient } from '@prisma/client';
 
export const getServerSideProps = withSessionSsr(async function ({ req, res }) {
  const { user } = req.session;
 
  if (!user) {
    return {
      redirect: {
        destination: '/llogin',
        permanent: false,
      },
    };
  }

  const prisma = new PrismaClient()
  const userCount = await prisma.user.count();
  const jam = await prisma.jam.findFirst();
  const completedCrits = await prisma.GramVid.count({ where: { critStep: jam.currentCritStepId }})
 
  return {
    props: { user, userCount, critStep: jam.currentCritStep, completedCrits: completedCrits },
  };
});

function triggerVideoMerge() {

}
 
const Profile = ({ user, userCount, critStep, completedCrits }) => {
  // Show the user. No loading state is required
  return (
    <div>
      <h1>D'Jambot Admin: {user.name}</h1>
      <div>
        <div>
            Current step: {critStep}
            <div>
                <div>
                    <progress max="100" value={ (completedCrits / userCount) * 100}> { }</progress>
                </div>
                Crits completed: { completedCrits }
            </div>
        </div>
        <div>Total jammers: { userCount} </div>
        <div>
            These are the links: 
            <ul>
                <li><a href="">Gram list</a></li>
                <li><a href="">Compiled Showcase Vidos</a></li>
            </ul>
        </div>
        <div>Useful tools?
            <ul>
                <li><button onClick={() => { triggerVideoMerge() }}>Trigger video merge</button></li>
                <li><button>Force start crit</button></li>
                <li><button>Show merged videos</button></li>
            </ul>
        </div>
      </div>
    </div>
  );
};
 
export default Profile;