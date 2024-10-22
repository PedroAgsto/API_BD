from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion

class Migration(migrations.Migration):

 operations = [
    migrations.RunSQL(
        "SELECT * FROM editora;"),

    migrations.RunSQL(
        "SELECT * FROM livro;"),

    migrations.RunSQL(
        "SELECT * FROM exemplar;"),

    migrations.RunSQL(
        "SELECT * FROM usuario;"),

    migrations.RunSQL(
        "SELECT * FROM funcionario;"),

    migrations.RunSQL(
        "SELECT * FROM emprestimo;"),

    migrations.RunSQL(
        "SELECT * FROM compra;"),

    migrations.RunSQL(
        "SELECT * FROM categorias;"),

    migrations.RunSQL(
        "SELECT * FROM autores;"),

    migrations.RunSQL(
        "SELECT * FROM livrosInfo;"),

     migrations.RunSQL(
         "SELECT * FROM reciboInfo;"),

     migrations.RunSQL(
         "SELECT * FROM multaInfo;"),
 ]