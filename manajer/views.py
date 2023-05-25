from django.shortcuts import render, redirect
from utils.query import query
from django.http.response import HttpResponseRedirect

# Create your views here.
def manajerDashboard(request):
    return render(request, 'manajerDashboard.html')

def pinjamStadium(request):
    id = query(f"""
        SELECT id_manajer from Manajer where username = '{request.session['username']}'
    """)[0]['id_manajer']

    context = {}

    if (request.session.get('username') == None):
        return redirect('/login')
    print(id)

    list_stadium = query(f''' SELECT S.nama AS stadium FROM STADIUM S''')
   
    context['list_stadium'] = list_stadium

    if (request.method == 'POST'):
        pilih_stadium = request.POST.get('pilih_stadium')
        start_date = request.POST.get('start_date')
        end_date = request.POST.get('end_date')

        print(pilih_stadium)
        print(start_date)
        print(end_date)

        id_stadium = query(f'''SELECT ID_Stadium FROM STADIUM WHERE Nama = '{pilih_stadium}'
        ''')[0]['id_stadium']

        response = query(f'''
            INSERT INTO PEMINJAMAN (ID_Manajer, Start_Datetime, End_Datetime, ID_Stadium)
            VALUES ('{id}', '{start_date}','{end_date}','{id_stadium}')
        ''')

        if (isinstance(response, Exception)):
            context = {'message': "Stadium sudah di book pada tanggal tersebut."}
            return render(request, 'pinjamStadium.html', context)
        
        return HttpResponseRedirect('/manajer/listStadium/')
    
    return render(request, 'pinjamStadium.html', context)

def pesanStadium(request):
    return render(request, 'pinjamStadium.html', context)

def listPertandingan(request):
    return render(request, 'listPertandingan.html')

def historyRapat(request):    
    return render(request, 'historyRapat.html',)

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

def listPesanStadium(request):
    id = query(f"""
        SELECT id_manajer FROM Manajer WHERE Username = '{request.session['username']}'
        """)[0]['id_manajer']
    test = query(f"""
        SELECT id_manajer FROM Manajer WHERE Username = '{request.session['username']}'
        """)
    print(test)
    context = {}
    if query(f''' 
        SELECT S.nama AS stadium, CONCAT(TO_CHAR(P.Start_Datetime, 'DD Month YYYY'), ' - ', TO_CHAR(P.End_Datetime, 'DD Month YYYY')) AS Waktu
        FROM PEMINJAMAN P, STADIUM S
        WHERE S.ID_Stadium = P.ID_Stadium
        AND id_manajer = '{id}'
        ''') == []:
            context = {
                'pesan_error': 'Anda belum memesan Stadium'
            }
            return render(request, 'listStadium.html', context)
    pesan = query(f''' 
        SELECT S.nama AS stadium, CONCAT(TO_CHAR(P.Start_Datetime, 'DD Month YYYY'), ' - ', TO_CHAR(P.End_Datetime, 'DD Month YYYY')) AS Waktu
        FROM PEMINJAMAN P, STADIUM S
        WHERE S.ID_Stadium = P.ID_Stadium
        AND id_manajer = '{id}'
    ''')
    context['list_pesan'] = pesan
    return render(request, 'listStadium.html', context)

# pesanStadium --> insert data ke list pemesanan manajer --> pake trigger checking
