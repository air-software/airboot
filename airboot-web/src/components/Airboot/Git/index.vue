<template>
  <div>
    <svg-icon icon-class="github" @click="goto"/>
  </div>
</template>

<script>
export default {
  name: 'AirbootGit',
  data() {
    return {
      url: 'https://gitee.com/air-soft/airboot'
    }
  },
  methods: {
    goto() {
      window.open(this.url)
    }
  }
}
</script>
