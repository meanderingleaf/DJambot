export default class GroupCrit {

    totalProjects = 0;
    currentCrit = 0;
    critStage = 0;
    critChannel;

    constructor(countTotal, currentCrit) {
        this.totalProjects = countTotal;
        currentCrit = 0;

        //okay fine bad programming practice, I don't care this time.
        this.critChannel = dClient.channels.cache.get('critique');
    }

    beginVideoShare() {
        //Enter video chat

        //load up video

        //play video

        //set timers for first entry
    }

    endVideoShare() {
        //thanks everyone for coming out?
        //hardcoded message
    }

    stepForwardCrit() {
       
        this.critChannel.send('content');
        
        //display message

        setTimeout(this.stepForwardCrit, 45000);
    }

    stepForwardProject() {
        this.currentCrit++;
        if(this.currentCrit > this.totalProjects) {
            //query for crit

            //play video

            //next Q
            this.stepForwardCrit();
        } else {
            //call callback if c set
            if(this.complete) this.complete();
        }
        
    }

}