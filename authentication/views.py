from django.shortcuts import render, redirect
# import query.py from utils
from utils.query import query
import uuid
import logging
logger = logging.getLogger("debugger")
# Create your views here.
def login(request):
    
    if 'username' not in request.session:
        return render(request, 'login.html')
    else:
        role = get_user_role(request.session['username'])
        
        if role == 'manajer':
            return redirect('/manajer')
        elif role == 'panitia':
            return redirect('/panitia')
        elif role == 'penonton':
            return redirect('/penonton')
    
        
def post_login(request):
    # form = get_request_body(request)
    # print(form)
    validate = f"""
        SELECT username
        FROM user_system
        WHERE username = '{request.POST.get("username")}' AND password = '{request.POST.get("password")}' 
    """
    response = query(validate)
    if isinstance(response, list) and len(response) > 0:
        role = get_user_role(response[0]['username'])
        request.session['username'] = response[0]['username']
        request.session['user_role'] = role
        
        if role == 'manajer':
            return redirect('/manajer')
        elif role == 'panitia':
            return redirect('/panitia')
        elif role == 'penonton':
            return redirect('/penonton')
    else:
        context = {
            'message': 'Username atau password salah'
        }
        return render(request, 'login.html', context)

def get_user_role(username):
    manajer = query(f"""SELECT * FROM manajer WHERE Username = '{username}'""")
    if len(manajer) > 0: return 'manajer'

    panitia = query(f"""SELECT * FROM panitia WHERE Username = '{username}'""")
    if len(panitia) > 0: return 'panitia'

    penonton = query(f"""SELECT * FROM penonton WHERE Username = '{username}'""")
    if len(penonton) > 0: return 'penonton'

def get_request_body(request):
    res = {}
    for key, value in request.POST.items():
        res[key] = value
    return res


        
def register(request):
    return render(request, 'register.html')

def registerManajer(request):
    return render(request, 'registerManajer.html')

def post_register_manajer(request):
    print("test")
    uid = uuid.uuid4()
    print(uid)
    form = get_request_body(request)
    status = request.POST.getlist('status')
    print(status)
    print(form)
    
    insert_user_system = f"""
        INSERT INTO User_System VALUES
        ('{form['username']}', '{form['password']}')
    """
   
    response = query(insert_user_system)
    

    if isinstance(response, int):
        insert_non_pemain = f"""
        INSERT INTO Non_Pemain VALUES
        ('{uid}', '{form['firstName']}', '{form['lastName']}', '{form['phone_number']}', '{form['email']}', '{form['address']}')
        """
        query(insert_non_pemain)
        insert_manajer = f"""
        INSERT INTO Manajer VALUES
        ('{uid}', '{form['username']}')
        """
        query(insert_manajer)
        for elements in status:
            insert_status_non_pemain = f"""
            INSERT INTO Status_Non_Pemain VALUES
            ('{uid}', '{elements}')
            """
            query(insert_status_non_pemain)
        return redirect('/authentication/login')    
    else:
        print(response)
        context= {
            'messages': response.args[0].split('\n')[0]
        }
        return render(request, 'registerManajer.html', context)




def registerPanitia(request):
    return render(request, 'registerPanitia.html')

def post_register_panitia(request):
    uid = uuid.uuid4()
    form = get_request_body(request)
    status = request.POST.getlist('status')
    insert_user_system = f"""
        INSERT INTO User_System VALUES
        ('{form['username']}', '{form['password']}')
    """
    response = query(insert_user_system)
    print(response)
    if isinstance(response, int):
        insert_non_pemain = f"""
        INSERT INTO Non_Pemain VALUES
        ('{uid}', '{form['firstName']}', '{form['lastName']}', '{form['phone_number']}', '{form['email']}', '{form['address']}')
        """
        query(insert_non_pemain)
        insert_panitia = f"""
        INSERT INTO Panitia VALUES
        ('{uid}', '{form['jabatan']}', '{form['username']}')
        """
        query(insert_panitia)
        for elements in status:
            insert_status_non_pemain = f"""
            INSERT INTO Status_Non_Pemain VALUES
            ('{uid}', '{elements}')
            """
            query(insert_status_non_pemain)
        return redirect('/authentication/login')
    else:
        context= {
            'messages': f"Ussername {form['username']} sudah terdaftar"
        }
        return render(request, 'registerPanitia.html', context)



def registerPenonton(request):
    return render(request, 'registerPenonton.html')

def post_register_penonton(request):
    uid = uuid.uuid4()
    form = get_request_body(request)
    status = request.POST.getlist('status')
    insert_user_system = f"""
        INSERT INTO User_System VALUES
        ('{form['username']}', '{form['password']}')
    """
    response = query(insert_user_system)
    if isinstance(response, int):
        insert_non_pemain = f"""
        INSERT INTO Non_Pemain VALUES
        ('{uid}', '{form['firstName']}', '{form['lastName']}', '{form['phone_number']}', '{form['email']}', '{form['address']}')
        """
        query(insert_non_pemain)
        insert_penonton = f"""
        INSERT INTO Penonton VALUES
        ('{uid}', '{form['username']}')
        """
        query(insert_penonton)
        for elements in status:
            insert_status_non_pemain = f"""
            INSERT INTO Status_Non_Pemain VALUES
            ('{uid}', '{elements}')
            """
            query(insert_status_non_pemain)
        return redirect('/authentication/login')
    else:
        context= {
            'messages': f"Ussername {form['username']} sudah terdaftar"
        }
        return render(request, 'registerPenonton.html', context)
    
def logout(request):
    request.session.flush()
    return redirect('/')