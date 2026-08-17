using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SIGEM
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
        }

        private string ObtenerCadenaConexion()
        {
            return ConfigurationManager.ConnectionStrings["ServicioTecnico"].ConnectionString;
        }

        private void btnIniciar_Click(object sender, EventArgs e)
        {
        }

        private void btnIniciar_Click_1(object sender, EventArgs e)
        {
            string usuario = txtUsuario.Text.Trim();
            string clave = txtContraeña.Text.Trim();

            if (usuario == "" || clave == "")
            {
                MessageBox.Show("Ingrese usuario y contraseña.",
                    "Advertencia", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string connectionString = ObtenerCadenaConexion();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("SP_ValidarLogin", connection);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Usuario", usuario);
                    cmd.Parameters.AddWithValue("@Clave", clave);

                    connection.Open();

                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        string rol = dr["NombreRol"].ToString();
                        string usr = dr["Usuario"].ToString();

                        MessageBox.Show($"Bienvenido {usuario}\nRol: {rol}",
                            "Acceso Correcto",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);

                        Principal principal = new Principal(rol, usr);
                        principal.Show();
                        this.Hide();
                    }
                    else
                    {
                        MessageBox.Show("Usuario o contraseña incorrectos.",
                            "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
                catch (SqlException ex)
                {
                    MessageBox.Show("Error de conexión: " + ex.Message,
                                    "Error de Base de Datos",
                                    MessageBoxButtons.OK,
                                    MessageBoxIcon.Error);
                }
            }
        }
    }
}