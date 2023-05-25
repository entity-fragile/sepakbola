from django.shortcuts import render, redirect
from utils.query import query
import datetime
from django.http.response import HttpResponseRedirect

# Create your views here.
def panitiaDashboard(request):
    return render(request, 'panitiaDashboard.html')

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

def mulaiPertandingan(request):
    return render(request, 'mulaiPertandingan.html')

def peristiwa(request):
    return render(request, 'peristiwa.html')