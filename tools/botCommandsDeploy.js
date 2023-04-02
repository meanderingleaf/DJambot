import Discord from "discord.js";
import { SlashCommandBuilder } from '@discordjs/builders';
import { REST } from '@discordjs/rest';
import { Routes } from 'discord-api-types/v9';
import {} from 'dotenv/config';


//Commands
const commands = [
	new SlashCommandBuilder().setName('ping').setDescription('Replies with pong!'),
	new SlashCommandBuilder().setName('registergame').setDescription('Creates a game info!'),
	new SlashCommandBuilder().setName('gameinfo').setDescription('Replies with game info!'),
	new SlashCommandBuilder().setName('register').setDescription('Join the critique user group'),
	new SlashCommandBuilder().setName('setupjam').setDescription('Setup this server for a game jam'),
	new SlashCommandBuilder().setName('startcrit').setDescription('start a group critique'),
	new SlashCommandBuilder().setName('stepcrit').setDescription('step forward through critique message'),
]
.map(command => command.toJSON());

console.log( process.env.botToken );
const rest = new REST({ version: '9' }).setToken(process.env.botToken);

rest.put(Routes.applicationGuildCommands(process.env.clientId, process.env.guildId), { body: commands })
	.then(() => console.log('Successfully registered application commands.'))
	.catch(console.error);