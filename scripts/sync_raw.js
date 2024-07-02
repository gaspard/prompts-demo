/**
 *
 * Install 'xlsx' first:
 *
 * `npm install xlsx`
 *
 * And then run with:
 *
 * `node xlsx_to_files.js "Prompts Master Sheet-demo Code Problem Creation.xlsx"
 *
 * This creates the source files with proper extension in the RAW/[language] folders:
 *
 * ```
 * RAW/ocaml/promp010.ml
 * ...
 * RAW/python/promp012.py
 * ...
 * ```
 *
 */
const XLSX = require('xlsx')
const fs = require('fs')
const path = require('path')
const BASE_FOLDERS = { raw: 'RAW', review: 'REVIEW' }
const TEMPLATES_FOLDERS = {
  raw: 'templates/RAW',
  review: 'templates/REVIEW',
}
const TEMPLATES = { raw: {}, review: {} }

// XLSX HEADERS
const RAW_HEADERS = {
  language: 'Language',
  promptId: 'Prompt ID',
  prompt: 'Prompt',
  definition: 'Problem Definition',
}
const SOL_HEADERS = {
  promptId: 'Prompt ID',
  prompt: 'Prompt',
  solution: 'Solution',
  tests: 'Test Cases',
}

const comment_for = language => comment => {
  switch (language) {
    case 'python':
      return `# ${comment.split('\n').join('\n# ')}`
    case 'ocaml':
      return `(* ${comment.split('\n').join('\n    ')} *)`
    case 'go':
      return `/* ${comment.split('\n').join('\n    ')} */`
    default:
      return `// ${comment.split('\n').join('\n//  ')}`
  }
}

function extension(language) {
  switch (language.toLowerCase()) {
    case 'python':
      return 'py'
    case 'ocaml':
      return 'ml'
    case 'go':
      return 'go'
    default:
      return 'txt'
  }
}

const template_for = (lang, type) =>
  (TEMPLATES[type][lang] ||= fs.readFileSync(
    path.join(TEMPLATES_FOLDERS[type], `${lang}.${extension(lang)}`),
    { encoding: 'utf-8' }
  ))

const writePrompt = reviews => raw => {
  const lang = raw[RAW_HEADERS.language].toLowerCase()
  const comment = comment_for(lang)
  const promptId = raw[RAW_HEADERS.promptId]
  const review = reviews.find(sol => sol[SOL_HEADERS.promptId] === promptId)
  const type = review ? 'review' : 'raw'
  const dir = path.join(BASE_FOLDERS[type], lang)
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true })
  }
  const p = path.join(
    dir,
    `prompt${promptId.toFixed(0).padStart(3, '0')}.${extension(lang)}`
  )
  const def = {
    definition: comment(
      (
        (review && review[SOL_HEADERS.definition]) ||
        raw[RAW_HEADERS.definition]
      ).replace(/\u00A0/g, ' ')
    ),
    prompt: (review ? review[SOL_HEADERS.prompt] : raw[RAW_HEADERS.prompt])
      .replace(/\u00A0/g, ' ')
      .replace('```\n', ''),
    solution: (review ? review[SOL_HEADERS.solution] || '' : '').replace(
      '```\n',
      ''
    ),
    tests: review ? review[SOL_HEADERS.tests] || '' : '',
  }

  console.log(JSON.stringify(review, null, 2))

  const content = Object.keys(def).reduce(
    (acc, k) => acc.replace(comment(`[${k}]`), def[k] || ''),
    template_for(lang, type)
  )
  fs.writeFileSync(p, content)
  console.log(p)
}

async function main() {
  // Parse the list of prompt IDs
  const prompts_path = process.argv[2]
  const reviews_path = process.argv[3]
  const prompts_w = XLSX.readFile(prompts_path)
  const prompts_s = prompts_w.Sheets[prompts_w.SheetNames[0]]
  const prompts = XLSX.utils.sheet_to_json(prompts_s)

  const reviews_w = XLSX.readFile(reviews_path)
  const reviews_s = reviews_w.Sheets[reviews_w.SheetNames[0]]
  const reviews = XLSX.utils.sheet_to_json(reviews_s)

  // Process each prompt ID
  prompts.forEach(writePrompt(reviews))
  // reviews.forEach(writeReviewed(prompts))
}

main().catch(e => console.log(e))
