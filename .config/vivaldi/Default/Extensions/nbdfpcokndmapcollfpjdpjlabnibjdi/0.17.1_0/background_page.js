!function(t){function e(e){for(var n,a,c=e[0],i=e[1],u=e[2],d=0,b=[];d<c.length;d++)a=c[d],o[a]&&b.push(o[a][0]),o[a]=0;for(n in i)Object.prototype.hasOwnProperty.call(i,n)&&(t[n]=i[n]);for(l&&l(e);b.length;)b.shift()();return s.push.apply(s,u||[]),r()}function r(){for(var t,e=0;e<s.length;e++){for(var r,a=s[e],c=!0,i=1;i<a.length;i++)r=a[i],0!==o[r]&&(c=!1);c&&(s.splice(e--,1),t=n(n.s=a[0]))}return t}function n(e){if(a[e])return a[e].exports;var r=a[e]={i:e,l:!1,exports:{}};return t[e].call(r.exports,r,r.exports,n),r.l=!0,r.exports}var a={},o={1:0},s=[];n.m=t,n.c=a,n.d=function(t,e,r){n.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:r})},n.r=function(t){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},n.t=function(t,e){if(1&e&&(t=n(t)),8&e)return t;if(4&e&&"object"==typeof t&&t&&t.__esModule)return t;var r=Object.create(null);if(n.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var a in t)n.d(r,a,function(e){return t[e]}.bind(null,a));return r},n.n=function(t){var e=t&&t.__esModule?function(){return t.default}:function(){return t};return n.d(e,"a",e),e},n.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},n.p="";var c=window.webpackJsonp=window.webpackJsonp||[],i=c.push.bind(c);c.push=e,c=c.slice();for(var u=0;u<c.length;u++)e(c[u]);var l=i;s.push([21,0]),r()}({1:function(t,e,r){"use strict";function n(t){return u?t.metaKey:t.ctrlKey}function a(t,e){const r={};return t.forEach(t=>{r[t[e]]=t}),r}async function o(t,{getSuggestions:e,threshold:r,keys:n}){const a=await e(t);return new c.a(a,{shouldSort:!0,threshold:r,minMatchCharLength:1,includeMatches:!0,keys:n,distance:500}).search(t).map(({item:t,matches:e,score:r})=>i({},t,{score:r,matches:e}))}r.d(e,"a",function(){return l}),r.d(e,"b",function(){return n}),r.d(e,"d",function(){return a}),r.d(e,"c",function(){return o});var s=r(5),c=r.n(s),i=Object.assign||function(t){for(var e,r=1;r<arguments.length;r++)for(var n in e=arguments[r])Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n]);return t};const u=-1!==navigator.appVersion.indexOf("Mac"),l=u?"⌘":"ctrl"},2:function(t,e,r){"use strict";r.d(e,"a",function(){return o}),r.d(e,"b",function(){return s});const n="rgba(152,78,163,1)",a="rgba(152,78,163,0.44)",o={tab:"rgba(55,126,184,1)",closedTab:"rgba(0,0,0,1)",search:"rgba(77,175,74,1)",history:"rgba(228,26,28,1)",recentlyViewed:n,bookmark:"rgba(255,127,0,1)",mode:n,calculator:"rgba(166,86,40,1)",unknown:"rgba(153,153,153,1)"},s={tab:"rgba(55,126,184,0.44)",closedTab:"rgba(0,0,0,0.44)",search:"rgba(77,175,74,0.44)",history:"rgba(228,26,28,0.44)",recentlyViewed:a,bookmark:"rgba(255,127,0,0.44)",mode:a,calculator:"rgba(166,86,40,0.44)",unknown:"rgba(153,153,153,0.44)"}},21:function(t,e,r){"use strict";async function n(){return(await browser.tabs.query({})).map(({id:t,windowId:e,title:r,url:n,favIconUrl:a,incognito:o,lastAccessed:s})=>({type:"tab",tabId:t,windowId:e,title:r,url:n,favIconUrl:o?null:a,incognito:o,lastAccessed:.001*s}))}async function a(){const t=await n(),e=Object(y.d)(t,"tabId"),{tabHistory:r}=await browser.runtime.getBackgroundPage();return[...r.map(t=>{const r=e[t.tabId];return delete e[t.tabId],g({},r,{lastAccessed:.001*t.lastAccessed})})]}async function o(){const t=await browser.sessions.getRecentlyClosed(),e=[];for(const r of t)if(r.tab&&!await Object(p.c)(r.tab.url))e.push(r);else if(r.window&&r.window.tabs)for(const t of r.window.tabs)t&&!await Object(p.c)(t.url)&&e.push({lastModified:r.window.lastModified,tab:m({},t,{sessionId:r.window.sessionId})});return e.map(t=>{const{lastModified:e}=t,{id:r,sessionId:n,title:a,url:o,favIconUrl:s,incognito:c}=t.tab;return{type:"closedTab",tabId:r,sessionId:n,score:void 0,title:a,url:o,favIconUrl:c?null:s,incognito:c,lastAccessed:e}})}async function s(t){const e=await browser.history.search({text:t}),r=[];for(const t of e){!await Object(p.c)(t.url)&&r.push(t)}return r.map(({url:t,title:e,lastVisitTime:r,visitCount:n,typedCount:a})=>({type:"history",score:n+a,lastAccessed:.001*r,title:e,url:t}))}async function c(t){const e=""===t?{}:t,r=[];return(await browser.bookmarks.search(e)).forEach(({url:t,title:e})=>{const n=Object(p.a)(t);Object(p.d)(t)&&Object(p.b)(n)&&r.push({type:"bookmark",score:-1,title:e,url:t})}),r}function i(t,e){return e.lastAccessed-t.lastAccessed}async function u(t){const e=await s(t);let r=null,n=null;r=await a();const o=(n=await async function(){const{recentlyClosed:t}=await browser.runtime.getBackgroundPage(),e=await browser.sessions.getRecentlyClosed(),r=[];for(const t of e)t.tab&&!await Object(p.c)(t.tab.url)&&r.push(t);return r.map(e=>-1===t.findIndex(t=>t.tabId===e.tab.id)?e:m({},e,{lastModified:t.tab.lastAccessed})).map(t=>{const{lastModified:e}=t,{id:r,sessionId:n,title:a,url:o,favIconUrl:s,incognito:c}=t.tab;return{type:"closedTab",tabId:r,sessionId:n,score:void 0,title:a,url:o,favIconUrl:c?null:s,incognito:c,lastAccessed:e}})}()).filter(t=>r.every(e=>e.url!==t.url)),c=e.filter(t=>[...r,...o].every(e=>e.url!==t.url));return[...r,...o,...c].map(t=>j({},t,{originalType:t.type,type:"recentlyViewed"})).sort(i)}async function l(t){const e=await n(),r=await o(),a=await s(t);return[...e,...Object.values(r),...Object.values(a)].map(t=>j({},t,{originalType:t.type,type:"recentlyViewed"}))}function d(t){const e=A.findIndex(e=>e.tabId===t.tabId);-1!==e&&A.splice(e,1),A.unshift(t)}async function b(t){const e=void 0===t?(await browser.tabs.query({active:!0,currentWindow:!0}))[0]:await browser.tabs.get(t);if(e)if(e.url===browser.runtime.getURL("saka.html")){if(L)try{if(await browser.tabs.get(L))try{await browser.tabs.update(L,{active:!0})}catch(t){}L=void 0}catch(t){}try{await browser.tabs.remove(e.id)}catch(t){}}else try{await browser.tabs.executeScript(e.id,{file:"/toggle_saka.js",runAt:"document_start",matchAboutBlank:!0})}catch(t){try{const e=await browser.tabs.captureVisibleTab();await browser.storage.local.set({screenshot:e})}catch(t){}L=e.id,await browser.tabs.create({url:"/saka.html",index:e.index,active:!1})}else await browser.tabs.create({url:"/saka.html"});const r=await browser.windows.getLastFocused();await browser.windows.update(r.id,{focused:!0})}r.r(e);var f={};r.r(f),r.d(f,"tab",function(){return h}),r.d(f,"closedTab",function(){return k}),r.d(f,"mode",function(){return v.a}),r.d(f,"history",function(){return O}),r.d(f,"bookmark",function(){return I}),r.d(f,"recentlyViewed",function(){return S});r(7);var w=r(12),y=r(1),g=Object.assign||function(t){for(var e,r=1;r<arguments.length;r++)for(var n in e=arguments[r])Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n]);return t},h=async function(t){return""===t?async function(){const t=await n(),e=Object(y.d)(t,"tabId"),{tabHistory:r}=await browser.runtime.getBackgroundPage();return[...r.map(t=>{const r=e[t.tabId];return delete e[t.tabId],g({},r,{lastAccessed:t.lastAccessed})}),...Object.values(e)]}():Object(y.c)(t,{getSuggestions:n,threshold:.5,keys:["title","url"]})},p=r(3),m=Object.assign||function(t){for(var e,r=1;r<arguments.length;r++)for(var n in e=arguments[r])Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n]);return t},k=async function(t){return""===t?o():Object(y.c)(t,{getSuggestions:o,threshold:.5,keys:["title","url"]})},v=r(8),O=async function(t){const{sakaSettings:e}=await browser.storage.sync.get(["sakaSettings"]),r=!e||void 0===e.enableFuzzySearch||e.enableFuzzySearch;return t&&r?Object(y.c)(t,{getSuggestions:s,threshold:1,keys:["title","url"]}):s(t)},I=async function(t){const{sakaSettings:e}=await browser.storage.sync.get(["sakaSettings"]),r=!e||void 0===e.enableFuzzySearch||e.enableFuzzySearch;return t&&r?Object(y.c)(t,{getSuggestions:c,threshold:1,keys:["title","url"]}):c(t)},j=Object.assign||function(t){for(var e,r=1;r<arguments.length;r++)for(var n in e=arguments[r])Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n]);return t},S=async function(t){return""===t?u(t):async function(t){const e=await Object(y.c)(t,{getSuggestions:l,threshold:.5,keys:["title","url"]});return e.filter((t,r)=>e.findIndex(e=>e.url===t.url&&e.title===t.title)===r)}(t)},x=Object.assign||function(t){for(var e,r=1;r<arguments.length;r++)for(var n in e=arguments[r])Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n]);return t};Object(w.a)({sg:async function([t,e]){return f[t](e)},zoom:(t,e)=>browser.tabs.getZoom(e.tab.id),focusTab:(t,e)=>browser.tabs.update(e.tab.id,{active:!0}),activateSuggestion:async function t(e){switch(e.type){case"tab":await browser.tabs.update(e.tabId,{active:!0}),await browser.windows.update(e.windowId,{focused:!0});break;case"closedTab":await browser.sessions.restore(e.sessionId);break;case"bookmark":case"history":await browser.tabs.create({url:e.url});break;case"recentlyViewed":await t(x({},e,{type:e.originalType}));break;default:console.error(`activation not yet implemented for suggestions of type ${e.type}`)}},closeTab:async function(t){await browser.tabs.remove(t.tabId)}},(t,e,r)=>{const n=({tabId:r,newZoomFactor:n})=>{t.tab.id===r&&e("zoom",n)};browser.tabs.onZoomChange.addListener(n),r.onZoomChange=n},(t,e)=>{browser.tabs.onZoomChange.removeListener(e.onZoomChange)});const A=[],C=[],T=t=>(...e)=>{t(...e)};let L;browser.tabs.onActivated.addListener(T(({tabId:t})=>{d({tabId:t,lastAccessed:Date.now()})})),browser.tabs.onRemoved.addListener(T(t=>{const e=A.findIndex(e=>e.tabId===t);A.splice(e,1),function(t){const e=C.findIndex(e=>e.tabId===t.tabId);-1!==e&&C.splice(e,1),C.unshift(t)}({tabId:t,lastAccessed:Date.now()})})),browser.tabs.onReplaced.addListener(T((t,e)=>{const r=A.findIndex(t=>t.tabId===e);A[r]={tabId:t,lastAccessed:Date.now()}})),browser.windows.onFocusChanged.addListener(async t=>{const[e]=await browser.tabs.query({currentWindow:!0,active:!0});e&&e.windowId===t&&d({tabId:e.id,lastAccessed:Date.now()})}),window.tabHistory=A,window.recentlyClosed=C,browser.browserAction.onClicked.addListener(()=>{b()}),browser.commands.onCommand.addListener(t=>{"toggleSaka"===t||"toggleSaka2"===t||"toggleSaka3"===t||"toggleSaka4"===t?b():console.error(`Unknown command: '${t}'`)}),browser.runtime.onMessage.addListener(async(t,e)=>{switch(t.key){case"toggleSaka":b();break;case"closeSaka":await async function(t){await browser.storage.sync.set({searchHistory:[...t]})}(t.searchHistory),async function(t){t&&(t.url===browser.runtime.getURL("saka.html")?await browser.tabs.remove(t.id):await browser.tabs.executeScript(t.id,{file:"/toggle_saka.js",runAt:"document_start",matchAboutBlank:!0}))}(e.tab);break;default:console.error(`Unknown message: '${t}'`)}}),browser.runtime.onMessageExternal.addListener(t=>{"toggleSaka"===t?b():console.error(`Unknown message: '${t}'`)}),browser.contextMenus.create({title:"Saka",contexts:["all"],onclick:()=>b()})},3:function(t,e,r){"use strict";function n(t,e){let r=t;return t.endsWith("/")&&(r=t.substr(0,t.length-1)),!e.startsWith("http://")&&r.startsWith("http://")&&(r=r.substr(7)),r}function a(t){let e;try{e=!!new URL(t)}catch(t){e=!1}return e}function o(t){return t&&t.match(/^\w+:/,"")?t.match(/^\w+:/,"")[0]:""}function s(t){return-1!==i.indexOf(t)}async function c(t){if(void 0!==t){const e=browser.runtime.getURL("saka.html"),r=e.substring(0,e.indexOf("/"));return t.includes(r)}return!1}r.d(e,"e",function(){return n}),r.d(e,"d",function(){return a}),r.d(e,"a",function(){return o}),r.d(e,"b",function(){return s}),r.d(e,"c",function(){return c});const i=["http:","https:","file:","ftp:","about:","chrome:","chrome-extension:","moz-extension:"]},7:function(t,e,r){r(9)},8:function(t,e,r){"use strict";r.d(e,"b",function(){return i});var n=r(1),a=r(2),o=r(5),s=r.n(o),c=Object.assign||function(t){for(var e,r=1;r<arguments.length;r++)for(var n in e=arguments[r])Object.prototype.hasOwnProperty.call(e,n)&&(t[n]=e[n]);return t};const i=[{type:"mode",mode:"tab",label:"Tabs",shortcut:`${n.a}-shift-a`,color:a.a.tab,fadedColor:a.b.tab,icon:"tab"},{type:"mode",mode:"closedTab",label:"Recently Closed Tabs",shortcut:`${n.a}-shift-c`,color:a.a.closedTab,fadedColor:a.b.closedTab,icon:"restore_page"},{type:"mode",label:"Bookmarks",mode:"bookmark",shortcut:`${n.a}-b`,color:a.a.bookmark,fadedColor:a.b.bookmark,icon:"bookmark_border"},{type:"mode",label:"History",mode:"history",shortcut:`${n.a}-shift-e`,color:a.a.history,fadedColor:a.b.history,icon:"history"},{type:"mode",label:"Recently Viewed",mode:"recentlyViewed",shortcut:`${n.a}-shift-x`,color:a.a.recentlyViewed,fadedColor:a.b.recentlyViewed,icon:"timelapse"}],u=new s.a(i,{shouldSort:!0,threshold:1,includeMatches:!0,keys:["label"]});e.a=async function(t){return""===t?i:u.search(t).map(({item:t,matches:e,score:r})=>c({},t,{score:r,matches:e}))}}});