from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.db.models import Q
from .models import Livro, Editora, Exemplar

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

def pesquisar_exemplares(request):
    query = request.GET.get('query', None)
    exemplares = []

    if query:
        exemplares = Exemplar.objects.filter(
            Q(idexemplar__icontains=query) | Q(idlivro__icontains=query)
        )

    return render(request, 'apibd/exemplares_pesquisar.html', {'exemplares': exemplares, 'query': query})

def atualizar_livro(request, idlivro):
    livro = get_object_or_404(Livro, idlivro=idlivro)

    if request.method == 'POST':
        livro.titulo = request.POST.get('titulo')
        livro.isbn = request.POST.get('isbn')
        livro.edicao = request.POST.get('edicao')
        livro.editora = request.POST.get('editora')
        livro.save()
        return redirect(reverse('home'))

    return render(request, 'apibd/atualizar_livro.html', {'livro': livro})