# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Autores(models.Model):
    idautor = models.IntegerField(db_column='idAutor', primary_key=True)  # Field name made lowercase.
    autor = models.CharField(max_length=45)

    class Meta:
        #managed = False
        db_table = 'autores'


class Categorias(models.Model):
    idcategoria = models.IntegerField(db_column='idCategoria', primary_key=True)  # Field name made lowercase.
    categoria = models.CharField(max_length=45)

    class Meta:
        #managed = False
        db_table = 'categorias'


class Compra(models.Model):
    codigocmpr = models.IntegerField(db_column='codigoCmpr', primary_key=True)  # Field name made lowercase.
    usuario = models.ForeignKey('Usuario', models.DO_NOTHING, db_column='usuario')
    item = models.ForeignKey('Livro', models.DO_NOTHING, db_column='item')
    valor = models.DecimalField(max_digits=10, decimal_places=0)
    vendidopor = models.ForeignKey('Funcionario', models.DO_NOTHING, db_column='vendidoPor')  # Field name made lowercase.

    class Meta:
        #managed = False
        db_table = 'compra'


class Editora(models.Model):
    ideditora = models.IntegerField(primary_key=True)
    nome = models.CharField(max_length=50)
    numero = models.CharField(max_length=20)
    endereco = models.CharField(max_length=100)

    class Meta:
        #managed = False
        db_table = 'editora'


class Emprestimo(models.Model):
    codigoempr = models.IntegerField(db_column='codigoEmpr', primary_key=True)  # Field name made lowercase.
    usuario = models.ForeignKey('Usuario', models.DO_NOTHING, db_column='usuario')
    item = models.ForeignKey('Exemplar', models.DO_NOTHING, db_column='item')
    dataretirada = models.DateField(db_column='dataRetirada')  # Field name made lowercase.
    prazodevol = models.DateField(db_column='prazoDevol')  # Field name made lowercase.
    autorizadopor = models.ForeignKey('Funcionario', models.DO_NOTHING, db_column='autorizadoPor')  # Field name made lowercase.

    class Meta:
        #managed = False
        db_table = 'emprestimo'


class Exemplar(models.Model):
    idexemplar = models.IntegerField(db_column='idExemplar', primary_key=True)  # Field name made lowercase.
    tituloexemplar = models.CharField(max_length=100)
    idlivro = models.ForeignKey('Livro', models.DO_NOTHING, db_column='idlivro')
    quantidade = models.SmallIntegerField()
    disponivel = models.SmallIntegerField()

    class Meta:
        #managed = False
        db_table = 'exemplar'


class Funcionario(models.Model):
    idfuncionario = models.IntegerField(db_column='idFuncionario', primary_key=True)  # Field name made lowercase.
    nome = models.CharField(max_length=255)
    email = models.CharField(max_length=255)
    senha = models.CharField(max_length=32)
    cargo = models.CharField(max_length=45)
    dataingresso = models.DateField(db_column='dataIngresso')  # Field name made lowercase.
    salario = models.DecimalField(max_digits=10, decimal_places=0)

    class Meta:
        #managed = False
        db_table = 'funcionario'


class Livro(models.Model):
    idlivro = models.IntegerField(primary_key=True)
    titulo = models.CharField(max_length=100)
    isbn = models.CharField(max_length=17)
    edicao = models.SmallIntegerField()
    id_editora = models.IntegerField()

    class Meta:
        #managed = False
        db_table = 'livro'


class Livrosinfo(models.Model):
    idinfo = models.AutoField(db_column='idInfo', primary_key=True)  # Field name made lowercase.
    idlivro = models.ForeignKey(Livro, models.DO_NOTHING, db_column='idlivro')
    idcategoria = models.ForeignKey(Categorias, models.DO_NOTHING, db_column='idCategoria')  # Field name made lowercase.
    idautor = models.ForeignKey(Autores, models.DO_NOTHING, db_column='idAutor')  # Field name made lowercase.

    class Meta:
        #managed = False
        db_table = 'livrosInfo'
        unique_together = (('idlivro', 'idcategoria', 'idautor'),)


class Multa(models.Model):
    idmulta = models.IntegerField(db_column='idMulta', primary_key=True)  # Field name made lowercase.
    codigoempr = models.ForeignKey(Emprestimo, models.DO_NOTHING, db_column='codigoEmpr')  # Field name made lowercase.
    valor = models.DecimalField(max_digits=10, decimal_places=0)
    foipaga = models.SmallIntegerField(db_column='foiPaga')  # Field name made lowercase.

    class Meta:
        #managed = False
        db_table = 'multa'


class Recibo(models.Model):
    idrecibo = models.IntegerField(db_column='idRecibo', primary_key=True)  # Field name made lowercase.
    codigocmpr = models.ForeignKey(Compra, models.DO_NOTHING, db_column='codigoCmpr')  # Field name made lowercase.
    datacmpr = models.DateField(db_column='dataCmpr')  # Field name made lowercase.
    nomecomprador = models.CharField(db_column='nomeComprador', max_length=255)  # Field name made lowercase.

    class Meta:
        #managed = False
        db_table = 'recibo'


class Usuario(models.Model):
    username = models.CharField(primary_key=True, max_length=45)
    nome = models.CharField(max_length=255)
    email = models.CharField(max_length=255)
    password = models.CharField(max_length=32)
    matricula = models.CharField(max_length=12, blank=True, null=True)
    isaluno = models.SmallIntegerField(db_column='isAluno')  # Field name made lowercase.
    isprofessor = models.SmallIntegerField(db_column='isProfessor')  # Field name made lowercase.
    isexterno = models.SmallIntegerField(db_column='isExterno')  # Field name made lowercase.

    class Meta:
        #managed = False
        db_table = 'usuario'