<template>
<div class="hello-page">
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
  <div class="entrys" v-show="entrys.length > 0">
    <el-row :gutter="10" type="flex" justify="center" v-for="entry in entrys" :key="entry.simplingua">
      <el-col :xs="24" :sm="24" :md="10" :lg="10">
        <div class="entry">
          <div class="top">
            <div class="simplingua">
              {{entry.simplingua | capitalize }}
            </div>
            <div class="type">
              <el-tag class="type-tag">{{entry.type}}</el-tag>
              <el-tag class="rank-tag">Rank {{entry.rank}}</el-tag>
            </div>
            <div class="clear"></div>
          </div>
          <ul class="explain">
            <li v-for="explain in enter(entry.explain)">
              {{explain}}
            </li>
          </ul>
          <div class="root">
            {{entry.root}}
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
  <el-row class="footer" :gutter="10" type="flex" justify="center">
    <el-col :xs="24" :sm="24" :md="10" :lg="10">
      <a href="/static/textbook.pdf">课本</a>
      <a href="/static/lexilibro.doc">词典</a>
      <a href="/static/grammar.pdf">语法</a>
      <a href="/static/pronunciation.pdf">拼读</a>
      <a href="https://github.com/simplingua/simplingua.github.io">关于词典</a>
      <a href="https://github.com/bydmm/simplingua-workflow">Alfred Workflow词典插件</a>
    </el-col>
  </el-row>
</div>
</template>

<script>
import filter from 'lodash/filter'
import _includes from 'lodash/includes'

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
      const words = word.split(' ')
      if (words.length > 1) {
        return this.translationWords(words)
      } else {
        return this.translationWord(word)
      }
    }
  },
  methods: {
    translationWords (words) {
      console.log(words)
      return filter(this.dictionaries, entry => {
        return entry.simplingua && _includes(words, entry.simplingua)
      })
    },
    translationWord (word) {
      const startWithWord = this.headMatch(word)
      const notStartWithWord = this.bodyMatch(word)
      const translations = this.translationMatch(word)
      return startWithWord.concat(notStartWithWord).concat(translations)
    },
    accurateMatch (word) {
      this.dictionaries.forEach(function (entry) {
        if (entry.simplingua && entry.simplingua === word) {
          return [entry]
        }
      })
    },
    headMatch (word) {
      return filter(this.dictionaries, entry => {
        return entry.simplingua && entry.simplingua.match(`^${word}.*`)
      })
    },
    bodyMatch (word) {
      return filter(this.dictionaries, entry => {
        return entry.explain && entry.explain.match(`${word}.*`)
      })
    },
    translationMatch (word) {
      return filter(this.dictionaries, entry => {
        return entry.explain && entry.explain.match(`${word}.*`)
      })
    },
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
    },
    enter: function (value) {
      if (!value) return []
      value = value.toString()
      return value.split('\n')
    }
  },
  created () {
    this.loadData()
  },
  filters: {
    capitalize: function (value) {
      if (!value) return ''
      value = value.toString()
      return value.charAt(0).toUpperCase() + value.slice(1)
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.hello-page {
  padding: 0 10px;
}
.clear {
  clear: both;
}
h1 {
  color: #bb6622;
}
.entrys {
  margin-top: 20px;
}
.entry {
  margin-bottom: 10px;
  background-color: rgba(52,46,58, 0.85);
  border-radius: 4px;
}
.entry .top {
  padding: 14px 18px 0px 18px;
  color: #bb6622;
}
.explain {
  margin: 0;
  padding: 10px 10px 10px 38px;
  color: #e5db82;
}
.root {
  padding: 0px 18px 14px 18px;
  color: #768766;
}
.entry .top .simplingua {
  float: left;
  font-weight: bold;
}
.entry .top .type {
  float: right;
}
.other-info {
  margin-top: 10px;
}
.loading {
  margin-bottom: 10px;
}
.type-tag {
  background-color: #342e3a;
}
.rank-tag {
  background-color: #342e3a;
}
.footer {
  margin-top: 10px;
}
.footer a {
  color: #342e3a;
}
</style>
