from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),  # Página inicial
    path('selecionar-livro/', views.selecionar_livro, name='selecionar_livro'),
    path('livros_pesquisar', views.pesquisar_livros, name='livros_pesquisar'),  # Página de pesquisa de livros
    path('pesquisar_exemplares', views.pesquisar_exemplares, name='exemplares_pesquisar'),  # Página de pesquisa de exemplares
    path('atualizar_livro/<int:idlivro>/', views.atualizar_livro, name='atualizar_livro'),
]