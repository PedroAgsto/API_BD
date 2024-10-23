from django import forms
from .models import Livrosinfo, Livro, Autores, Categorias

class LivrosinfoForm(forms.ModelForm):
    class Meta:
        model = Livrosinfo
        fields = ['idlivro', 'idautor', 'idcategoria']  # Campos para edição
        labels = {'idlivro': 'Livro', 'idautor': 'Autor','idcategoria': 'Categoria'}
        widgets = {'idlivro': forms.Select(),
                   'idautor': forms.Select(),
                   'idcategoria': forms.Select()}

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['idlivro'].queryset = Livro.objects.all()
        self.fields['idautor'].queryset = Autores.objects.all()
        self.fields['idcategoria'].queryset = Categorias.objects.all()