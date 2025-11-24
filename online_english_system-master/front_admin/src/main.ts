import {createApp} from 'vue'
import pinia from "./stores";
import piniaPersist from 'pinia-plugin-persistedstate'

import App from './App.vue'
import router from './router'
import './router/permission'  // 导入路由权限控制
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import 'element-plus/dist/index.css'
import {createPinia} from "pinia";
// import './style.css'

const app = createApp(App)

pinia.use(piniaPersist);
app.use(pinia)
app.use(router)
app.use(ElementPlus, {
  locale: zhCn,
})
app.mount('#app')
