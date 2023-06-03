from django.shortcuts import render, redirect
from utils.query import query
import datetime
from django.http.response import HttpResponseRedirect

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

def mulaiPertandingan(request):
    return render(request, 'mulaiPertandingan.html')

def peristiwa(request):
    return render(request, 'peristiwa.html')

def managePertandingan(request):
    return render(request, 'managePertandingan.html')

def pembuatanPertandingan(request):
    return render(request, 'pembuatanPertandingan.html')

def warningPertandingan(request):
    return render(request, 'warningPertandingan.html')

def daftarPeristiwa(request):
    return render(request, 'daftarPeristiwa.html')

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