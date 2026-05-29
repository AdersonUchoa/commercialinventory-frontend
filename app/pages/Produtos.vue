<template>
  <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 max-w-6xl mx-auto mt-6 relative">
    
    <div class="flex items-center justify-between mb-8 border-b pb-4">
      <h1 class="text-2xl font-bold text-[#714B67]">Gestão de Produtos</h1>
      <Button variant="primary" @click="abrirModalCriacao">
        + Novo Produto
      </Button>
    </div>

    <Alert :message="mensagemErro" type="error" />

    <Filter @search="aplicarFiltros" @clear="limparFiltros">
      <Input 
        v-model="filtros.searchName" 
        placeholder="Busque pelo nome..." 
      />
      
      <div>
        <select 
          v-model="filtros.categoriaId" 
          class="w-full border border-gray-300 rounded-lg p-2.5 focus:outline-none focus:ring-2 focus:ring-[#017E84]/50 focus:border-[#017E84] bg-white transition-shadow"
        >
          <option value="">Todas as categorias</option>
          <option v-for="cat in categorias" :key="cat.id" :value="cat.id">
            {{ cat.nome }}
          </option>
        </select>
      </div>
    </Filter>

    <Table :columns="tableColumns" :items="produtos">
      <template #col-id="{ item }">
        <span class="bg-gray-100 text-gray-600 font-mono text-xs px-2 py-1 rounded">{{ item.id }}</span>
      </template>

      <template #col-categoria="{ item }">
        <span v-if="item.categoria" class="px-2 py-1 bg-[#017E84]/10 text-[#017E84] rounded-md text-sm font-medium">
          {{ item.categoria.nome }}
        </span>
        <span v-else class="text-gray-400 text-sm">—</span>
      </template>

      <template #col-preco="{ item }">
        <span class="text-gray-700 font-semibold">
          {{ item.preco ? new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(Number(item.preco)) : '—' }}
        </span>
      </template>

      <template #col-acoes="{ item }">
        <div class="space-x-1 flex justify-center opacity-0 group-hover:opacity-100 transition-opacity">
          <Button variant="text-blue" @click="prepararEdicao(item)">Editar</Button>
          <Button variant="text-red" @click="solicitarExclusao(item.id)">Excluir</Button>
        </div>
      </template>

      <template #empty>
        <svg class="mx-auto h-12 w-12 text-gray-300 mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
        </svg>
        Nenhum produto encontrado.
      </template>
    </Table>

    <Pagination 
      :current-page="paginacao.pageIndex"
      :total-pages="paginacao.totalPages"
      :total-count="paginacao.totalCount"
      :page-size="paginacao.pageSize"
      @page-change="mudarPagina"
    />

    <Modal :isOpen="modalFormAberto" @close="fecharModalForm">
      <h2 class="text-xl font-bold text-[#714B67] mb-6 border-b pb-2">
        {{ editandoId ? 'Editar Produto' : 'Novo Produto' }}
      </h2>
      <form @submit.prevent="salvarProduto">
        <div class="space-y-4 mb-8">
          <Input v-model="form.nome" label="Nome do Produto *" placeholder="Mínimo 5 caracteres" />
          <Input v-model="form.descricao" label="Descrição" placeholder="Opcional" />
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium mb-1 text-gray-700">Categoria *</label>
              <select v-model="form.categoriaId" class="w-full border border-gray-300 rounded-lg p-2.5 focus:outline-none focus:ring-2 focus:ring-[#017E84]/50 focus:border-[#017E84] bg-white transition-shadow">
                <option value="" disabled>Selecione...</option>
                <option v-for="cat in categorias" :key="cat.id" :value="cat.id">{{ cat.nome }}</option>
              </select>
            </div>
            
            <Input 
              :modelValue="form.precoVisual" 
              @update:modelValue="aplicarMascaraPreco" 
              type="text" 
              label="Preço" 
              placeholder="R$ 0,00" 
            />
          </div>
        </div>
        <div class="flex justify-end gap-3 pt-4 border-t border-gray-100 mt-2">
          <Button variant="secondary" @click="fecharModalForm">Cancelar</Button>
          <Button type="submit" variant="primary" :disabled="!formularioValido">{{ editandoId ? 'Atualizar' : 'Salvar' }}</Button>
        </div>
      </form>
    </Modal>

    <Modal :isOpen="modalDeleteAberto" @close="modalDeleteAberto = false">
       <div class="text-center py-4">
          <div class="mx-auto flex items-center justify-center h-14 w-14 rounded-full bg-red-100 mb-4">
            <svg class="h-8 w-8 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2">Excluir Produto</h3>
          <p class="text-gray-500 mb-8">Tem certeza que deseja excluir? Esta ação não pode ser desfeita.</p>
          <div class="flex justify-center gap-3">
            <Button variant="secondary" @click="modalDeleteAberto = false">Cancelar</Button>
            <Button variant="danger" @click="confirmarExclusao">Sim, Excluir</Button>
          </div>
       </div>
    </Modal>

  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRuntimeConfig } from '#app'

const config = useRuntimeConfig()
const apiBase = config.public.apiBase

const tableColumns = [
  { key: 'id', label: 'ID', align: 'center', width: 'w-20' },
  { key: 'nome', label: 'Nome' },
  { key: 'descricao', label: 'Descrição' },
  { key: 'categoria', label: 'Categoria' },
  { key: 'preco', label: 'Preço', align: 'right' },
  { key: 'acoes', label: 'Ações', align: 'center', width: 'w-40' }
]

const produtos = ref([])
const categorias = ref([])

const form = reactive({ nome: '', descricao: '', preco: null, precoVisual: '', categoriaId: '' })
const filtros = reactive({ searchName: '', categoriaId: '' })
const editandoId = ref(null)
const mensagemErro = ref('')

const modalFormAberto = ref(false)
const modalDeleteAberto = ref(false)
const idParaExcluir = ref(null)

const paginacao = reactive({
  pageIndex: 1,
  totalPages: 1,
  totalCount: 0,
  pageSize: 10
})

const formularioValido = computed(() => form.nome && form.nome.length >= 5 && form.categoriaId !== '')

const aplicarMascaraPreco = (valorDigitado) => {
  if (!valorDigitado) {
    form.preco = null
    form.precoVisual = ''
    return
  }
  const apenasNumeros = valorDigitado.toString().replace(/\D/g, '')
  if (!apenasNumeros) return

  const valorReal = parseInt(apenasNumeros, 10) / 100
  form.preco = valorReal 
  form.precoVisual = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(valorReal)
}

const carregarDados = async (page = 1) => {
  try {
    paginacao.pageIndex = page
    let url = `${apiBase}/produtos?Page=${page}&Limit=${paginacao.pageSize}`
    
    if (filtros.searchName) url += `&searchName=${encodeURIComponent(filtros.searchName)}`
    if (filtros.categoriaId) url += `&categoriaId=${filtros.categoriaId}`

    const [resProdutos, resCategorias] = await Promise.all([
      $fetch(url),
      $fetch(`${apiBase}/categorias?Limit=100`)
    ])
    
    produtos.value = resProdutos.data?.items || []
    paginacao.totalCount = resProdutos.data?.totalCount || 0
    paginacao.totalPages = resProdutos.data?.totalPages || 1
    categorias.value = resCategorias.data?.items || []
  } catch (error) {
    console.error("Erro ao carregar dados", error)
  }
}

const aplicarFiltros = () => carregarDados(1)
const limparFiltros = () => {
  filtros.searchName = ''
  filtros.categoriaId = ''
  carregarDados(1)
}
const mudarPagina = (novaPagina) => carregarDados(novaPagina)

const abrirModalCriacao = () => {
  editandoId.value = null
  form.nome = ''
  form.descricao = ''
  form.preco = null
  form.precoVisual = '' 
  form.categoriaId = ''
  mensagemErro.value = ''
  modalFormAberto.value = true
}

const prepararEdicao = (produto) => {
  editandoId.value = produto.id
  form.nome = produto.nome
  form.descricao = produto.descricao || ''
  form.categoriaId = produto.categoria?.id || produto.categoriaId || ''
  
  form.preco = produto.preco || null
  form.precoVisual = produto.preco ? new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(produto.preco) : ''
  
  mensagemErro.value = ''
  modalFormAberto.value = true
}

const fecharModalForm = () => modalFormAberto.value = false

const salvarProduto = async () => {
  mensagemErro.value = ''
  try {
    const payload = { ...form, categoriaId: Number(form.categoriaId), preco: form.preco ? Number(form.preco) : null }

    if (editandoId.value) {
      await $fetch(`${apiBase}/produtos/${editandoId.value}`, { method: 'PUT', body: { id: editandoId.value, ...payload } })
      carregarDados(paginacao.pageIndex)
    } else {
      await $fetch(`${apiBase}/produtos`, { method: 'POST', body: payload })
      carregarDados(1)
    }
    fecharModalForm()
  } catch (error) {
    mensagemErro.value = "Erro ao salvar os dados."
  }
}

const solicitarExclusao = (id) => {
  idParaExcluir.value = id
  modalDeleteAberto.value = true
}

const confirmarExclusao = async () => {
  modalDeleteAberto.value = false
  mensagemErro.value = ''
  try {
    await $fetch(`${apiBase}/produtos/${idParaExcluir.value}`, { method: 'DELETE' })
    carregarDados(paginacao.pageIndex)
  } catch (error) {
    mensagemErro.value = "Erro inesperado ao excluir o produto."
  }
}

onMounted(() => carregarDados())
</script>