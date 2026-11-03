" YAML Front-matter (header)
" from: https://habamax.github.io/2019/03/07/vim-markdown-frontmatter.html
unlet b:current_syntax
syntax include @Yaml syntax/yaml.vim
syntax region yamlFrontmatter start=/\%^---$/ end=/^---$/ keepend contains=@Yaml

" Fix some broken highlights with treesitter
" Title
highlight link @text.title markdownH1
" Link text
highlight link @text.reference markdownLinkText
" Link URL
highlight link @text.uri markdownUrl
" Inline code
highlight link @text.literal markdownCode
