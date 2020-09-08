<template>
    <div ref="bodyReplacement" :style="`width: 100vw; height: 100vh; transform: scale(${zoomPercent/100});`" draggable="true" @dragstart="dragStart" @drag="dragging" @dragend="dragEnd" @wheel="scroll">
        <div id="anchor" :style="`position: fixed; transform: translate(${livePositionX}px, ${livePositionY}px);`" >
            <span style="background-color: red; min-height:2rem; min-width: 4rem;">Content</span>
            <svg viewBox="0 0 240 80" xmlns="http://www.w3.org/2000/svg">
                <!-- <style>.small {
                        font: italic 13px sans-serif;
                    }
                    .heavy {
                        font: bold 30px sans-serif;
                    }

                    /* Note that the color of the text is set with the    *
                    * fill property, the color property is for HTML only */
                    .Rrrrr {
                        font: italic 40px serif;
                        fill: red;
                    }</style> -->

                <text x="20" y="35" class="small">My</text>
                <text x="40" y="35" class="heavy">cat</text>
                <text x="55" y="55" class="small">is</text>
                <text x="65" y="55" class="Rrrrr">Grumpy!</text>
            </svg>
        </div>
    </div>
</template>

<style>
    html {
        overflow: hidden;
    }
    #anchor {
        overflow: visible;
        height: 0;
        width: 0;
        /* transition: all 100ms ease-out; */
    }
    
</style>

<script>
import "css-baseline/css/4.css"

// note
    // the body is the one being dragged, but the inside is the one being offset
    // also body is the one being scaled (as an attepmt to make zooming, zoom towards the center)
// TODO:
//  - try to fix the bounce issue when letting go of a drag
//       best solution would be to make the dragable element 
//  - the panning movement doesn't scale when zoomed in
//  - create frames by saving an [ x, y, scale, and rotation ]
//  - add svg objects with contentedible
//  - allow the drag to be captured by smaller things
//  - zoom isnt uniform because its a percent, maybe add some scaling of zoom
export default {
    data: ()=>({
        startX: 0,
        startY: 0,
        changeX: 0,
        changeY: 0,
        savedPositionX: 0,
        savedPositionY: 0,
        livePositionX: 0,
        livePositionY: 0,
        zoomPercent: 100,
    }),
    mounted() {
        window.app = this 
        setInterval(() => {
            console.debug(`JSON.stringify(this.$data) is:`,JSON.stringify(this.$data))
        }, 500)
    },
    methods: {
        dragEnd(eventObj) {
            // save change
            this.savedPositionX += eventObj.clientX - this.startX
            this.savedPositionY += eventObj.clientY - this.startY
            this.livePositionX = this.savedPositionX
            this.livePositionY = this.savedPositionY
            // reset temp vars
            this.startX = 0
            this.startY = 0
            this.changeX = 0
            this.changeY = 0
            
            // NOTE: this works but occasionally its jumpy, needs a way to smooth out the final jump/transition
        },
        dragStart(eventObj) {
            this.startX = eventObj.clientX
            this.startY = eventObj.clientY
        },
        dragging(eventObj) {
            this.changeX = eventObj.clientX - this.startX
            this.changeY = eventObj.clientY - this.startY
            this.livePositionX = this.savedPositionX + this.changeX
            this.livePositionY = this.savedPositionY + this.changeY
        },
        scroll(eventObj) {
            // two fingers can actually go back
            eventObj.preventDefault()
            console.debug(`eventObj is:`,eventObj)
            this.zoomPercent += eventObj.deltaY * 0.1
        }
    }
}
</script>