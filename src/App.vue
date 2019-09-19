<template>
</template>

<style>
    html {
        overflow: hidden;
    }
</style>

<script>
import * as Three from 'three'
import 'css-baseline/css/4.css'

export default {
  name: 'ThreeTest',
  data() {
    return {
      camera: null,
      scene: null,
      renderer: null,
      mesh: null,
      rotationX: 0,
      rotationY: 0,
      incrementAmount: 0.01,
    }
  },
  methods: {
    init: function() {
        // 
        // setup keybindings
        // 
            window.addEventListener("keydown", e => {
                if (e.code == "ArrowLeft") {
                    this.rotationX -= this.incrementAmount
                } else if (e.code == "ArrowRight") {
                    this.rotationX += this.incrementAmount
                } else if (e.code == "ArrowUp") {
                    this.rotationY += this.incrementAmount
                } else if (e.code == "ArrowDown") {
                    this.rotationY -= this.incrementAmount
                }
            })
        // 
        // setup three JS
        // 
            let container = document.body
            let height = container.clientHeight || 200
            
            this.camera = new Three.PerspectiveCamera(70, container.clientWidth/height, 0.01, 10)
            this.camera.position.z = 1

            this.scene = new Three.Scene()

            let geometry = new Three.BoxGeometry(0.2, 0.2, 0.2)
            let material = new Three.MeshNormalMaterial()

            this.mesh = new Three.Mesh(geometry, material)
            this.scene.add(this.mesh)

            this.renderer = new Three.WebGLRenderer({antialias: true})
            this.renderer.setSize(container.clientWidth, height)
            container.appendChild(this.renderer.domElement)

    },
    animate: function() {
        requestAnimationFrame(this.animate)
        // NOTE: these are intentionally switched, for some reason they don't match up
        // (maybe the whole camera-perspective is rotated? not sure)
        this.mesh.rotation.x += this.rotationY
        this.mesh.rotation.y += this.rotationX
        this.renderer.render(this.scene, this.camera)
    }
  },
  mounted() {
      this.init()
      this.animate()
  }
}
</script>