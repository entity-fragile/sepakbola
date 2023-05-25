from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from utils import query
from django.shortcuts import redirect
from django.db import *
from utils.query import map_cursor, query
from django.http import HttpResponse, JsonResponse


from django.db import connection, transaction
from utils.query import map_cursor, query
from authentication.views import get_user_role

import datetime


# Create your views here.
def panitiaDashboard(request):
    if (request.session.get('username') == None):
        return redirect('/authentication/login/')
    if(request.session.get('user_role') != 'panitia'):
        if (request.session.get('user_role') == None):
            return redirect('/authentication/login/')
        return redirect(f'/{request.session.get("user_role")}/')
    
    non_pemain = query(f''' 
SELECT nama_depan, nama_belakang, nomor_hp, email, alamat, string_agg(status, ', ') as status, jabatan
        FROM NON_PEMAIN np join status_non_pemain snp 
        on np.id = snp.id_non_pemain 
        join panitia p on p.id_panitia = np.id
        WHERE username = '{request.session.get("username")}'
        GROUP BY nama_depan, nama_belakang, nomor_hp, email, alamat, jabatan;
        ''')
    print(non_pemain)
    list_rapat = query(f'''
    SELECT r.id_pertandingan, t.nama_tim as tim_a, t2.nama_tim as tim_b,  r.datetime, np1.nama_depan AS p_fname,
    np1.nama_belakang AS p_lname,
    np2.nama_depan AS ma_fname, np2.nama_belakang AS ma_lname,
    np3.nama_depan AS mb_fname, np3.nama_belakang AS mb_lname, r.isi_rapat
    FROM rapat r
    INNER JOIN non_pemain np1 ON np1.id = r.perwakilan_panitia
    INNER JOIN non_pemain np2 ON np2.id = r.manajer_tim_a
    INNER JOIN non_pemain np3 ON np3.id = r.manajer_tim_b
	INNER JOIN tim_manajer t on np2.id = t.id_manajer
	INNER JOIN tim_manajer t2 on np3.id = t2.id_manajer
    WHERE r.datetime > current_timestamp and
    r.perwakilan_panitia = (
        (SELECT id_panitia FROM panitia WHERE username = '{request.session.get("username")}')
    )
        ''')
    print(list_rapat)
    context = {
        "non_pemain": non_pemain,
        "list_rapat": list_rapat
        }   
    
    return render(request, 'panitiaDashboard.html', context)


def startMeeting(request):
    if request.session.get('username') is None:
        return redirect('/login/')

    context = {}

    id_pertandingan = request.POST.get('id')

    if request.method == 'POST':
        tim_bertanding = query(f''' 
            SELECT P.id_pertandingan AS id, TA.nama_tim || ' vs ' || TB.nama_tim AS Teams
            FROM TIM_PERTANDINGAN TA
            INNER JOIN TIM_PERTANDINGAN TB ON TB.id_pertandingan = TA.id_pertandingan AND TA.nama_tim != TB.nama_tim
            INNER JOIN PERTANDINGAN P ON P.id_pertandingan = TA.id_pertandingan
            WHERE P.id_pertandingan = '{id_pertandingan}'
        ''')
        print(tim_bertanding)

    context['tim_bertanding'] = tim_bertanding[0]

    return render(request, 'rapat.html', context)


def mulaiRapat(request):
    id_panitia = query(f"""
        SELECT id_panitia from Panitia where username = '{request.session['username']}'
    """)[0]['id_panitia']

    context = {}
    pertandingan = query(f"""
        SELECT *
        FROM (
            SELECT 
                ROW_NUMBER() OVER(ORDER BY TB.id_pertandingan),
                P.id_pertandingan AS id,
                TA.nama_tim || ' vs ' || TB.nama_tim AS Teams,
                S.nama AS Stadium,
                TO_CHAR(P.Start_Datetime, 'DD Month YYYY') || ' - ' || TO_CHAR(P.Start_Datetime, 'DD Month YYYY') AS Tanggal
            FROM 
                TIM_PERTANDINGAN TA
                INNER JOIN TIM_PERTANDINGAN TB ON TB.id_pertandingan = TA.id_pertandingan AND TA.nama_tim != TB.nama_tim
                INNER JOIN PERTANDINGAN P ON P.id_pertandingan = TA.id_pertandingan
                INNER JOIN STADIUM S ON P.stadium = S.id_stadium
        ) AS LISTPERTANDINGAN
        WHERE MOD(LISTPERTANDINGAN.row_number, 2) = 0;
    """)
    context['list_pertandingan'] = pertandingan
    return render(request, 'rapatPanitia.html', context)

def submitRapat(request):
    if (request.session.get('username') == None):
        return redirect('/login/')
    
    id_pertandingan = request.POST.get('id')

    manajer_tim_a = query(f'''
        SELECT TM.id_manager, 
        FROM TIM_PERTANDINGAN TA, TIM_MANAJER TM
        INNER JOIN TIM_PERTANDINGAN TB ON TB.id_pertandingan = TA.id_pertandingan AND TA.nama_tim != TB.nama_tim
        INNER JOIN PERTANDINGAN P ON P.id_pertandingan = TA.id_pertandingan
        WHERE P.id_pertandingan = '{id_pertandingan}' AND TM.nama_tim = TA.nama_tim;
    ''')

    manajer_tim_b = query(f'''
        SELECT TM.id_manager, 
        FROM TIM_PERTANDINGAN TA, TIM_MANAJER TM
        INNER JOIN TIM_PERTANDINGAN TB ON TB.id_pertandingan = TA.id_pertandingan AND TA.nama_tim != TB.nama_tim
        INNER JOIN PERTANDINGAN P ON P.id_pertandingan = TA.id_pertandingan
        WHERE P.id_pertandingan = '{id_pertandingan}' AND TM.nama_tim = TB.nama_tim;
    ''')

    if (request.method == 'POST'):
        isi_rapat = request.POST.get('isi_rapat')
        current = datetime.datetime.now() 
        response = query(f'''
            INSERT INTO RAPAT (id_pertandingan, datetime, perwakilan_panitia, manajer_tim_a, manajer_tim_b, isi_rapat)
            VALUES ('{id_pertandingan}','{current}', '{request.session.get('id_panitia')}', '{manajer_tim_a}','{manajer_tim_b}','{isi_rapat}')
        ''')
        print(response)

    return HttpResponseRedirect('/panitia/mulaiRapat/')


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


from datetime import datetime

def pembuatanPertandingan(request):
    if request.method == 'POST':
        tanggal = request.POST.get('tanggal')
        request.session["tanggal"]=tanggal
        # print(request.session["tanggal"])

        with connection.cursor() as cursor:
            query = """
                SELECT S.Nama
                FROM Stadium AS S
                WHERE S.ID_Stadium NOT IN (
                    SELECT P.Stadium
                    FROM Pertandingan AS P
                    WHERE DATE %s BETWEEN P.Start_Datetime::date AND P.End_Datetime::date
                )
            """
            cursor.execute(query, [tanggal])
            stadiums = [row[0] for row in cursor.fetchall()]

        context = {'stadiums': stadiums}
        return render(request, 'pembuatanPertandingan.html', context)
    else:
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
    with connection.cursor() as cursor:
        cursor.execute("SELECT ID_Pertandingan, string_agg(Nama_Tim, ' vs. ') AS Teams FROM Tim_Pertandingan GROUP BY ID_Pertandingan;")
        pertandingan_data = cursor.fetchall()

    pertandingan = [{'Teams': row[1]} for row in pertandingan_data]

    return render(request, 'editList.html', {'pertandingan': pertandingan})


def waktuStadium(request):
    return render(request, 'waktuStadium.html') 

from django.shortcuts import render
from django.db import connection

# def pilihWasit(request):
#     return render(request, 'pilihWasit.html')


def pertandinganDuatim(request):
    # tanggal = request.POST.get('tanggal')
    tanggal = request.session["tanggal"]
    # print(request.session["tanggal"])
    # if request.method == 'POST':
    wasit_utama = request.POST.get('wasit_utama')
    wasit_pembantu = request.POST.get('wasit_pembantu')
    wasit_cadangan = request.POST.get('wasit_cadangan')
        
        # Handle form submission and other logic
        
    # else:
        # Execute the query to retrieve referee data
    query = '''
    SELECT w.id_wasit, np.nama_depan, np.nama_belakang
    FROM WASIT w
    LEFT JOIN WASIT_BERTUGAS wb ON w.id_wasit = wb.id_wasit
    LEFT JOIN PERTANDINGAN p ON wb.id_pertandingan = p.id_pertandingan
    LEFT JOIN NON_PEMAIN np ON w.id_wasit = np.id
    WHERE DATE(p.start_datetime) <> %s OR p.start_datetime IS NULL;
    '''

    with connection.cursor() as cursor:
        cursor.execute(query, [tanggal])
        # cursor.execute(query)
        rows = cursor.fetchall()

        # Prepare referee data for rendering in HTML
        referees = [{'id': row[0], 'nama_depan': row[1], 'nama_belakang': row[2]} for row in rows]
        
    query = '''
    SELECT T.nama_tim
    FROM TIM AS T
    WHERE T.nama_tim NOT IN (
        SELECT TP.nama_tim
        FROM TIM_PERTANDINGAN AS TP
        INNER JOIN PERTANDINGAN AS P ON TP.id_pertandingan = P.id_pertandingan
        WHERE DATE(%s) BETWEEN P.start_datetime::date AND P.end_datetime::date);
        '''
    
    with connection.cursor() as cursor:
        cursor.execute(query, [tanggal])
        # cursor.execute(query)
        rows = cursor.fetchall()
    
        nama_tim = []

        # Eksekusi query SQL
        with connection.cursor() as cursor:
            cursor.execute(query, [tanggal])
            rows = cursor.fetchall()

        # Menyimpan nama tim ke dalam list
        for row in rows:
            nama_tim.append({'nama_tim': row[0]})

        # Menampilkan hasil
        print(nama_tim)
        
        
    context = {
    'referees': referees,
    'nama_tim': nama_tim,  # Tambahkan ini
}
        
    return render(request, 'pertandinganDuatim.html', context)