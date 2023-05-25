from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from utils import query
from django.shortcuts import redirect
from django.db import *
from utils.query import map_cursor, query
from django.http import HttpResponse, JsonResponse


from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from utils import query
from django.shortcuts import redirect
from django.db import connection, transaction
from utils.query import map_cursor, query
from django.http import HttpResponse, JsonResponse
from authentication.views import get_user_role


# Create your views here.
def panitiaDashboard(request):
    return render(request, 'panitiaDashboard.html')


def rapatPanitia(request):
    return render(request, 'rapatPanitia.html')


def mulaiRapat(request):
    return render(request, 'rapat.html')


# rani
@transaction.atomic
def mulaiPertandingan(request):
    # if "username" not in request.session:
    #     return render(request, 'login.html')
    # user_role = get_user_role(request.session['username'])
    # if user_role == 'panitia':
    if request.method == 'GET':
        id_pertandingan = request.GET.get('pertandingan_id')
        try:
            query_result = query(
                f"""
                SELECT nama_tim
                FROM tim_pertandingan
                WHERE id_pertandingan='{id_pertandingan}';
                """
            )
            list_nama_tim = []
            for book in query_result:
                list_nama_tim.append(book['nama_tim'])
            print(list_nama_tim)
            response = {
                'list_nama_tim': list_nama_tim,
                'id_pertandingan': id_pertandingan
            }
        except Exception as e:
            print(e)

        return render(request, 'mulaiPertandingan.html', response)


# check lagi deh ini
def peristiwa(request):
    if request.method == 'GET':
        id_pertandingan = request.GET.get('id_pertandingan')
        nama_tim = request.GET.get('nama_tim')
        print(id_pertandingan)
        print(nama_tim)
        list_peristiwa = query(
            f"""
            SELECT peristiwa.id_pertandingan, peristiwa.datetime, peristiwa.jenis, peristiwa.id_pemain
            FROM peristiwa, pemain
            WHERE peristiwa.id_pertandingan = '{id_pertandingan}'
              and peristiwa.id_pemain = pemain.id_pemain and pemain.nama_tim = '{nama_tim}'
            """
        )
        for peristiwa in list_peristiwa:
            query_nama_pemain = query(
                f"""
                SELECT nama_depan, nama_belakang
                FROM pemain
                WHERE id_pemain = '{peristiwa['id_pemain']}'
                """
            )
            nama_pemain = query_nama_pemain[0]['nama_depan'] + ' ' + query_nama_pemain[0]['nama_belakang']
            peristiwa['nama_pemain'] = nama_pemain
            print(nama_pemain)
        response = {
            'id_pertandingan': id_pertandingan,
            'nama_tim': nama_tim,
            'list_peristiwa': list_peristiwa
        }
        print(response)
        return render(request, 'peristiwa.html', response)


def managePertandingan(request):
    if request.method == 'GET':
        list_pertandingan = query(
            """
            SELECT *
            FROM pertandingan
            """
        )
        print(list_pertandingan)
        for pertandingan in list_pertandingan:
            id_pertandingan = pertandingan['id_pertandingan']
            list_tim = query(
                f"""
                SELECT nama_tim
                FROM tim_pertandingan
                WHERE id_pertandingan = '{id_pertandingan}'
                """
            )
            tim0 = list_tim[0]['nama_tim']
            tim1 = list_tim[1]['nama_tim']
            tim_lawan_tim = tim0 + ' vs ' + tim1
            pertandingan['tim0'] = tim0
            pertandingan['tim1'] = tim1
            pertandingan['tim_lawan_tim'] = tim_lawan_tim
            peristiwa = query(
                f"""
                SELECT *
                FROM peristiwa
                WHERE id_pertandingan = '{id_pertandingan}'
                """
            )
            if peristiwa:
                pertandingan['done'] = True
            else:
                pertandingan['done'] = False

        response = {
            'list_pertandingan': list_pertandingan,
        }
        print(response)
    return render(request, 'managePertandingan.html', response)


def pembuatanPertandingan(request):
    return render(request, 'pembuatanPertandingan.html')


def warningPertandingan(request):
    return render(request, 'warningPertandingan.html')


# rani
@transaction.atomic
def daftarPeristiwa(request):
    print("masuk daftar peristiwa")
    if request.method == 'GET':
        id_pertandingan = request.GET.get('id_pertandingan')
        nama_tim = request.GET.get('nama_tim')
        list_pemain_query = query(
            f"""
            SELECT id_pemain, nama_depan, nama_belakang
            FROM pemain
            WHERE nama_tim = '{nama_tim}';
            """
        )
        print(list_pemain_query)
        counter = [str(i) for i in range(5)]
        response = {
            'list_pemain_query': list_pemain_query,
            'counter': counter,
            'id_pertandingan': id_pertandingan,
            'nama_tim': nama_tim
        }
        return render(request, 'daftarPeristiwa.html', response)

    if request.method == "POST":
        print(request.POST)
        id_pertandingan = request.POST.get('id_pertandingan')
        nama_tim = request.POST.get('nama_tim')
        try:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    DELETE FROM peristiwa
                    WHERE (peristiwa.id_pertandingan, peristiwa.datetime, peristiwa.jenis, peristiwa.id_pemain) in (
                        SELECT peristiwa.id_pertandingan, peristiwa.datetime, peristiwa.jenis, peristiwa.id_pemain
                        FROM peristiwa, pemain
                        WHERE peristiwa.id_pertandingan = %s
                          and peristiwa.id_pemain = pemain.id_pemain and pemain.nama_tim = %s
                        )
                    """,
                    [id_pertandingan, nama_tim]
                )
                cursor.close()
        except Exception as e:
            print(e)
        for i in range(5):
            id_pemain = request.POST.get(f"nama_pemain{i}")
            peristiwa = request.POST.get(f"peristiwa{i}")
            waktu = request.POST.get(f"waktu{i}")
            if not id_pemain or not peristiwa or not waktu:
                continue
            try:
                with connection.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO peristiwa VALUES (%s, %s, %s, %s)",
                        [id_pertandingan, waktu, peristiwa, id_pemain]
                    )
                    cursor.close()
            except Exception as e:
                print(e)

            print(f"Succesfully added {id_pertandingan}, {waktu}, {peristiwa}, {id_pemain}")
        try:
            query_result = query(
                f"""
                SELECT nama_tim
                FROM tim_pertandingan
                WHERE id_pertandingan='{id_pertandingan}';
                """
            )
            list_nama_tim = []
            for book in query_result:
                list_nama_tim.append(book['nama_tim'])
        except Exception as e:
            print(e)

        response = {
            'list_nama_tim': list_nama_tim,
            'id_pertandingan': id_pertandingan,
        }
    return render(request, 'mulaiPertandingan.html', response)


def updatePertandingan(request):
    return render(request, 'updatePertandingan.html')


def akhirMusim(request):
    return render(request, 'akhirMusim.html')


def editList(request):
    return render(request, 'editList.html')


def waktuStadium(request):
    return render(request, 'waktuStadium.html')


def pertandinganDuatim(request):
    return render(request, 'pertandinganDuatim.html')