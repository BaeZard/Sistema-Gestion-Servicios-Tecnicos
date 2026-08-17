using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SIGEM
{
    public partial class Principal : Form
    {
        private readonly string rolUsuario;
        private readonly string usuario;

        public Principal(string rol, string usr)
        {
            InitializeComponent();
            rolUsuario = rol;
            usuario = usr;
            this.Load += Principal_Load;
            cboTabla.SelectedIndexChanged += cboTabla_SelectedIndexChanged;
        }

        private string ObtenerCadenaConexion()
        {
            return ConfigurationManager.ConnectionStrings["ServicioTecnico"].ConnectionString;
        }

        private void cboTabla_SelectedIndexChanged(object sender, EventArgs e)
        {
            string tabla = cboTabla.SelectedItem?.ToString();
            if (!string.IsNullOrEmpty(tabla))
            {
                ConfigurarCampos(tabla);
                CargarTabla(tabla);
            }
        }

        private void Principal_Load(object sender, EventArgs e)
        {
            cboTabla.Items.Clear();

            if (rolUsuario == "Administrador")
            {
                cboTabla.Items.AddRange(new string[] {
            "Cliente","Tecnico","Equipo","Servicio","Repuesto","OrdenServicio"
        });
            }
            else if (rolUsuario == "Tecnico")
            {
                cboTabla.Items.AddRange(new string[] {
            "Servicio","Repuesto","OrdenServicio"
        });
            }
            else if (rolUsuario == "Recepcionista")
            {
                cboTabla.Items.AddRange(new string[] {
            "Cliente","Equipo","OrdenServicio"
        });
            }

            if (rolUsuario == "Administrador")
            {
                btnInsertar.Visible = true;
                btnActualizar.Visible = true;
                btnEliminar.Visible = true;
                btnBuscar.Visible = true;
            }
            else if (rolUsuario == "Recepcionista")
            {
                btnInsertar.Visible = true;
                btnActualizar.Visible = true;
                btnEliminar.Visible = false;
                btnBuscar.Visible = true;
            }
            else if (rolUsuario == "Tecnico")
            {
                btnInsertar.Visible = false;
                btnActualizar.Visible = false;
                btnEliminar.Visible = false;
                btnBuscar.Visible = true;
            }
        }

        private void CargarTabla(string tabla)
        {
            DataTable dt = new DataTable();
            using (SqlConnection cn = new SqlConnection(ObtenerCadenaConexion()))
            {
                SqlCommand cmd = new SqlCommand($"Usp_Listar_{tabla}", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            dgvPrincipal.DataSource = dt;
        }

        private void OcultarTodosLosCampos()
        {
            txtCodigo.Visible = lblCodigo.Visible = false;
            txtNombre.Visible = lblNombre.Visible = false;
            txtApellido.Visible = lblApellido.Visible = false;
            txtTelefono.Visible = lblTelefono.Visible = false;
            txtCorreo.Visible = lblCorreo.Visible = false;
            txtDireccion.Visible = lblDireccion.Visible = false;

            lblNombre.Text = "Nombre:";
            lblApellido.Text = "Apellido:";
            lblTelefono.Text = "Teléfono:";
            lblCorreo.Text = "Correo:";
            lblDireccion.Text = "Dirección:";
        }

        private void ConfigurarCampos(string tabla)
        {
            OcultarTodosLosCampos();

            txtCodigo.Clear();
            txtNombre.Clear();
            txtApellido.Clear();
            txtTelefono.Clear();
            txtCorreo.Clear();
            txtDireccion.Clear();

            switch (tabla)
            {
                case "Cliente":
                    lblCodigo.Visible = txtCodigo.Visible = true;
                    lblCodigo.Text = "DNI:";

                    lblNombre.Visible = txtNombre.Visible = true;
                    lblApellido.Visible = txtApellido.Visible = true;
                    lblTelefono.Visible = txtTelefono.Visible = true;
                    lblDireccion.Visible = txtDireccion.Visible = true;
                    break;

                case "Tecnico":
                    lblNombre.Visible = txtNombre.Visible = true;
                    lblApellido.Visible = txtApellido.Visible = true;

                    lblCorreo.Visible = txtCorreo.Visible = true;
                    lblCorreo.Text = "Especialidad:";

                    lblTelefono.Visible = txtTelefono.Visible = true;
                    break;

                case "Equipo":
                    lblNombre.Visible = txtNombre.Visible = true;
                    lblNombre.Text = "Tipo:";

                    lblApellido.Visible = txtApellido.Visible = true;
                    lblApellido.Text = "Marca:";

                    lblTelefono.Visible = txtTelefono.Visible = true;
                    lblTelefono.Text = "Modelo:";

                    lblCorreo.Visible = txtCorreo.Visible = true;
                    lblCorreo.Text = "Serie:";
                    break;

                case "Servicio":
                    lblNombre.Visible = txtNombre.Visible = true;
                    lblNombre.Text = "Servicio:";

                    lblTelefono.Visible = txtTelefono.Visible = true;
                    lblTelefono.Text = "Precio:";
                    break;

                case "Repuesto":
                    lblNombre.Visible = txtNombre.Visible = true;
                    lblNombre.Text = "Repuesto:";

                    lblCorreo.Visible = txtCorreo.Visible = true;
                    lblCorreo.Text = "Precio:";
                    break;

                case "OrdenServicio":
                    lblNombre.Visible = txtNombre.Visible = true;
                    lblNombre.Text = "Id Cliente:";

                    lblApellido.Visible = txtApellido.Visible = true;
                    lblApellido.Text = "Id Tecnico:";

                    lblTelefono.Visible = txtTelefono.Visible = true;
                    lblTelefono.Text = "Id Equipo:";

                    lblCorreo.Visible = txtCorreo.Visible = true;
                    lblCorreo.Text = "Estado:";

                    lblDireccion.Visible = txtDireccion.Visible = true;
                    lblDireccion.Text = "Observación:";
                    break;
            }
        }

        private void btnInsertar_Click_1(object sender, EventArgs e)
        {
            string tabla = cboTabla.SelectedItem?.ToString();
            if (string.IsNullOrEmpty(tabla)) return;

            using (SqlConnection cn = new SqlConnection(ObtenerCadenaConexion()))
            {
                SqlCommand cmd = new SqlCommand($"Usp_Insertar_{tabla}", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                switch (tabla)
                {
                    case "Cliente":
                        cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Apellido", txtApellido.Text);
                        cmd.Parameters.AddWithValue("@DNI", txtCodigo.Text);
                        cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text);
                        cmd.Parameters.AddWithValue("@Direccion", txtDireccion.Text);
                        break;

                    case "Tecnico":
                        cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Apellido", txtApellido.Text);
                        cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text);
                        break;

                    case "Equipo":
                        cmd.Parameters.AddWithValue("@Tipo", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Marca", txtApellido.Text);
                        cmd.Parameters.AddWithValue("@Modelo", txtTelefono.Text);
                        cmd.Parameters.AddWithValue("@Serie", txtCorreo.Text);
                        break;

                    case "Servicio":
                        cmd.Parameters.AddWithValue("@NombreServicio", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Precio", decimal.Parse(txtDireccion.Text));
                        break;

                    case "Repuesto":
                        cmd.Parameters.AddWithValue("@NombreRepuesto", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Precio", decimal.Parse(txtCorreo.Text));
                        break;

                    case "OrdenServicio":
                        cmd.Parameters.AddWithValue("@IdCliente", int.Parse(txtNombre.Text));
                        cmd.Parameters.AddWithValue("@IdTecnico", int.Parse(txtApellido.Text));
                        cmd.Parameters.AddWithValue("@IdEquipo", int.Parse(txtTelefono.Text));
                        cmd.Parameters.AddWithValue("@FechaIngreso", int.Parse(txtTelefono.Text));
                        cmd.Parameters.AddWithValue("@Estado", txtCorreo.Text);
                        cmd.Parameters.AddWithValue("@Observacion", txtDireccion.Text);
                        break;

                    default:
                        MessageBox.Show("No se reconoce la tabla seleccionada.");
                        return;
                }

                cn.Open();
                cmd.ExecuteNonQuery();
            }

            MessageBox.Show($"{tabla} insertado correctamente.");
            CargarTabla(tabla);
        }

        private void btnBuscar_Click_1(object sender, EventArgs e)
        {
            string tabla = cboTabla.SelectedItem?.ToString();
            if (string.IsNullOrEmpty(tabla)) return;

            DataTable dt = new DataTable();
            using (SqlConnection cn = new SqlConnection(ObtenerCadenaConexion()))
            {
                SqlCommand cmd = new SqlCommand($"Usp_Buscar_{tabla}", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                switch (tabla)
                {
                    case "Cliente":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "Tecnico":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "Equipo":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "Servicio":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "Repuesto":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "OrdenServicio":
                        cmd.Parameters.AddWithValue($"@IdOrden", txtID.Text);
                        break;

                    default:
                        MessageBox.Show("No se reconoce la tabla seleccionada.");
                        return;
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            dgvPrincipal.DataSource = dt;
        }

        private void btnActualizar_Click_1(object sender, EventArgs e)
        {
            string tabla = cboTabla.SelectedItem?.ToString();
            if (string.IsNullOrEmpty(tabla)) return;

            using (SqlConnection cn = new SqlConnection(ObtenerCadenaConexion()))
            {
                SqlCommand cmd = new SqlCommand($"Usp_Actualizar_{tabla}", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                switch (tabla)
                {
                    case "Cliente":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Apellido", txtApellido.Text);
                        cmd.Parameters.AddWithValue("@DNI", txtCodigo.Text);
                        cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text);
                        cmd.Parameters.AddWithValue("@Direccion", txtDireccion.Text);
                        break;

                    case "Tecnico":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Apellido", txtApellido.Text);
                        cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text);
                        break;

                    case "Equipo":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        cmd.Parameters.AddWithValue("@Tipo", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Marca", txtApellido.Text);
                        cmd.Parameters.AddWithValue("@Modelo", txtTelefono.Text);
                        cmd.Parameters.AddWithValue("@Serie", txtCorreo.Text);
                        break;

                    case "Servicio":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        cmd.Parameters.AddWithValue("@NombreServicio", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Precio", decimal.Parse(txtDireccion.Text));
                        break;

                    case "Repuesto":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        cmd.Parameters.AddWithValue("@NombreRepuesto", txtNombre.Text);
                        cmd.Parameters.AddWithValue("@Precio", decimal.Parse(txtCorreo.Text));
                        break;

                    case "OrdenServicio":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        cmd.Parameters.AddWithValue("@IdCliente", int.Parse(txtNombre.Text));
                        cmd.Parameters.AddWithValue("@IdTecnico", int.Parse(txtApellido.Text));
                        cmd.Parameters.AddWithValue("@IdEquipo", int.Parse(txtTelefono.Text));
                        cmd.Parameters.AddWithValue("@IdEquipo", int.Parse(txtTelefono.Text));
                        cmd.Parameters.AddWithValue("@Estado", txtCorreo.Text);
                        cmd.Parameters.AddWithValue("@Diagnostico", txtDireccion.Text);
                        break;

                    default:
                        MessageBox.Show("No se reconoce la tabla seleccionada.");
                        return;
                }

                cn.Open();
                cmd.ExecuteNonQuery();
            }
            MessageBox.Show($"{tabla} actualizado correctamente.");
            CargarTabla(tabla);
        }

        private void btnEliminar_Click_1(object sender, EventArgs e)
        {
            string tabla = cboTabla.SelectedItem?.ToString();
            if (string.IsNullOrEmpty(tabla)) return;

            using (SqlConnection cn = new SqlConnection(ObtenerCadenaConexion()))
            {
                SqlCommand cmd = new SqlCommand($"Usp_Eliminar_{tabla}", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                switch (tabla)
                {
                    case "Cliente":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "Tecnico":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "Equipo":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "Servicio":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "Repuesto":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    case "OrdenServicio":
                        cmd.Parameters.AddWithValue($"@Id{tabla}", txtID.Text);
                        break;

                    default:
                        MessageBox.Show("No se reconoce la tabla seleccionada.");
                        return;
                }

                cn.Open();
                cmd.ExecuteNonQuery();
            }
            MessageBox.Show($"{tabla} eliminado correctamente.");
            CargarTabla(tabla);
        }
    }
}
