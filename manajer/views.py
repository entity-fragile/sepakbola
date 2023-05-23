from django.shortcuts import render, redirect
from utils.query import query
# Create your views here.
def manajerDashboard(request):
    return render(request, 'manajerDashboard.html')

def listStadium(request):
    return render(request, 'listStadium.html')

def pinjamStadium(request):
    return render(request, 'pinjamStadium.html')

def pesanStadium(request):
    return render(request, 'pesanStadium.html')

def listPertandingan(request):
    list_pertandingan = query(f'''
        SELECT string_agg(TP.Nama_Tim, ' vs ') as vs, S.Nama, P.Start_Datetime, P.End_Datetime
        FROM PERTANDINGAN P, STADIUM S, TIM_PERTANDINGAN TP
        WHERE TP.ID_Pertandingan = P.ID_Pertandingan
        AND S.ID_Stadium = P.Stadium 
        AND P.ID_Pertandingan IN (
            SELECT ID_Pertandingan 
            FROM Tim_Pertandingan 
            WHERE Nama_Tim = '{request.session.get('nama_tim')}')
        GROUP BY P.ID_Pertandingan, S.Nama
        ''')
        
    context = {
        'list_pertandingan': list_pertandingan
        }
    
    return render(request, 'listPertandingan.html', context)

def historyRapat(request):
    id = query(f'''
        SELECT id_manajer from Manajer where username = '{request.session['username']}' ''')[0]['id_manajer']

    list_rapat = query(f''' 
        SELECT string_agg(TP.Nama_Tim, ' vs ') as vs, NP.Nama_Depan, NP.Nama_Belakang, S.Nama, R.Datetime, R.isi_rapat
        FROM RAPAT R, TIM_PERTANDINGAN TP, NON_PEMAIN NP, STADIUM S, PERTANDINGAN P
        WHERE (R.Manajer_Tim_A = '{id}' OR R.Manajer_Tim_B = '{id}')
        AND R.Perwakilan_Panitia = NP.ID
        AND R.ID_Pertandingan = P.ID_Pertandingan
        AND P.Stadium = S.ID_Stadium
        AND TP.ID_Pertandingan = R.ID_Pertandingan
        GROUP BY R.ID_Pertandingan, NP.ID, S.ID_Stadium, R.Datetime, R.isi_rapat
    ''')
    
    context = {
        'list_rapat': list_rapat
    }

    return render(request, 'historyRapat.html',context)

def kelolaTim(request):
    id = query(f"""
        SELECT id_manajer from Manajer where username = '{request.session['username']}'
    """)[0]['id_manajer']
    test = query(f"""
        SELECT id_manajer from Manajer where username = '{request.session['username']}'
    """)
    print(test)
   # handle if nama_tim is null (belum daftar tim)
    if query(f''' SELECT nama_tim FROM TIM_MANAJER WHERE id_manajer = '{id}' ''') == []:
        # create message that says belum daftar tim
        context = {
            'pesan_error': 'Anda belum mendaftarkan tim'
        }
        return render(request, 'registerTim.html', context)
    nama_tim = query(f''' SELECT nama_tim FROM TIM_MANAJER WHERE id_manajer = '{id}' ''')[0]['nama_tim']
    request.session['nama_tim'] = nama_tim
    pemain = query(f"""
        SELECT * from Pemain where nama_tim = '{nama_tim}'
        ORDER BY is_captain desc
    """)
    context = {
        'list_pemain': pemain,
    }
    pelatih = query(f"""
        SELECT id, nama_depan, nama_belakang, nomor_hp,email, alamat, spesialisasi
        FROM NON_PEMAIN NP INNER JOIN SPESIALISASI_PELATIH SP on NP.id = SP.id_pelatih
        WHERE NP.id in (
        SELECT id_pelatih from pelatih
        where nama_tim = '{nama_tim}'
        )  
    """)
    context['list_pelatih'] = pelatih

    return render(request, 'kelolaTim.html', context)

def make_captain(request):
    id_pemain = request.POST['id']
    print(query(f''' UPDATE PEMAIN SET is_captain = true WHERE id_pemain = '{id_pemain}' '''))
    return redirect('/manajer/kelolatim/')

def delete_pemain(request):
    id_pemain = request.POST.get('id')
    print(query(f''' UPDATE PEMAIN SET nama_tim = NULL WHERE id_pemain = '{id_pemain}' '''))
    
    return redirect('/manajer/kelolatim/')

def delete_pelatih(request):
    id_pelatih = request.POST.get('id')
    print(query(f'''UPDATE PELATIH SET nama_tim = NULL WHERE id_pelatih = '{id_pelatih}' '''))
    return redirect('/manajer/kelolatim/')
    
    

def daftarTim(request):
    if (request.session.get('username') == None):
        return redirect('/login/')
    if (request.session.get('nama_tim') != None):
        return redirect('/manajer/tim/')
    if (request.method == 'POST'):
        nama_tim = request.POST.get('nama_tim')
        universitas = request.POST.get('universitas')

        response = query(f''' INSERT INTO TIM (nama_tim, universitas) VALUES ('{nama_tim}', '{universitas}') ''')
        if (isinstance(response, Exception)):
            context = {'message': "Nama tim sudah terdaftar"}
            return render(request, 'registerTim.html', context)
        
        id = query(f'''
            SELECT id_manajer FROM MANAJER WHERE username = '{request.session.get('username')}'
            ''')[0]['id_manajer'] 
        response = query(f'''
            INSERT INTO TIM_MANAJER (id_manajer, nama_tim)
            VALUES ('{id}', '{nama_tim}')
            ''' )
        print(response)
        request.session['nama_tim'] = nama_tim
        return redirect('/manajer/kelolatim/')
    return render(request, 'registerTim.html')

def daftarPemain(request):
    list_pemain = query(f''' SELECT * FROM PEMAIN WHERE nama_tim IS NULL ''')
    context = {'list_pemain': list_pemain}
    if (request.method == 'POST'):
        query(f''' UPDATE PEMAIN SET nama_tim = '{request.session.get('nama_tim')}' WHERE id_pemain = '{request.POST.get('pemain')}' ''')
        return redirect('/manajer/kelolatim/')
    return render(request, 'registerPemain.html', context)


def daftarPelatih(request):
    list_pelatih = query(f''' SELECT p.id_pelatih, nama_depan, nama_belakang, string_agg(spesialisasi, ', ') as sp
    FROM non_pemain np
    JOIN pelatih p ON np.id = p.id_pelatih
    JOIN spesialisasi_pelatih sp ON p.id_pelatih = sp.id_pelatih
    WHERE p.nama_tim IS NULL
    GROUP BY p.id_pelatih, nama_depan, nama_belakang ''')

    context = {'list_pelatih': list_pelatih}
    if (request.method == 'POST'):
        print(request.POST.get('id'))
        response = query(f''' UPDATE PELATIH SET nama_tim = '{request.session.get('nama_tim')}' WHERE id_pelatih = '{request.POST.get('id')}' ''')
        if (isinstance(response, Exception)):
            context['message'] = response.args[0].split("\n")[0]
            return render(request, 'registerPelatih.html', context)
        else: 
            return redirect('/manajer/kelolatim/')
    return render(request, 'registerPelatih.html',context)
