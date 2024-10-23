from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.db.models import Q
from .models import Livro, Editora, Exemplar, Livrosinfo
from .forms import LivrosinfoForm

# Create your views here.
def home(request):
    return render(request, template_name='apibd/home.html', context={})

def selecionar_livro(request):
    livros = Livro.objects.all()  # Pega todos os livros
    return render(request, 'apibd/selecionar_livro.html', {'livros': livros})

def pesquisar_livros(request):
    query = request.GET.get('query', None)
    livros = []

    if query:
        livros = Livro.objects.filter(
            Q(titulo__icontains=query) | Q(idlivro__icontains=query)
        )

    return render(request, 'apibd/livros_pesquisar.html', {'livros': livros, 'query': query})

def atualizar_livro(request, idlivro):
    editoras = Editora.objects.all()
    livro = get_object_or_404(Livro, idlivro=idlivro)

    if request.method == 'POST':
        livro.idlivro = request.POST.get('idlivro')
        livro.titulo = request.POST.get('titulo')
        livro.isbn = request.POST.get('isbn')
        livro.edicao = request.POST.get('edicao')
        livro.ideditora = request.POST.get('ideditora')
        livro.save()
        return render(request, 'apibd/atualizar_livro.html', {'mensagem': 'Livro atualizado com sucesso!'})

    try:
        ideditora = int(livro.ideditora)  # Converte para inteiro
        editora = Editora.objects.get(ideditora=ideditora)
    except Editora.DoesNotExist:
        return render(request, 'atualizar_livro.html', {'error_message': 'Editora não encontrada.', 'editoras': editora})

    return render(request, 'apibd/atualizar_livro.html', {'livro': livro,'editoras': editoras})

def inserir_livro(request):
    editoras = Editora.objects.all()

    if request.method == 'POST':
        idlivro = request.POST.get('idlivro')
        titulo = request.POST.get('titulo')
        isbn = request.POST.get('isbn')
        edicao = request.POST.get('edicao')
        ideditora = request.POST.get('ideditora')

        if not titulo or not isbn or not edicao or not ideditora:
            return render(request, 'criar_livro.html', {'error_message': 'Todos os campos são obrigatórios.', 'editoras': editoras})

        if Livro.objects.filter(idlivro=idlivro).exists():
            return render(request, 'apibd/inserir_livro.html', {'error_message': 'O ID já existe.', 'editoras': editoras})

        try:
            ideditora = int(ideditora)  # Converte para inteiro
            editora = Editora.objects.get(ideditora=ideditora)
        except Editora.DoesNotExist:
            return render(request, 'criar_livro.html', {
                'error_message': 'Editora não encontrada.',
                'editoras': editoras
            })

        novo_livro = Livro.objects.create(
            idlivro=idlivro,
            titulo=titulo,
            isbn=isbn,
            edicao=edicao,
            ideditora=ideditora
        )

        return render(request, 'apibd/inserir_livro.html', {'mensagem': 'Livro criado com sucesso!', 'editoras': editoras})

    return render(request, 'apibd/inserir_livro.html', {'editoras': editoras})

def remover_livro(request):
    if request.method == 'POST':
        idlivro = request.POST.get('idlivro')
        titulo = request.POST.get('titulo')

        if idlivro:
            try:
                livro = Livro.objects.get(idlivro=idlivro)
            except Livro.DoesNotExist:
                return render(request, 'apibd/remover_livro.html', {'mensagem': 'Não existe um livro com esse ID'})

        elif titulo:
            try:
                livro = Livro.objects.get(titulo=titulo)
            except Livro.DoesNotExist:
                return render(request, 'apibd/remover_livro.html', {'mensagem': 'Não existe um livro com esse título'})
        else:
            return render(request, 'apibd/remover_livro.html', {'mensagem': 'Forneça uma informação'})

        livro.delete()

        return render(request, 'apibd/remover_livro.html', {'mensagem': 'Livro Removido'})

    return render(request, 'apibd/remover_livro.html')

def selecionar_exemplar(request):
    exemplares = Exemplar.objects.all()  # Pega todos os exemplares
    return render(request, 'apibd/selecionar_exemplar.html', {'exemplares': exemplares})

def pesquisar_exemplares(request):
    query = request.GET.get('query', None)
    exemplares = []

    if query:
        exemplares = Exemplar.objects.filter(
            Q(tituloexemplar__icontains=query) | Q(idexemplar__icontains=query)
        )

    return render(request, 'apibd/exemplares_pesquisar.html', {'exemplares': exemplares, 'query': query})

def atualizar_exemplar(request, idexemplar):
    livros = Livro.objects.all()
    exemplar = get_object_or_404(Exemplar, idexemplar=idexemplar)

    if request.method == 'POST':
        novo_idexemplar = request.POST.get('idexemplar')  # Captura o novo ID do exemplar
        idlivro = request.POST.get('idlivro')
        tituloexemplar = request.POST.get('tituloexemplar')
        quantidade = request.POST.get('quantidade')

        if novo_idexemplar and int(novo_idexemplar) != exemplar.idexemplar:

            if Exemplar.objects.filter(idexemplar=int(novo_idexemplar)).exists():

                return render(request, 'apibd/atualizar_exemplar.html', {'mensagem': 'Erro: ID do exemplar já existe. A atualização não pode ser realizada.', 'exemplar': exemplar, 'livros': livros})
            else:

                exemplar.idexemplar = int(novo_idexemplar)
        if idlivro:
            exemplar.idlivro_id = idlivro
        if tituloexemplar:
            exemplar.tituloexemplar = tituloexemplar
        if quantidade:
            exemplar.quantidade = int(quantidade)

        #(a lógica para 'disponivel' eh chamada automaticamente no metodo save)
        exemplar.save()

        return render(request, 'apibd/atualizar_exemplar.html', {'mensagem': 'Exemplar atualizado com sucesso!', 'exemplar': exemplar, 'livros': livros})

    return render(request, 'apibd/atualizar_exemplar.html', {'exemplar': exemplar, 'livros': livros})

def inserir_exemplar(request):
    livros = Livro.objects.all()

    if request.method == 'POST':
        idexemplar = request.POST.get('idexemplar')
        idlivro = request.POST.get('idlivro')
        tituloexemplar = request.POST.get('tituloexemplar')
        quantidade = request.POST.get('quantidade')

        novo_exemplar = Exemplar(
            idexemplar=int(idexemplar),
            idlivro_id=int(idlivro),
            tituloexemplar=tituloexemplar,
            quantidade=int(quantidade)
        )

        novo_exemplar.save()

        return render(request, 'apibd/inserir_exemplar.html', {'mensagem': 'Exemplar adicionado com sucesso!', 'livros': livros})

    return render(request, 'apibd/inserir_exemplar.html', {'livros': livros})


def remover_exemplar(request):
    if request.method == 'POST':
        idexemplar = request.POST.get('idexemplar')
        exemplar = get_object_or_404(Exemplar, idexemplar=idexemplar)

        exemplar.delete()

        return render(request, 'apibd/remover_exemplar.html', {'mensagem': f'Exemplar com ID {idexemplar} foi removido com sucesso!'})

    exemplares = Exemplar.objects.all()

    return render(request, 'apibd/remover_exemplar.html', {'exemplares': exemplares})

def listar_livrosinfo(request):
    livrosinfo = Livrosinfo.objects.select_related('idlivro', 'idautor', 'idcategoria').all()

    return render(request, 'apibd/listar_livrosinfo.html', {'livrosinfo': livrosinfo})


def atualizar_livrosinfo(request, idinfo):
    livrosinfo = get_object_or_404(Livrosinfo, idinfo=idinfo)

    if request.method == 'POST':
        form = LivrosinfoForm(request.POST, instance=livrosinfo)

        if form.is_valid():
            form.save()
            return redirect('listar_livrosinfo')
    else:
        form = LivrosinfoForm(instance=livrosinfo)

    return render(request, 'apibd/atualizar_livrosinfo.html', {'form': form})

def remover_livrosinfo(request, idinfo):
    info = get_object_or_404(Livrosinfo, idinfo=idinfo)

    if request.method == 'POST':
        info.delete()
        return redirect('listar_livrosinfo')

    return render(request, 'apibd/remover_livrosinfo.html', {'info': info})

def inserir_livrosinfo(request):
    if request.method == 'POST':
        form = LivrosinfoForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('listar_livrosinfo')
    else:
        form = LivrosinfoForm()

    return render(request, 'apibd/inserir_livrosinfo.html', {'form': form})