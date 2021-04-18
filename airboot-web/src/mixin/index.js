// 全局混合的Vue实例
import { mapGetters, mapActions } from 'vuex'

export default {
  data() {
    return {
    }
  },
  computed: {
    // 引入所有vuex的getter，可以直接通过this来调用，属性名前加上$表示全局属性
    ...mapGetters({
      $isAdmin: 'isAdmin'
    })
  },
  methods: {
    // 展开所有vuex的actions，可以直接通过this来调用，方法名前加上$表示全局方法
    ...mapActions({
    }),
    // 深拷贝
    $clone: obj => JSON.parse(JSON.stringify(obj))
  }
}
