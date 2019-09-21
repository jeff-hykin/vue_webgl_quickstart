<template>
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
                cube1: null,
                cube1Data: {
                    t1: [ 0  , 0  ,  0 ],
                    r1: [ 0  , 0  ,  0 ],
                    t2: [ 0  , 0  ,  0 ],
                },
                cube2: null,
                cube2Data: {
                    t1: [ 10 , 10 ,  0 ],
                    r1: [ 0  , 0  ,  0 ],
                    t2: [ 10 , 10 ,  0 ],
                },
                transformations: [],
                frames: 0,
            }
        methods:
            init: ->
                # 
                # setup keybindings
                # 
                window.addEventListener "keydown", (eventObj) => 
                    if eventObj.code == "ArrowLeft"
                        transformations.push(translationMatrix(1,0,0))
                    # else if eventObj.code == "ArrowRight"
                        
                    # else if eventObj.code == "ArrowUp"
                        
                    # else if eventObj.code == "ArrowDown"

                # 
                # setup three JS
                # 
                container = document.body
                height = container.clientHeight || 200
                this.camera = new THREE.PerspectiveCamera(50, container.clientWidth/height) # 70, container.clientWidth/height, 0.01, 10                
                this.camera.position.z = 1
                this.renderer = new THREE.WebGLRenderer({antialias: true})
                this.renderer.setSize(container.clientWidth, height)
                this.controls = new OrbitControls( this.camera, this.renderer.domElement )
                this.scene = new THREE.Scene()
                container.appendChild(this.renderer.domElement)
                window.transformations = this.transformations
                
                # helpers for the cubes
                box = new THREE.BoxGeometry(10, 10, 10)
                material = new THREE.MeshNormalMaterial()
                
                # cube0
                this.cube0 = new THREE.Mesh(box, material)
                this.cube0.matrixAutoUpdate = false
                this.scene.add(this.cube0)
                window.cube0 = this.cube0
                
                # cube1
                this.cube1 = new THREE.Mesh(box, material)
                this.cube1.matrixAutoUpdate = false
                this.scene.add(this.cube1)
                window.cube1 = this.cube1
                window.cube1Data = this.cube1Data
                
                # cube2
                this.cube2 = new THREE.Mesh(box, material)
                this.cube2.matrixAutoUpdate = false
                this.scene.add(this.cube2)
                window.cube2 = this.cube2
                window.cube2Data = this.cube2Data
                
                # sphere
                this.sphere = new THREE.Mesh(new THREE.SphereGeometry( 5, 32, 32 ), material)
                this.sphere.matrixAutoUpdate = false
                this.scene.add(this.sphere)
                window.sphere = this.sphere
                window.sphereData = this.sphereData
                
                # vector
                # this.scene.add(new THREE.ArrowHelper( new THREE.Vector3(...[0.5,0.4,0.6]).normalize(), new THREE.Vector3(...[0,0,0]), 1, 0xffffff ) )
                

            animate: ->
                requestAnimationFrame(this.animate)
                
                # cube2 transforms
                this.transformations.push(translationMatrix(...this.cube2Data.t1))
                this.transformations.push(rotationMatrix(...this.cube2Data.r1))
                this.transformations.push(translationMatrix(...this.cube2Data.t2))
                this.cube2.matrix.set(...multiply(...this.transformations).elements)
                # cube1 transforms
                if true
                    this.transformations.push(translationMatrix(...this.cube1Data.t1))
                    this.transformations.push(rotationMatrix(...this.cube1Data.r1))
                    this.transformations.push(translationMatrix(...this.cube1Data.t2))
                    this.cube1.matrix.set(...multiply(...this.transformations).elements)
                    this.transformations.pop()
                    this.transformations.pop()
                    this.transformations.pop()
                this.transformations.pop()
                this.transformations.pop()
                this.transformations.pop()
                
                
                # this.transformations.push(translationMatrix(-0.1,0,0))
                # this.cube0.matrix.set(...multiply(...this.transformations).elements)
                # this.transformations.pop()
                
                this.renderer.render(this.scene, this.camera)

        mounted: ->
            this.init()
            this.animate()
</script>