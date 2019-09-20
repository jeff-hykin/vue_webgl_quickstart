const path = require("path")

module.exports = {
    runtimeCompiler: true,

    chainWebpack: config => {
        config
            .entry("app")
            .clear()
            .add("./src/main.coffee")
            .end()
        config.resolve.alias.set("@", path.join(__dirname, "./src"))
    },

    lintOnSave: false
}
