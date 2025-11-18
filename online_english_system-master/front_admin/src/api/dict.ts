import axios from 'axios'

// 搜单词和推荐词
export const getDictList = (params: {
    q: string
}) => {
    return axios.get('/dict/suggest' + '?q=' + params.q + '&num=10&doctype=json').then(res => res.data)
}

//翻译
export const getTranslation = (params: {
    q: string
}) => {
    return axios.get('/dict/jsonapi?q=' + params.q).then(res => res.data)
}

//获取单词发音
export const getDictVoice = (params: {
    audio: string
}) => {
    return axios.get('/dict/dictvoice?type=0&audio' + params.audio)
}

