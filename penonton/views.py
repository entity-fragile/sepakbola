from django.shortcuts import render, redirect
from utils.query import query
import random
from django.shortcuts import redirect

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
    list_pertandingan = query(f'''
        SELECT string_agg(TP.Nama_Tim, ' vs ') as vs, S.Nama, P.Start_Datetime, P.End_Datetime
        FROM PERTANDINGAN P, STADIUM S, TIM_PERTANDINGAN TP
        WHERE TP.ID_Pertandingan = P.ID_Pertandingan
        AND S.ID_Stadium = P.Stadium 
        GROUP BY P.ID_Pertandingan, S.Nama
        ''')
    context = {
        'list_pertandingan': list_pertandingan
        }
    
    return render(request, 'listPertandingan.html', context)

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
        'timA': list_tim[0].get('nama_tim'),
        'timB': list_tim[1].get('nama_tim'),
    }

    return render(request,'ticketListPertandingan.html', context)

def beliTiket(request, id):
    nomor_receipt = number_generator()
    id_penonton = query(f'''
        SELECT id_penonton from Penonton where username = '{request.session['username']}' ''')[0]['id_penonton']
    id_pertandingan = id
    jenis_tiket = request.POST.get('jenis_tiket')
    jenis_pembayaran = request.POST.get('jenis_pembayaran')
    
    if request.method == 'POST':
        response = query(f''' INSERT INTO Pembelian_Tiket (Nomor_Receipt, ID_Penonton, Jenis_Tiket, Jenis_Pembayaran, ID_Pertandingan) VALUES ('{nomor_receipt}', '{id_penonton}', '{jenis_tiket}', '{jenis_pembayaran}', '{id_pertandingan}') ''')
            
        if (isinstance(response, Exception)):
            context = {'message': response}
            print(context)
            return render(request, 'beliTiket.html', context)
    
        return redirect('/penonton')
    return render(request,'beliTiket.html')

def number_generator():
    receipt_number = ''.join(random.choice('0123456789') for _ in range(15))
    return receipt_number
