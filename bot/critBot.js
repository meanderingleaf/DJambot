
import {} from 'dotenv/config';
import fs from 'fs';
import https from 'https';
import {ChannelType} from 'discord.js';
import concat from 'ffmpeg-concat';
import GroupCrit from "./GroupCrit.js";
import Bree from 'bree';
import {Client, GatewayIntentBits} from 'discord.js';

/*
    Needs a specific sharp version:
    https://github.com/lovell/sharp/issues/3438
*/

export default class CritBot {

    jamDuration = 48; //duration of the jam in hours
    intervals = 12;
    groupCritTimeout = 30; // duration after solo crit to group crit, in minutes
    discordClient;
    prisma;
    bree; graceful; groupCrit;

    //some local stuff
    currentCritStep;

    constructor(dClient, prisma) {

        this.discordClient = dClient;
        this.prisma = prisma;

        /*
         //seems useful but not installed
        this.bree = new Bree({ logger: false, jobs: 
            [
                { name: 'CronJobs', interval: '4h' }
            ] 
        });
           
        this.graceful = new Graceful({ brees: [this.bree] });
        this.graceful.listen();
        */
    }

    /* 
        does initial setup stuff like:
        1. Create the channels needed and
        2. Thats it for now
     */
    async setupServer(interaction) {
        //console.log(interaction);
        const guild = await this.discordClient.guilds.fetch(interaction.guild.id);

       // console.log( guild.channels.cache );

        //first check to see if they exists
        if(! guild.channels.cache.find(channel => channel.name === "crits") ) {
                //if they don't exists - then make the channels for crit
            guild.channels.create({ name: "crits", type: ChannelType.GuildText }).then(channel => { //main part I modified
                channel.send("Surprisingly, this is the crit channel. Most of the work will occur in the threads here.");
            })
        }
        if(! guild.channels.cache.find(channel => channel.name === "public-crits") ) {
            guild.channels.create({name: "public-crits", type: ChannelType.GuildText}).then(channel => { //main part I modified
                channel.send("I'm going to be posting videos of all your work in here. It will be great.");
            })
        }
        
    }

    async setCheckinTimeout() {
        
        //get the current jam
        let currentJam = await this.prisma.Jam.findFirst({include: { critiqueStep: true }});

        //get last check in from the db
        //TODO: This is hardcoded, need to soft
        let nextCritStep = currentJam.critiqueStep;
        this.currentCritStep = nextCritStep;

        //if it exists - it might not (means the jams crits is over)
        if(nextCritStep) {
            
            //calculate the difference in time between when it needs to run and now
            let critTime = nextCritStep.time;
            let waitTime = nextCritStep.time - Date.now();

            //set the timeout for it
            setTimeout(() => { this.stepCrit() }, waitTime);
        }
    }

    //this is crit step iteration (steps the entire jam forward one crit)
    async stepCrit() {

        console.log("Step crit");

        //get the current jam
        let currentJam = await this.prisma.Jam.findFirst();

        //get the current crit step from that jam

        //get the current crit step info
        let critStepInfo = await this.prisma.CritiqueStep.findFirst({ 
            where: { jamId: currentJam.id }, 
            include: { prompts: true }
        });
        this.currentCritStep = critStepInfo;

        //prompt is whats in the crit step
        let prompt = critStepInfo.prompts[0].text;

  
        //get all the users
        let users = this.prisma.User.findMany({include: { goals: true }});

        //message them all based on their most current goal
        let thread;
        for(let user of users) {
            let goal = user.goals[user.goals.length-1];
            let message = `When last we spoke, you were working on this goal: ${goal}. Could you upload a short clip of your progress and tell me a bit about what you've done since then?`;
            //get the thread 
            thread = await this.discordClient.channels.fetch(user.discordThread);
            await thread.join();
            thread.send(message).catch(console.error);
        }

        //get all the jam users
        //this.sendMessageAllCrits(critStepInfo.prompts[0].text);
  
       
        //-------  set timeout for next crit ---------------
        //get the next crit step
        let nextCritStep = await this.prisma.CritiqueStep.findFirst({ 
            where: { jamId: currentJam.id, stage: critStepInfo.stage + 1 }
        });


        //Set group feedback timeout
        setTimeout( () => { this.generateVideos() }, this.groupCritTimeout );

        //if it exists - it might not (means the jams crits is over)
        if(nextCritStep) {
            
            //calculate the difference in time between when it needs to run and now
            let critTime = nextCritStep.time;
            let waitTime = 1000;

            //set the timeout for it
            setTimeout(() => { this.stepCrit() }, waitTime);
        }
        
    }

    generateVideos() {
       

       //For ever jammer
        //generate solo videos 
        // start with goal
        // fade in video
        // drop in a feedback text on top
       


       // Take all the solo videos

            // moosh them together

        // Once all video makes



    }

    async nextCritQuestion(interaction) {

        //get the user
        let user = await this.prisma.User.findFirst({ 
            where: { userId: Number(interaction.user.id) }
        });

        //increment user step
        user.critiqueStage = user.critiqueStage + 1;
        
        //get the next crit
        let nextCrit = this.currentCritStep.prompts[user.critiqueStage];

        //if that one actually exists
        if(nextCrit) {
            //post a message to that channel about it
            await interaction.reply(nextCrit.text); 
        } else {
            //this was the end of crits - set user phase back to zero
            user.critiqueStage = 0;
        }

         //insert next crit stage into user DB
         this.prisma.User.update({ 
            where: { id: user.id },
            data: { critiqueStage: user.critiqueStage }
        });

    }

    //Starts the jam
    //takes a jam name and duration in hours
    async startJam(jamName, jDuration, serverId) {

        console.log("Start jam");
        //set duration
        this.jamDuration = jDuration;

        //Calculate intervals
        this.intervals = jDuration / 4;
            //TODO:Probably needs to be a bit more.. tender, about when

        //register start date
        //Insert into DB?
        const jam = await this.prisma.Jam.create({
            data: { name: jamName, server: serverId }
        });

        //insert all the crit times into the DB
        let critTime = new Date();
        await this.prisma.CritiqueStep.create({
            data: {order: 0, stage: 0, name: "midway", time: critTime, jam: { connect: { id: jam.id }}}
          });


        //crit partners
        //this.assignCritPartners();
    }

    //
    async registerUser(userName, userId) {
        //add team member of the person who registered
        const user = await this.prisma.User.upsert({
            where: { id: Number(userId) },
            create: { name: userName, userId: Number(userId) },
            update: { name: userName }
          })

          /*
        const team = await this.prisma.User.create({
            data: {
                name: userName,
                userId: Number(userId)
            }
        })
        */
    }

    async sendMessageAllCrits(message) {
        //get all users
        const users = await this.prisma.User.findMany();

        let thread;
        //loop through the users
        for(let user of users) {
            // thread = await channel.threads.cache.find(channel => channel.name === user.discordThread);
            //get the thread 
            thread = await this.discordClient.channels.fetch(user.discordThread);
            await thread.join();
            thread.send(message).catch(console.error);
        }
    }

    async createCritThreads() {
        //query for a list of all teams jamming

        //first by getting the channel
        let channel = this.discordClient.channels.cache.find(channel => channel.name === "crits");

        //if they don't exist, create a thread of all teams
        const users = await this.prisma.User.findMany();
        
        for(let ind in users) {
            let user = users[ind];

            //make a new thread
            const thread = await channel.threads.create({
                name: user.name + "'s game",
                autoArchiveDuration: 60,
                reason: `For talking about ${user.name}'s game`,
            });

            //join it
            await thread.join();

            //
            const updatedUser = await this.prisma.User.update({
                where: { id: user.id },
                data: { discordThread: thread.id }
              })

            //TODO: join other user to it?

            //post welcome message
            thread.send(`This thread is for commenting on updates on ${user.name}'s game`)
        };

        //start the crit
        //this.groupCrit = new GroupCrit();
    }

    async gatherGoals() {
        //Set goal gathering flags on users so they're prompted on message
          const updateUsers = await this.prisma.User.updateMany({
            data: {
              settingGoal: true,
              uploadingImage: true
            },
          })

        this.sendMessageAllCrits("Can you tell me your goal for the next six hours of the jam?");
    }

    //maybe not needed
    assignCritPartners() {
        //
    }

    async generateVideo() {
        //grab all the videos that have been uploaded recently
        let vids = await this.prisma.GramVid.findMany({where: { critStepId: this.currentCritStep.id } });

        //get just the vids into an array
        let vidPaths = vids.map((vid) => vid.path );

        //lets only allow one type of upload video now..
        //create a filename for the new file
        let filePath = `/generatedVideos/${this.currentCritStep.id}.mp4`;

        //moosh them into one, longer vide

        
        //crunch that video in
        await concat({
            output: filePath,
            videos: vidPaths,
            transition: {
              name: 'directionalWipe',
              duration: 100
            }
          })
          
          
        //save the path name to the database
        this.prisma.CritVideo.create({ 
            data: { path: filePath, critStepId: this.currentCritStep.id  }
        });

        //onward to the next thing..
        this.uploadVideo();
    }

    async uploadVideo() {
        //first, we must remember the current jam
        let currentJam = await this.prisma.Jam.findFirst({include: { critiqueStep: true }});

        const guild = await this.discordClient.guilds.fetch(currentJam.server)

        //figure out the channel to send to..
        let channel = guild.channels.cache.find(channel => channel.name === "public-crits");
  
        //get the crit step video
        let critVid = this.prisma.CritVideo.findFirst({where: { critStepId: this.currentCritStep.id }});

        //I'm sure discord.js can upload, right?
        channel.send({ files: [{ attachment: critVid.path }] });

        //now we can start the crit!
        this.startGroupCrit();
    }

    async startGroupCrit() {

        //Once the upload is complete, the crit will happen

        //first, we must remember the current jam
        let currentJam = await this.prisma.Jam.findFirst({include: { critiqueStep: true }});

        const guild = await this.discordClient.guilds.fetch(currentJam.server)

        //figure out the channel to send to..
        let channel = guild.channels.cache.find(channel => channel.name === "public-crits");

        //send message
        channel.send("Starting group crit...");

        //create threads / timeouts..

    }


    //handling any and all messages that drift into our environment
    async handleMessage(message) {
        //get channel 
        let channel = await this.discordClient.channels.fetch(message.channelId);
        
        //console.log(message.author);

        //if(message.)
        if(!message.author.bot && channel.isThread()) {

            //get user
            let user = await this.prisma.User.findFirst({ 
                where: { userId: Number(message.author.id) }
            });

            //check if the user is in GOAL SETTING MODE
            if(user.settingGoal) {
                //store the text as a goal
                this.prisma.Goal.create({ 
                    data: { description: message.content, userId: user.id }
                });

                //kick out of goal setting
                this.prisma.User.update({
                    where: { id: user.id },
                    data: { settingGoal: false }
                })

                //Send response message
                channel.send("Thanks! I'll ask you about this later - best of luck!");
            }

            //check if its image upload time
            if(user.uploadingImage) {
                
                //check for attachments
                let attachments =  Array.from(message.attachments);

                if(message.attachments.size > 0) {
                    channel.send("Good one I'm downloading this.");
                
                    let name = attachments[0][1].attachment.split("/").pop();

                    let dir = `critImages/${this.currentCritStep.stage}`;
                    //make directory if it doesn't exist
                    if (!fs.existsSync(dir)){
                        fs.mkdirSync(dir, { recursive: true });
                    }

                    const file = fs.createWriteStream(`${dir}/${name}`);
                    // console.log(attachments[0][1].attachment);
                    const request = https.get(attachments[0][1].attachment, function(response) {
                        response.pipe(file);

                        // after download completed close filestream
                        file.on("finish", () => {
                            file.close();

                            //save this file info to the database
                            //TODO: This is untested.
                            this.prisma.GramVid.create({ 
                                data: { path: dir, userId: user.id, critStepId: this.currentCritStep.id  }
                            });
                        });
                    });
                } 
            }
            
        }
    }
}