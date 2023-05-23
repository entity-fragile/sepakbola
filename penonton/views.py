from django.shortcuts import render, redirect
from utils.query import query

# Create your views here.
def penontonDashboard(request):
    if (request.session.get('username') == None):
        return redirect('/authentication/login/')
    if(request.session.get('user_role') != 'penonton'):
        if (request.session.get('user_role') == None):
            return redirect('/authentication/login/')
        return redirect(f'/{request.session.get("user_role")}/')
    id = query(f''' SELECT id_penonton FROM PENONTON WHERE username = '{request.session.get("username")}' ''')[0]['id_penonton']
    non_pemain = query(f''' 
        SELECT nama_depan, nama_belakang, nomor_hp, email, alamat, string_agg(status, ', ') as status
        FROM NON_PEMAIN np join status_non_pemain snp 
        on np.id = snp.id_non_pemain 
        WHERE id = '{id}'
        GROUP BY nama_depan, nama_belakang, nomor_hp, email, alamat;
        ''')
    pemesanan_tiket = query(f''' 
        SELECT p.ID_Pertandingan, p.Start_Datetime, p.End_Datetime, s.Nama as nama_stadium, string_agg(tb.nama_tim, ' vs. ') as nama_tim, pt.jenis_tiket
        FROM Pembelian_Tiket AS pt INNER JOIN Pertandingan AS p ON 
        pt.id_pertandingan = p.ID_Pertandingan INNER JOIN Stadium AS s ON 
        p.Stadium = s.ID_Stadium 
        join tim_pertandingan tb on tb.id_pertandingan = p.id_pertandingan
        WHERE pt.id_penonton = '{id}' AND
        p.Start_Datetime > NOW()
        GROUP BY p.ID_Pertandingan, p.Start_Datetime, p.End_Datetime, nama_stadium, pt.jenis_tiket
    ''')

    # query select from status_non_pemain

    context = {
        'non_pemain': non_pemain,
        'list_pemesanan_tiket': pemesanan_tiket
        }
    return render(request, 'penontonDashboard.html', context)

def listPertandingan(request):
    return render(request, 'listPertandingan.html')

def pilihStadium(request):
    list_stadium = query(f'''
        SELECT * FROM STADIUM
    ''')
    print(list_stadium)
    context = {
        'list_stadium': list_stadium
    }

    return render(request,'pilihStadium.html', context)

def listWaktu(request, nama, tgl):
    list_waktu = query(f''' 
        SELECT *
        FROM PERTANDINGAN
        WHERE Start_Datetime >= '{tgl} 00:00:00' AND Start_Datetime <= '{tgl} 23:59:59'
    ''')

    print(list_waktu)
    context = {
        'stadium': nama,
        'list_waktu': list_waktu
    }

    return render(request,'listWaktu.html', context)

def tiketListPertandingan(request, id):
    list_tim = query(f'''
        SELECT TP.nama_tim
        FROM TIM_PERTANDINGAN TP
        WHERE TP.ID_Pertandingan = '{id}'
    ''')

    context = {
        'list_tim': list_tim
    }

    return render(request,'ticketListPertandingan.html', context)

def beliTiket(request):
    return render(request,'beliTiket.html')