import {PrismaClient} from '@prisma/client';
import {Client, GatewayIntentBits} from 'discord.js';
import CritBot from './critBot.js';
import {} from 'dotenv/config.js';

const prisma = new PrismaClient();
const dClient = new Client({intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent, GatewayIntentBits.DirectMessages]});
const critBot = new CritBot(dClient, prisma);


//dirty hacks
process.on('uncaughtException', function (exception) {
    // handle or ignore error
	console.log(exception);
   });

//* Bot stuff*//

dClient.once('ready', () => {
	console.log('Bot Ready!');
	critBot.setCheckinTimeout();
});

dClient.on('messageCreate', message => {
	critBot.handleMessage(message);
});

dClient.login(process.env.botToken);

dClient.on('interactionCreate', async interaction => {
	if (!interaction.isCommand()) {
		return;
	}

	const {commandName} = interaction;
	const {user} = interaction;

	switch (commandName) {
		case 'ping': {
			critBot.gatherGoals();
			//critBot.stepCrit();
			await interaction.reply('Pong!');
			break;
		}

		case 'setupjam': {
			critBot.setupServer(interaction);
			await interaction.reply('Sure thing boss, setting this server up for them game jams.');
			break;
		}

		case 'gameinfo': {
			//critBot.createCritThreads();
			critBot.nextCritQuestion(interaction);
			await interaction.reply(`Crit session has begun, please check the crits channel`);
			break;
		}

		case 'user': {
			await interaction.reply('User info.');
			break;
		}

		case 'register': {
			console.log("Registering");
			critBot.registerUser(user.username, user.id, 2);
			await interaction.reply(`${user.username} has been registered to this jam. Excellent.`);
			break;
		}

		case 'startjam': {
			critBot.startJam('StudyJam', 48, interaction.guildId);
			await interaction.reply('Starting your game jam. Woo!');
			break;
		}
	}
});
