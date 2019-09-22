<template>
    <div ref="threejsContainer" style="width: 100vw; height: 100vh;"></div>
</template>

<style>
    html {
        overflow: hidden;
    }
    
</style>

<script lang="coffee">
    import 'css-baseline/css/4.css'
    import * as THREE from 'three'
    import OrbitControls from 'three-orbitcontrols'
    import * as math from 'mathjs'
    import { rotationMatrix, multiply, translationMatrix, print} from './utils/matrix.coffee'
    Matrix = THREE.Matrix4
    
    # debugging
    window.math = math
    window.rotationMatrix = rotationMatrix
    window.multiply = multiply
    window.translationMatrix = translationMatrix
    window.print = print
    
    framerate = 60 # fps
    
    # tools 
    newSphere = (_this, location) ->
        sphere = new THREE.Mesh(new THREE.SphereGeometry( 5, 32, 32 ), new THREE.MeshNormalMaterial())
        sphere.translateX(location[0])
        sphere.translateY(location[1])
        sphere.translateZ(location[2])
        _this.scene.add(sphere)
    
    export default
        name: 'ThreeTest'
        data: ->
            return {
                camera: null,
                scene: null,
                renderer: null,
                cube0: null,
                activeObject: null,
                movableObjects: [],
                cube0: null,
                cube1: null,
                cube2: null,
                transformations: [],
                frames: 0,
                translationRate: 3,
                rotationRate: 5, # 5 degrees
            }
        methods:
            init: ->
                # 
                # setup three JS
                # 
                container = this.$refs["threejsContainer"]
                height = container.clientHeight or 200
                this.setupKeybindings()
                this.camera = new THREE.PerspectiveCamera(50, container.clientWidth/height) # 70, container.clientWidth/height, 0.01, 10                
                this.renderer = new THREE.WebGLRenderer({antialias: true})
                this.renderer.setSize(container.clientWidth, height)
                this.controls = new OrbitControls( this.camera, this.renderer.domElement )
                this.scene = new THREE.Scene()
                container.appendChild(this.renderer.domElement)
                window.transformations = this.transformations
                
                # how far back the camera starts
                this.camera.position.z = 70
                
                
                # cube0
                this.cube0 = this.newCube()
                this.activeObject = this.cube0
                
                # cube1
                this.cube1 = this.newCube()
                # how this cube will be positioned relative to cube0
                this.cube1.transformationData = {
                    t1: [  5 ,  5 ,  0 ],
                    r1: [  0 ,  0 ,  0 ],
                    t2: [  5 ,  5 ,  0 ],
                }
                
                # cube2
                this.cube2 = this.newCube()
                # how this cube will be positioned relative to cube1
                this.cube2.transformationData = {
                    t1: [  5 ,  5 ,  0 ],
                    r1: [  0 ,  0 ,  0 ],
                    t2: [  5 ,  5 ,  0 ],
                }
                
                # sphere
                # this.sphere = new THREE.Mesh(new THREE.SphereGeometry( 5, 32, 32 ), new THREE.MeshNormalMaterial())
                # this.sphere.matrixAutoUpdate = false
                # this.scene.add(this.sphere)
                # window.sphere = this.sphere
                # window.sphereData = this.sphereData
                
                # vector
                # this.scene.add(new THREE.ArrowHelper( new THREE.Vector3(...[0.5,0.4,0.6]).normalize(), new THREE.Vector3(...[0,0,0]), 1, 0xffffff ) )
            
            setupKeybindings: ->
                window.addEventListener "keydown", (eventObj) => 
                    # changing the active object by pressing the number buttons
                    match = eventObj.code.match(/Digit(\d+)/)
                    if match
                        activeObject = this.movableObjects[match[1]]
                        if activeObject
                            this.activeObject = activeObject
                    
                    # object controls
                    if this.activeObject and this.activeObject.transformationData
                        objTransform = this.activeObject.transformationData
                        # translation controls
                        if true
                            translationVec = objTransform.t1
                            # forward backwards
                            if eventObj.code == "KeyW"
                                translationVec[2] -= this.translationRate
                            else if eventObj.code == "KeyS"
                                translationVec[2] += this.translationRate
                            # left right
                            else if eventObj.code == "KeyA"
                                translationVec[0] -= this.translationRate
                            else if eventObj.code == "KeyD"
                                translationVec[0] += this.translationRate
                            # up down
                            else if eventObj.code == "KeyR"
                                translationVec[1] += this.translationRate
                            else if eventObj.code == "KeyF"
                                translationVec[1] -= this.translationRate
                        
                        # rotation controls
                        if true
                            rotationVec = objTransform.r1
                            # top-away-from-camera, top-towards-camera 
                            if eventObj.code == "KeyI"
                                rotationVec[0] -= this.rotationRate
                            else if eventObj.code == "KeyK"
                                rotationVec[0] += this.rotationRate
                            # top-towards-left, top-towards-right
                            else if eventObj.code == "KeyU"
                                rotationVec[2] += this.rotationRate
                            else if eventObj.code == "KeyO"
                                rotationVec[2] -= this.rotationRate
                            # left-side-away-from-camera, left-side-towards-camera
                            else if eventObj.code == "KeyJ"
                                rotationVec[1] += this.rotationRate
                            else if eventObj.code == "KeyL"
                                rotationVec[1] -= this.rotationRate
                        
                        console.log 'objTransform =',objTransform
                # else if eventObj.code == "ArrowLeft"
                    # transformations.push(translationMatrix(1,0,0))
                # else if eventObj.code == "ArrowRight"
                # else if eventObj.code == "ArrowUp"
                # else if eventObj.code == "ArrowDown"
            newCube: () ->
                cube = new THREE.Mesh(new THREE.BoxGeometry(10, 10, 10), new THREE.MeshNormalMaterial())
                cube.matrixAutoUpdate = false
                cube.transformationData = {
                    t1: [  0 ,  0 ,  0 ],
                    r1: [  0 ,  0 ,  0 ],
                    t2: [  0 ,  0 ,  0 ],
                }
                this.movableObjects.push(cube)
                this.scene.add(cube)
                if not window.cubes
                    window.cubes = []
                window.cubes.push(cube)
                return cube
            
            do: ({actions, object, attachedActions})->
                # perform matrix manipulations
                for eachAction in actions
                    actionInfo =  [...eachAction]
                    actionName = actionInfo.shift()
                    if actionName == 'translate'
                        this.transformations.unshift(translationMatrix(...actionInfo))
                    else if actionName == 'rotate'
                        this.transformations.unshift(rotationMatrix(...actionInfo))
                    else
                        console.log 'actionName is not recognized, it is',actionName
                
                # move the object
                object.matrix.set(...multiply(...this.transformations).elements)
                
                # do all of the attached actions
                if attachedActions
                    for eachAttachAction in attachedActions
                        eachAttachAction()
                
                # remove the transformations before all of the other actions
                for each in actions
                    this.transformations.shift()

            animate: ->
                # after *framerate* time-interval, ask to render another frame
                if framerate < 60
                    setTimeout( (()=>requestAnimationFrame(this.animate)), 1000 / framerate )
                else
                    requestAnimationFrame(this.animate)
                
                # cube0 transforms
                this.do
                    object: this.cube0
                    actions: [
                        ['translate', ...this.cube0.transformationData.t1],
                        ['rotate'   , ...this.cube0.transformationData.r1],
                        ['translate', ...this.cube0.transformationData.t2],
                    ]
                    # cube1 transforms
                    attachedActions: [
                        => this.do
                            object: this.cube1
                            actions: [
                                ['translate', ...this.cube1.transformationData.t1],
                                ['rotate'   , ...this.cube1.transformationData.r1],
                                ['translate', ...this.cube1.transformationData.t2],
                            ]
                            # cube 2 transformations
                            attachedActions: [
                                => this.do
                                    object: this.cube2
                                    actions: [
                                        ['translate', ...this.cube2.transformationData.t1],
                                        ['rotate'   , ...this.cube2.transformationData.r1],
                                        ['translate', ...this.cube2.transformationData.t2],
                                    ]
                            ]
                    ]

                # render everything
                this.renderer.render(this.scene, this.camera)
                

        mounted: ->
            this.init()
            this.animate()
</script>