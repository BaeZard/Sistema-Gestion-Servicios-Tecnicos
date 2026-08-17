    CREATE DATABASE SGM_ST_EF;
    GO
    USE SGM_ST_EF;
    GO
    CREATE TABLE Rol (
        IdRol INT IDENTITY(1,1) PRIMARY KEY,
        NombreRol VARCHAR(50) NOT NULL
    );

    CREATE TABLE Usuario (
        IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
        Usuario VARCHAR(50) NOT NULL UNIQUE,
        Clave VARCHAR(200) NOT NULL,
        IdRol INT NOT NULL,
        Estado BIT NOT NULL DEFAULT 1,

        FOREIGN KEY (IdRol) REFERENCES Rol(IdRol)
    );

    CREATE TABLE Cliente (
        IdCliente INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(50) NOT NULL,
        Apellido VARCHAR(50) NOT NULL,
        DNI CHAR(8) NOT NULL UNIQUE,
        Telefono VARCHAR(15),
        Direccion VARCHAR(100)
    );

    CREATE TABLE Tecnico (
        IdTecnico INT IDENTITY(1,1) PRIMARY KEY,
        Nombre VARCHAR(50) NOT NULL,
        Apellido VARCHAR(50) NOT NULL,
        Especialidad VARCHAR(50),
        Telefono VARCHAR(15)
    );

    CREATE TABLE Equipo (
        IdEquipo INT IDENTITY(1,1) PRIMARY KEY,
        IdCliente INT NOT NULL,
        Tipo VARCHAR(50) NOT NULL,
        Marca VARCHAR(50),
        Modelo VARCHAR(50),
        Serie VARCHAR(50) UNIQUE,
        FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente)
    );

    CREATE TABLE Servicio (
        IdServicio INT IDENTITY(1,1) PRIMARY KEY,
        NombreServicio VARCHAR(50) NOT NULL,
        Precio DECIMAL(10,2) NOT NULL
    );

    CREATE TABLE Repuesto (
        IdRepuesto INT IDENTITY(1,1) PRIMARY KEY,
        NombreRepuesto VARCHAR(50) NOT NULL,
        Precio DECIMAL(10,2) NOT NULL
    );

    CREATE TABLE OrdenServicio (
        IdOrden INT IDENTITY(1,1) PRIMARY KEY,
        IdCliente INT NOT NULL,
        IdTecnico INT NOT NULL,
        IdEquipo INT NOT NULL,
        FechaIngreso DATE NOT NULL,
        Estado VARCHAR(20) NOT NULL,
        Observacion VARCHAR(200),
        FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente),
        FOREIGN KEY (IdTecnico) REFERENCES Tecnico(IdTecnico),
        FOREIGN KEY (IdEquipo) REFERENCES Equipo(IdEquipo)
    );

    CREATE TABLE DetalleOrden (
        IdDetalle INT IDENTITY(1,1) PRIMARY KEY,
        IdOrden INT NOT NULL,
        IdServicio INT NOT NULL,
        Cantidad INT NOT NULL,
        Subtotal DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (IdOrden) REFERENCES OrdenServicio(IdOrden),
        FOREIGN KEY (IdServicio) REFERENCES Servicio(IdServicio)
    );

    CREATE TABLE DetalleRepuesto (
        IdDetalleRepuesto INT IDENTITY(1,1) PRIMARY KEY,
        IdOrden INT NOT NULL,
        IdRepuesto INT NOT NULL,
        Cantidad INT NOT NULL,
        Subtotal DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (IdOrden) REFERENCES OrdenServicio(IdOrden),
        FOREIGN KEY (IdRepuesto) REFERENCES Repuesto(IdRepuesto)
    );


    -- Clientes
    SELECT * FROM dbo.Cliente;

    -- Técnicos
    SELECT * FROM dbo.Tecnico;

    -- Equipos
    SELECT * FROM dbo.Equipo;

    -- Servicios
    SELECT * FROM dbo.Servicio;

    -- Repuestos
    SELECT * FROM dbo.Repuesto;

    -- Órdenes de servicio
    SELECT * FROM dbo.OrdenServicio;

    -- Detalle de órdenes
    SELECT * FROM dbo.DetalleOrden;

    -- Detalle de repuestos
    SELECT * FROM dbo.DetalleRepuesto;

    -- Roles
    SELECT * FROM dbo.Rol;

    -- Usuarios
    SELECT * FROM dbo.Usuario;



    GO
    CREATE PROCEDURE Usp_Login
        @Usuario VARCHAR(50),
        @Clave VARCHAR(200)
    AS
    BEGIN
        SELECT 
            u.IdUsuario,
            u.Usuario,
            u.IdRol,
            r.NombreRol
        FROM Usuario u
        INNER JOIN Rol r ON u.IdRol = r.IdRol
        WHERE u.Usuario = @Usuario
          AND u.Clave = @Clave
          AND u.Estado = 1;
    END;
    GO

    CREATE PROCEDURE SP_ValidarLogin
        @Usuario VARCHAR(50),
        @Clave   VARCHAR(200)
    AS
    BEGIN
        SET NOCOUNT ON;

        SELECT 
            U.IdUsuario,
            U.Usuario,
            U.IdRol,
            R.NombreRol,
            U.Estado
        FROM Usuario U
        INNER JOIN Rol R ON U.IdRol = R.IdRol
        WHERE U.Usuario = @Usuario
          AND U.Clave = @Clave
          AND U.Estado = 1;  -- Solo permite usuarios activos
    END
    GO

    CREATE PROCEDURE Usp_Insertar_Cliente
        @Nombre VARCHAR(50),
        @Apellido VARCHAR(50),
        @DNI CHAR(8),
        @Telefono VARCHAR(15),
        @Direccion VARCHAR(100)
    AS
    BEGIN
        INSERT INTO Cliente (Nombre, Apellido, DNI, Telefono, Direccion)
        VALUES (@Nombre, @Apellido, @DNI, @Telefono, @Direccion)
    END
    GO




    CREATE PROCEDURE Usp_Actualizar_Cliente
        @IdCliente INT,
        @Nombre VARCHAR(50),
        @Apellido VARCHAR(50),
        @DNI CHAR(8),
        @Telefono VARCHAR(15),
        @Direccion VARCHAR(100)
    AS
    BEGIN
        UPDATE Cliente
        SET Nombre=@Nombre, Apellido=@Apellido, DNI=@DNI, Telefono=@Telefono, Direccion=@Direccion
        WHERE IdCliente=@IdCliente
    END
    GO

    CREATE PROCEDURE Usp_Eliminar_Cliente
        @IdCliente INT
    AS
    BEGIN
        DELETE FROM Cliente WHERE IdCliente=@IdCliente
    END
    GO

    CREATE PROCEDURE Usp_Listar_Cliente
    AS
    BEGIN
        SELECT * FROM Cliente
    END
    GO

    CREATE PROCEDURE Usp_Buscar_Cliente
        @IdCliente INT
    AS
    BEGIN
        SELECT * FROM Cliente WHERE IdCliente = @IdCliente
    END
    GO

    -- ============================================
    --   CRUD TÉCNICO
    -- ============================================

    CREATE PROCEDURE Usp_Insertar_Tecnico
        @Nombre VARCHAR(50),
        @Apellido VARCHAR(50),
        @Especialidad VARCHAR(50),
        @Telefono VARCHAR(15)
    AS
    BEGIN
        INSERT INTO Tecnico (Nombre, Apellido, Especialidad, Telefono)
        VALUES (@Nombre, @Apellido, @Especialidad, @Telefono)
    END
    GO

    CREATE PROCEDURE Usp_Actualizar_Tecnico
        @IdTecnico INT,
        @Nombre VARCHAR(50),
        @Apellido VARCHAR(50),
        @Especialidad VARCHAR(50),
        @Telefono VARCHAR(15)
    AS
    BEGIN
        UPDATE Tecnico
        SET Nombre=@Nombre, Apellido=@Apellido, Especialidad=@Especialidad, Telefono=@Telefono
        WHERE IdTecnico=@IdTecnico
    END
    GO

    CREATE PROCEDURE Usp_Eliminar_Tecnico
        @IdTecnico INT
    AS
    BEGIN
        DELETE FROM Tecnico WHERE IdTecnico=@IdTecnico
    END
    GO

    CREATE PROCEDURE Usp_Listar_Tecnico
    AS
    BEGIN
        SELECT * FROM Tecnico
    END
    GO

    CREATE PROCEDURE Usp_Buscar_Tecnico
        @IdTecnico INT
    AS
    BEGIN
        SELECT * FROM Tecnico WHERE IdTecnico = @IdTecnico
    END

    -- ============================================
    --   CRUD EQUIPO
    -- ============================================

    CREATE PROCEDURE Usp_Insertar_Equipo
        @Tipo VARCHAR(50),
        @Marca VARCHAR(50),
        @Modelo VARCHAR(50),
        @Serie VARCHAR(50)
    AS
    BEGIN
        INSERT INTO Equipo (Tipo, Marca, Modelo, Serie)
        VALUES (@Tipo, @Marca, @Modelo, @Serie)
    END
    GO

    CREATE PROCEDURE Usp_Actualizar_Equipo
        @IdEquipo INT,
        @Tipo VARCHAR(50),
        @Marca VARCHAR(50),
        @Modelo VARCHAR(50),
        @Serie VARCHAR(50)
    AS
    BEGIN
        UPDATE Equipo
        SET Tipo=@Tipo, Marca=@Marca, Modelo=@Modelo, Serie=@Serie
        WHERE IdEquipo=@IdEquipo
    END
    GO

    CREATE PROCEDURE Usp_Eliminar_Equipo
        @IdEquipo INT
    AS
    BEGIN
        DELETE FROM Equipo WHERE IdEquipo=@IdEquipo
    END
    GO

    CREATE PROCEDURE Usp_Listar_Equipo
    AS
    BEGIN
        SELECT * FROM Equipo
    END
    GO

    CREATE PROCEDURE Usp_Buscar_Equipo
        @IdEquipo INT
    AS
    BEGIN
        SELECT * FROM Equipo WHERE IdEquipo = @IdEquipo
    END

    -- ============================================
    --   CRUD SERVICIO
    -- ============================================

    CREATE PROCEDURE Usp_Insertar_Servicio
        @NombreServicio VARCHAR(50),
        @Precio DECIMAL(10,2)
    AS
    BEGIN
        INSERT INTO Servicio (NombreServicio, Precio)
        VALUES (@NombreServicio, @Precio)
    END
    GO

    CREATE PROCEDURE Usp_Actualizar_Servicio
        @IdServicio INT,
        @NombreServicio VARCHAR(50),
        @Precio DECIMAL(10,2)
    AS
    BEGIN
        UPDATE Servicio
        SET NombreServicio=@NombreServicio, Precio=@Precio
        WHERE IdServicio=@IdServicio
    END
    GO

    CREATE PROCEDURE Usp_Eliminar_Servicio
        @IdServicio INT
    AS
    BEGIN
        DELETE FROM Servicio WHERE IdServicio=@IdServicio
    END
    GO

    CREATE PROCEDURE Usp_Listar_Servicio
    AS
    BEGIN
        SELECT * FROM Servicio
    END
    GO

    CREATE PROCEDURE Usp_Buscar_Servicio
        @IdServicio INT
    AS
    BEGIN
        SELECT * FROM Servicio WHERE IdServicio = @IdServicio
    END

    -- ============================================
    --   CRUD REPUESTO
    -- ============================================

    CREATE PROCEDURE Usp_Insertar_Repuesto
        @NombreRepuesto VARCHAR(50),
        @Precio DECIMAL(10,2)
    AS
    BEGIN
        INSERT INTO Repuesto (NombreRepuesto, Precio)
        VALUES (@NombreRepuesto, @Precio)
    END
    GO

    CREATE PROCEDURE Usp_Actualizar_Repuesto
        @IdRepuesto INT,
        @NombreRepuesto VARCHAR(50),
        @Precio DECIMAL(10,2)
    AS
    BEGIN
        UPDATE Repuesto
        SET NombreRepuesto=@NombreRepuesto, Precio=@Precio
        WHERE IdRepuesto=@IdRepuesto
    END
    GO

    CREATE PROCEDURE Usp_Eliminar_Repuesto
        @IdRepuesto INT
    AS
    BEGIN
        DELETE FROM Repuesto WHERE IdRepuesto=@IdRepuesto
    END
    GO

    CREATE PROCEDURE Usp_Listar_Repuesto
    AS
    BEGIN
        SELECT * FROM Repuesto
    END
    GO

    CREATE PROCEDURE Usp_Buscar_Repuesto
        @IdRepuesto INT
    AS
    BEGIN
        SELECT * FROM Repuesto WHERE IdRepuesto = @IdRepuesto
    END

    -- ============================================
    --   CRUD ORDEN SERVICIO
    -- ============================================

    CREATE PROCEDURE Usp_Insertar_OrdenServicio
        @IdCliente INT,
        @IdTecnico INT,
        @IdEquipo INT,
        @FechaIngreso DATE,
        @Estado VARCHAR(20),
        @Observacion VARCHAR(200)
    AS
    BEGIN
        INSERT INTO OrdenServicio (IdCliente, IdTecnico, IdEquipo, FechaIngreso, Estado, Observacion)
        VALUES (@IdCliente, @IdTecnico, @IdEquipo, @FechaIngreso, @Estado, @Observacion)
    END
    GO

    CREATE PROCEDURE Usp_Actualizar_OrdenServicio
        @IdOrden INT,
        @IdCliente INT,
        @IdTecnico INT,
        @IdEquipo INT,
        @FechaIngreso DATE,
        @Estado VARCHAR(20),
        @Observacion VARCHAR(200)
    AS
    BEGIN
        UPDATE OrdenServicio
        SET IdCliente=@IdCliente, IdTecnico=@IdTecnico, IdEquipo=@IdEquipo,
            FechaIngreso=@FechaIngreso, Estado=@Estado, Observacion=@Observacion
        WHERE IdOrden=@IdOrden
    END
    GO

    CREATE PROCEDURE Usp_Eliminar_OrdenServicio
        @IdOrden INT
    AS
    BEGIN
        DELETE FROM OrdenServicio WHERE IdOrden=@IdOrden
    END
    GO

    CREATE PROCEDURE Usp_Listar_OrdenServicio
    AS
    BEGIN
        SELECT * FROM OrdenServicio
    END
    GO

    CREATE PROCEDURE Usp_Buscar_OrdenServicio
        @IdOrden INT
    AS
    BEGIN
        SELECT * FROM OrdenServicio WHERE IdOrden = @IdOrden
    END

    -- ============================================
    --   CRUD DETALLE ORDEN
    -- ============================================

    CREATE PROCEDURE Usp_Insertar_DetalleOrden
        @IdOrden INT,
        @IdServicio INT,
        @Cantidad INT,
        @Subtotal DECIMAL(10,2)
    AS
    BEGIN
        INSERT INTO DetalleOrden (IdOrden, IdServicio, Cantidad, Subtotal)
        VALUES (@IdOrden, @IdServicio, @Cantidad, @Subtotal)
    END
    GO

    CREATE PROCEDURE Usp_Eliminar_DetalleOrden
        @IdDetalle INT
    AS
    BEGIN
        DELETE FROM DetalleOrden WHERE IdDetalle=@IdDetalle
    END
    GO

    CREATE PROCEDURE Usp_Listar_DetalleOrden
        @IdOrden INT
    AS
    BEGIN
        SELECT * FROM DetalleOrden WHERE IdOrden=@IdOrden
    END
    GO

    CREATE PROCEDURE Usp_Buscar_DetalleOrden
        @IdDetalle INT
    AS
    BEGIN
        SELECT * FROM DetalleOrden WHERE IdDetalle = @IdDetalle
    END
    -- ============================================
    --   CRUD DETALLE REPUESTO
    -- ============================================

    CREATE PROCEDURE Usp_Insertar_DetalleRepuesto
        @IdOrden INT,
        @IdRepuesto INT,
        @Cantidad INT,
        @Subtotal DECIMAL(10,2)
    AS
    BEGIN
        INSERT INTO DetalleRepuesto (IdOrden, IdRepuesto, Cantidad, Subtotal)
        VALUES (@IdOrden, @IdRepuesto, @Cantidad, @Subtotal)
    END
    GO

    CREATE PROCEDURE Usp_Eliminar_DetalleRepuesto
        @IdDetalleRepuesto INT
    AS
    BEGIN
        DELETE FROM DetalleRepuesto WHERE IdDetalleRepuesto=@IdDetalleRepuesto
    END
    GO

    CREATE PROCEDURE Usp_Listar_DetalleRepuesto
        @IdOrden INT
    AS
    BEGIN
        SELECT * FROM DetalleRepuesto WHERE IdOrden=@IdOrden
    END
    GO

    CREATE PROCEDURE Usp_Buscar_DetalleRepuesto
        @IdDetalleRepuesto INT
    AS
    BEGIN
        SELECT * FROM DetalleRepuesto WHERE IdDetalleRepuesto = @IdDetalleRepuesto
    END

UPDATE Cliente SET Nombre = REPLACE(REPLACE(REPLACE(Nombre, 'Ãa', 'ía'), 'Ã©', 'é'), 'Ã³', 'ó');
UPDATE Cliente SET Apellido = REPLACE(REPLACE(REPLACE(Apellido, 'Ãa', 'ía'), 'Ã©', 'é'), 'Ã³', 'ó');
UPDATE Tecnico SET Nombre = REPLACE(REPLACE(REPLACE(Nombre, 'Ãa', 'ía'), 'Ã©', 'é'), 'Ã³', 'ó');
UPDATE Tecnico SET Apellido = REPLACE(REPLACE(REPLACE(Apellido, 'Ãa', 'ía'), 'Ã©', 'é'), 'Ã³', 'ó');
UPDATE OrdenServicio SET Observacion = REPLACE(REPLACE(REPLACE(Observacion, 'DiagnÃ³stico', 'Diagnóstico'), 'revisiÃ³n', 'revisión'), 'AtenciÃ³n', 'Atención');
GO