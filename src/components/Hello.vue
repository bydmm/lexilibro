<template>
<div>
  <el-row :gutter="10" type="flex" justify="center">
    <el-col :xs="24" :sm="24" :md="10" :lg="10">
      <h1>
        <span v-if="!loading">欢迎使用Simplingua词典</span>
        <span v-if="loading"><i class="el-icon-loading"></i> 词典读取中...</span>
      </h1>
    </el-col>
  </el-row>
  <el-row :gutter="10" type="flex" justify="center" v-if="!loading">
    <el-col :xs="24" :sm="24" :md="10" :lg="10">
      <el-input placeholder="请输入单词" icon="search" v-model="keyword" @keyup.enter.native="search" :on-icon-click="search"></el-input>
    </el-col>
  </el-row>
  <div class="entrys">
    <el-row :gutter="10" type="flex" justify="center" v-for="entry in entrys" :key="entry.simplingua">
      <el-col :xs="24" :sm="24" :md="10" :lg="10">
        <div class="entry">
          <div class="simplingua">
            {{entry.simplingua}}
          </div>
          <div class="explain">
            {{entry.type}}, {{entry.explain}}
          </div>
          <div class="other-info">
            <b>词根:</b> {{entry.root}}
            <b>等级:</b> {{entry.rank}}
          </div>
        </div>
      </el-col>
    </el-row>
  </div>

</div>
</template>

<script>
import filter from 'lodash/filter'

export default {
  data () {
    return {
      keyword: '',
      word: '',
      dictionaries: [],
      loading: true
    }
  },
  computed: {
    entrys () {
      const word = this.word
      if (word.length < 1) return []
      const startWithWord = filter(this.dictionaries, entry => {
        return entry.simplingua && entry.simplingua.match(`^${word}.*`)
      })
      const notStartWithWord = filter(this.dictionaries, entry => {
        return entry.simplingua && entry.simplingua.match(`^[^${word}]${word}.*`)
      })
      const translations = filter(this.dictionaries, entry => {
        return entry.explain && entry.explain.match(`${word}.*`)
      })
      const entrys = startWithWord.concat(notStartWithWord).concat(translations)
      return entrys
    }
  },
  methods: {
    search () {
      console.log('search')
      this.word = this.keyword.toLowerCase()
    },
    loadData () {
      this.$http.get('/static/dictionaries.json').then(response => {
        // success callback
        this.loading = false
        this.dictionaries = response.body.dictionaries
      }, response => {
        // error callback
      })
    }
  },
  created () {
    this.loadData()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.entrys {
  margin-top: 20px;
}
.entry {
  margin-bottom: 10px;
  padding: 10px;
  background-color: #fcfcfc;
  border-radius: 4px;
}
.simplingua {
  font-weight: bold;
}
.explain {
  margin: 10px 0px 4px 0;
}
.other-info {
  margin-top: 10px;
}
.loading {
  margin-bottom: 10px;
}
</style>
