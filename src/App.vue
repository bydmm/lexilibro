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
      variance: 0.7,
      x_colors: [
        '#15252d',
        '#768766',
        '#e5db82',
        '#bb9944',
        '#bb6622',
        '#b1200f',
        '#342e3a'
      ],
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
  background: #eee;
}
.bk {
  position: fixed;
}
</style>
