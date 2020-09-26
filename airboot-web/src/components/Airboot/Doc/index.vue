<template>
  <div>
    <svg-icon icon-class="question" @click="goto"/>
  </div>
</template>

<script>
export default {
  name: 'AirbootDoc',
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
