<template>
</template>

<style>
    html {
        overflow: hidden;
    }
</style>

<script lang="coffee">
    import 'css-baseline/css/4.css'
    import * as Three from 'three'
    import * as tools from './utils/matrix.coffee'
    
    export default
        name: 'ThreeTest'
        data: ->
            return {
                camera: null,
                scene: null,
                renderer: null,
                mesh: null,
                rotationX: 0,
                rotationY: 0,
                incrementAmount: 0.01,
            }
        methods:
            init: ->
                # 
                # setup keybindings
                # 
                window.addEventListener "keydown", (e) => 
                    if e.code == "ArrowLeft"
                        this.rotationX -= this.incrementAmount
                    else if e.code == "ArrowRight"
                        this.rotationX += this.incrementAmount
                    else if e.code == "ArrowUp"
                        this.rotationY -= this.incrementAmount
                    else if (e.code == "ArrowDown")
                        this.rotationY += this.incrementAmount

                # 
                # setup three JS
                # 
                container = document.body
                height = container.clientHeight || 200
                
                this.camera = new Three.PerspectiveCamera(70, container.clientWidth/height, 0.01, 10)
                this.camera.position.z = 1

                this.scene = new Three.Scene()

                geometry = new Three.BoxGeometry(0.2, 0.2, 0.2)
                material = new Three.MeshNormalMaterial()

                this.mesh = new Three.Mesh(geometry, material)
                this.scene.add(this.mesh)

                this.renderer = new Three.WebGLRenderer({antialias: true})
                this.renderer.setSize(container.clientWidth, height)
                container.appendChild(this.renderer.domElement)

            animate: ->
                requestAnimationFrame(this.animate)
                # NOTE: these are intentionally switched, for some reason they don't match up
                # (maybe the whole camera-perspective is rotated? not sure)
                this.mesh.rotation.x += this.rotationY
                this.mesh.rotation.y += this.rotationX
                this.renderer.render(this.scene, this.camera)

        mounted: ->
            this.init()
            this.animate()
</script>