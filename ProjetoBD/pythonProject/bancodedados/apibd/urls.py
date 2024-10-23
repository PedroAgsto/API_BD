from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),  # Página inicial
    path('selecionar_livro/', views.selecionar_livro, name='selecionar_livro'),
    path('selecionar_exemplar/', views.selecionar_exemplar, name='selecionar_exemplar'),
    path('livros_pesquisar', views.pesquisar_livros, name='livros_pesquisar'),
    path('exemplares_pesquisar', views.pesquisar_exemplares, name='exemplares_pesquisar'),
    path('listar_livrosinfo/', views.listar_livrosinfo, name='listar_livrosinfo'),
    path('atualizar_livro/<int:idlivro>/', views.atualizar_livro, name='atualizar_livro'),
    path('atualizar_exemplar/<int:idexemplar>/', views.atualizar_exemplar, name='atualizar_exemplar'),
    path('inserir_livro', views.inserir_livro, name='inserir_livro'),
    path('inserir_exemplar', views.inserir_exemplar, name='inserir_exemplar'),
    path('inserir_livrosinfo/', views.inserir_livrosinfo, name='inserir_livrosinfo'),
    path('remover_livro', views.remover_livro, name='remover_livro'),
    path('remover_exemplar/', views.remover_exemplar, name='remover_exemplar'),
    path('remover_livrosinfo/<int:idinfo>/', views.remover_livrosinfo, name='remover_livrosinfo'),
    path('atualizar_livrosinfo/<int:idinfo>/', views.atualizar_livrosinfo, name='atualizar_livrosinfo'),
]