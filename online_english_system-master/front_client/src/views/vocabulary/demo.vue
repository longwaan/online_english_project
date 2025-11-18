<template>
  <div>
    <button @click="fetchAndParseData">获取并解析数据</button>
    <ul>
      <li v-for="(item, index) in wordData.pic_dict" :key="index">
        <img :src="item.url" alt="" width="100" height="100">
      </li>
    </ul>
  </div>
</template>

<script setup>
import {ref} from 'vue';
import {getTranslation} from "@/api/dict.js"

const parsedData = ref([]);
const wordData=ref({
  pic_dict:[],
  collins:{},
  word_videos:[],
  individual:{},
  rel_word:{},
  expand_ec:[]
})
const fetchAndParseData = async () => {
  // 模拟接口请求，实际使用时请替换为真实的请求
  const res = await getTranslation({q: 'teach'})
  //单词图片
  wordData.value.pic_dict = res.pic_dict.pic
  wordData.value.collins = res.collins
  wordData.value.word_videos = res.word_video.word_videos
  wordData.value.individual = res.individual
  wordData.value.rel_word = res.rel_word
  wordData.value.expand_ec = res.expand_ec.word
  console.log(wordData.value)
  console.log("图片字典:", wordData.value.pic_dict);
  console.log("柯林斯词典:", wordData.value.collins);
  console.log("教学视频:", wordData.value.word_videos);
  console.log("个人词汇:", wordData.value.individual);
  console.log("相关词汇:", wordData.value.rel_word);
  console.log("扩展词汇:", wordData.value.expand_ec);
};
</script>