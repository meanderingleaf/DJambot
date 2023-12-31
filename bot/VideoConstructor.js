import { createCanvas, loadImage } from 'canvas';
import FfmpegCommand from 'fluent-ffmpeg';
import fs from 'fs';

export default class VideoConstructor {

    //videos to combine
    _comments = [ "aaaa", "fffuu" ];
    _singleVideos = [ "vids/ForBiggerBlazes.mp4", "vids/ForBiggerBlazes.mp4" ];

    //--- precompute text on video -------
    //wich means making a bunch of lesser videos..
    //which isn't bad I probably need these anyway
    // and my system probably will make these automagically..
    index = 0;
    textedVideos = []; // this is am empty array, its going on an Uutings

    constructor(comments,videos) {

        this._comments = comments;
        this._simgleVideos = videos;

        this.mergText(this.index);

    }

    mergeText(ind) {


        //text
        drawText(comments[ind]);
        //then on top of image

        var mergeCommand = new FfmpegCommand();
        mergeCommand.input(this.singleVideos[this.ind]);
        //mergeCommand.input("output/textOverlay.png");
        mergeCommand.complexFilter([
            `[1:v]format=rgba,fade=in:st=1:d=3:alpha=1,fade=out:st=6:d=3:alpha=1 [ovr]`,
            `[0][ovr] overlay`
        ]);

        mergeCommand.addOptions([
            "-loop 1", 
            "-t 9", "-i output/textOverlay.png", 
        ])
        
        mergeCommand.on('start', (cmdline) => console.log(cmdline))
        //        `[1:v]format=rgba,fade=in:st=0:d=1:alpha=1[ovr]`,
        // `[1:v] format=rgba,fade=in:st=0:d=1:alpha=1,fade=out:st=6:d=2:alpha=1 [ovr]`,
        mergeCommand.on('error', function(err) {
            console.log('An error occurred: ' + err.message);
        })
        .on('end', function() {
            console.log('Processing finished !');
            this.textedVideos.push(`output/outputMerge${ind}.mp4`)
            this.index ++;
            if(this.index < this.singleVideos.length) {
                mergText(this.index);
            } else {
                combineVideos();
            }
        })
        .save(`output/outputMerge${ind}.mp4`)
    }


    drawText(tex) {
        const canvas = createCanvas(200, 200)
        const ctx = canvas.getContext('2d')

        ctx.font = '30px Impact'
        ctx.fillText(tex, 50, 100)

        const buffer = canvas.toBuffer('image/png')
        fs.writeFileSync('output/textOverlay.png', buffer);
    }

    combineVideos() {
    
        //AND THEN
        // AND THEN
        // you merge all those videos into one video
        //video command
        var command = new FfmpegCommand();

        for(let vidUrl of this.textedVideos) {
            command.input(vidUrl);
        }

        command.on('error', function(err) {
            console.log('An error occurred: ' + err.message);
        })
        .on('end', function() {
            console.log('Processing finished !');
        })
        .mergeToFile('output/outputfile.mp4', 'output/tmpdir')

        
    }
}