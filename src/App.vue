<template>
  <div class="contianer">
    <div id="js-bk" class="bk"></div>
    <div id="app">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import Trianglify from 'trianglify'

export default {
  name: 'app',
  mounted () {
    const c = Trianglify({
      variance: Math.random(),
      x_colors: 'Oranges',
      cell_size: 140,
      width: window.innerWidth,
      height: window.innerHeight
    }).canvas()
    document.getElementById('js-bk').appendChild(c)
  }
}
</script>

<style>
body {
  margin: 0;
  background: #efefef;
}
.bk {
  position: fixed;
}
</style>
