from flask_mysqldb import MySQL
from flask import Flask, Response, wrappers
from flask import url_for, session
from flask import render_template, make_response
from flask import request, redirect, url_for, flash,session

app = Flask(__name__)
mysql=MySQL(app)

#conexión a la base de datos

app.config['MYSQL_HOST'] = 'smilecare.clh9o8yzjnjw.us-east-1.rds.amazonaws.com'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Zeecpoeultion9077!'
app.config['MYSQL_DB'] = 'smilecare'

app.secret_key = 'cl1n1c4d3nt4l'

@app.route('/',methods=['POST'])
@app.route('/')
def index ():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM clinicas")
    clinicas = cur.fetchall()

    cur.execute("SELECT * FROM lista_servicios")
    servicios = cur.fetchall()

    if request.method == 'POST':
        nombre = request.form['nombre']
        apellidos = request.form['apellidos']
        telefono = request.form['telefono']
        fecha = request.form['fecha']
        hora = request.form['hora']
        servicio = request.form['servicio']
        sucursal = request.form['sucursal']

        cur = mysql.connection.cursor()
        cur.callproc('registrar_cita', [nombre, apellidos, telefono, fecha, hora, servicio, sucursal])
        validar = (cur.fetchall()[0][0])
        validar = int(validar)
        cur.close()
        mysql.connection.commit()

        if validar == 0:
            flash("El Horario De La Clinica es de 9:00 a 13:00 Horas")
            flash("Y de 15:00 a 19:00 Horas")
            return redirect(url_for('index'))
        elif validar == 1:
            flash("CITA AGENDADA")
            cur = mysql.connection.cursor()
            cur.execute("SELECT MAX(id),`Nombre Medico`,`Apellidos Medico`,`Fecha Cita`,`Hora Cita` FROM tabla_citas")
            datos = cur.fetchall()[0]
            session.pop('datos', None)
            session['datos'] = [datos[0], datos[1], datos[2], datos[3], datos[4]]
            return redirect(url_for('index'))
        elif validar == 2:
            flash("No Hay Personal Disponible En Ese Horario")
            return redirect(url_for('index'))



    return render_template ("index.html",clinicas=clinicas, servicios=servicios)

@app.route('/login')
def login():
    return render_template("login.html")

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

@app.route('/panel', methods=['POST'])
def panel():
    if request.method=='POST':
        correo = request.form['correo']
        password = request.form['password']

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM inicio WHERE Correo=%s AND Contraseña=%s",[correo,password])
        datos = cur.fetchall()

        if bool(datos):
            session['correo']=datos[0][0]
            session['password']=datos[0][1]
            session['clinica']=datos[0][2]
            session['rol'] = datos[0][3]
            session['id'] = datos[0][4]
            session['estatus'] = datos[0][5]
            session['Nombre_empleado'] = datos[0][6]
            session['Apellidos_empleado'] = datos[0][7]

            if session['estatus'] != 'Activo':
                flash("USUARIO NO ACTIVO")
                return redirect(url_for('login'))

            flash("BIENVENIDO")
            return redirect(url_for('iniciopanel'))

        else:
            flash("CORREO O CONTRASEÑA INCORRECTOS")
            return render_template("login.html")

@app.route('/iniciopanel')
def iniciopanel():
    if 'correo' in session:
        return render_template("iniciopanel.html")
    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/empleados')
def empleados():
    if 'correo' in session:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM lista_empleados WHERE Nombre_Clinica=%s",[session['clinica']])
        datos = cur.fetchall()
        return render_template('empleados.html',datos=datos)
    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/buscar_empleado',methods=['POST'])
def buscar_empleado():
    if request.method == 'POST':
        filtro = request.form.get("filtro",False)
        busqueda = request.form.get("buscar",False)
        cur = mysql.connection.cursor()
        cur.callproc('buscar_empleado',[filtro,busqueda,session['clinica']])
        datos = cur.fetchall()
        cur.close()
        mysql.connection.commit()
        return render_template("empleados.html",datos=datos)


@app.route('/editar_empleados/<id>', methods=['POST'])
@app.route('/editar_empleados/<id>')
def editar_empleados(id):
    if 'correo' in session:
        cur = mysql.connection.cursor()
        cur.execute("SELECT nombre,apellidos,correo,telefono,contraseña,estado,id FROM empleados WHERE id=%s",[id])
        datos = cur.fetchall()[0]

        if request.method == 'POST':
            nombre = request.form['nombre']
            apellidos = request.form['apellidos']
            correo = request.form['correo']
            telefono = request.form['telefono']
            estatus = request.form['estatus']
            password = request.form['password']
            id = request.form['id_empleado']

            cur = mysql.connection.cursor()
            cur.callproc('editar_empleado',[nombre,apellidos,correo,telefono,estatus,password,id])
            cur.close()
            mysql.connection.commit()
            flash("DATOS DE EMPLEADO ACTUALIZADO")
            return redirect(url_for('editar_empleados',id=id))

        return render_template('editar_empleados.html',datos=datos)
    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/agregar_empleados')
def agregar_empleados():
    if 'correo' in session:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM roles")
        roles = cur.fetchall()

        cur.execute("SELECT * FROM total_consultorios WHERE Nombre_Clinica=%s",[session['clinica']])
        consultorios = cur.fetchall()
        return render_template('agregar_empleados.html',roles=roles,consultorios=consultorios)
    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/registrar_empleado', methods=['POST'])
def registrar_empleado():
    if 'correo' in session:
        if request.method == 'POST':
            nombre = request.form['nombre']
            apellidos = request.form['apellidos']
            correo = request.form['correo']
            telefono = request.form['telefono']
            rol = request.form['rol']
            consultorio = request.form.get('consultorio','0')
            password = request.form['password']

            cur = mysql.connection.cursor()
            cur.callproc('registrar_empleado',[nombre,apellidos,correo,telefono,rol,consultorio,password,session['clinica']])
            cur.close()
            mysql.connection.commit()
            flash("EMPLEADO REGISTRADO")
            return redirect(url_for('agregar_empleados'))

    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/citas')
def citas():
    if 'correo' in session:

        if session['rol']=="Administrador":
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM tabla_citas")
            datos = cur.fetchall()
        elif session['rol']=="Medico":
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM tabla_citas WHERE `Nombre Medico`=%s AND `Apellidos Medico`=%s",[session['Nombre_empleado'],session['Apellidos_empleado']])
            datos = cur.fetchall()
        else:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM tabla_citas WHERE Sucursal=%s", [session['clinica']])
            datos = cur.fetchall()
        return render_template('citas.html',datos=datos)
    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/buscar_cita',methods=['POST'])
def buscar_cita():
    if request.method == 'POST':
        filtro = request.form.get("filtro",False)
        busqueda = request.form.get("buscar",False)
        cur = mysql.connection.cursor()
        cur.callproc('buscar_cita',[filtro,busqueda,session['clinica']])
        datos = cur.fetchall()
        cur.close()
        mysql.connection.commit()
        return render_template("citas.html",datos=datos)

@app.route('/registrar_pago',methods=['POST'])
def registrar_pago():
    folio = request.form['folio']
    monto = request.form['monto']


    cur = mysql.connection.cursor()
    cur.callproc('registrar_pago', [folio,monto,session['id']])
    cur.close()
    mysql.connection.commit()
    flash("CITA PAGADA")
    return redirect(url_for('citas'))


@app.route('/editar_cita/<id>',methods=['POST'])
@app.route('/editar_cita/<id>')
def editar_cita(id):
    if 'correo' in session:

        if request.method == 'POST':
            nombre = request.form['nombre']
            apellidos = request.form['apellidos']
            telefono = request.form['telefono']
            fecha = request.form['fecha']
            hora= request.form['hora']
            servicio = request.form['servicio']
            sucursal = request.form['sucursal']
            id = request.form['folio']

            cur = mysql.connection.cursor()
            cur.callproc('editar_cita',[nombre,apellidos,telefono,fecha,hora,servicio,sucursal,id])
            validar=(cur.fetchall()[0][0])
            validar=int(validar)
            cur.close()
            mysql.connection.commit()

            if validar==0:
                flash("El Horario De La Clinica es de 9:00 a 13:00 Horas")
                flash("Y de 15:00 a 19:00 Horas")
                return redirect(url_for('editar_cita',id=id))
            elif validar==1:
                flash("CITA RE-AGENDADA")
                return redirect(url_for('editar_cita',id=id))
            elif validar==2:
                flash("No Hay Personal Disponible En Ese Horario")
                return redirect(url_for('editar_cita',id=id))

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM tabla_citas WHERE id=%s",[id])
        datos = cur.fetchall()[0]

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM lista_servicios")
        servicios = cur.fetchall()

        return render_template('editar_cita.html',datos=datos,servicios=servicios)
    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/agendar_cita')
def agendar_cita():
    if 'correo' in session:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM lista_servicios")
        datos = cur.fetchall()
        return render_template('agendar_cita.html',datos=datos)
    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/registrar_cita', methods=['POST'])
def registrar_cita():
    if 'correo' in session:
        if request.method == 'POST':
            nombre = request.form['nombre']
            apellidos = request.form['apellidos']
            telefono = request.form['telefono']
            fecha = request.form['fecha']
            hora= request.form['hora']
            servicio = request.form['servicio']

            cur = mysql.connection.cursor()
            cur.callproc('registrar_cita',[nombre,apellidos,telefono,fecha,hora,servicio,session['clinica']])
            validar=(cur.fetchall()[0][0])
            validar=int(validar)
            cur.close()
            mysql.connection.commit()

            if validar==0:
                flash("El Horario De La Clinica es de 9:00 a 13:00 Horas")
                flash("Y de 15:00 a 19:00 Horas")
                return redirect(url_for('agendar_cita'))
            elif validar==1:
                flash("CITA AGENDADA")
                cur = mysql.connection.cursor()
                cur.execute("SELECT MAX(id),`Nombre Medico`,`Apellidos Medico`,`Fecha Cita`,`Hora Cita` FROM tabla_citas")
                datos = cur.fetchall()[0]
                session.pop('datos', None)
                session['datos'] = [datos[0],datos[1],datos[2],datos[3],datos[4]]
                return redirect(url_for('agendar_cita'))
            elif validar==2:
                flash("No Hay Personal Disponible En Ese Horario")
                return redirect(url_for('agendar_cita'))
    else:
        flash("DEBES INICIAR SESIÓN")
        return redirect(url_for('login'))

@app.route('/cancelar_cita/<id>',methods=['POST'])
@app.route('/cancelar_cita/<id>')
def cancelar_cita(id):
    cur = mysql.connection.cursor()
    cur.callproc('cancelar_cita', [id])
    cur.close()
    mysql.connection.commit()

    flash("CITA CANCELADA")
    return redirect(url_for('citas'))

if __name__ == '__main__':
    app.run(debug=True, port = 8000, host="0.0.0.0")