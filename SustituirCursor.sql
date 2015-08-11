-- Creación de Tabla para el Ejemplo
CREATE TABLE Personas (
Cedula INT PRIMARY KEY NOT NULL,
Nombre VARCHAR(50) NOT NULL,
Apellido VARCHAR(50) NOT NULL
)
GO
-- Inserción de Registros para el Ejemplo
INSERT INTO Personas VALUES (1, 'Pedro', 'Perez')
INSERT INTO Personas VALUES (2, 'Carlos', 'Gonzalez')
INSERT INTO Personas VALUES (3, 'Maria', 'Perez')
GO

-- Creacion de un cursor para listar las Personas
DECLARE cursorP CURSOR
FOR SELECT Cedula, Nombre, Apellido FROM Personas
OPEN cursorP
DECLARE @Cedula INT, @Nombre VARCHAR(50), @Apellido VARCHAR(50)

FETCH NEXT FROM cursorP INTO @Cedula, @Nombre, @Apellido
WHILE @@fetch_status=0
BEGIN
      -- Realizar las acciones con los valores obtenidos
      EXEC SP_NombreDelSP @Cedula, @Nombre, @Apellido
      FETCH NEXT FROM cursorP INTO @Cedula, @Nombre, @Apellido
      
END 
CLOSE cursorP
DEALLOCATE cursorP

GO

-- =======================================
--           Reemplazo del Cursor
-- =======================================
DECLARE @Rows     INT = 0 
DECLARE @i        INT = 0
-- Puede utilizarse una variable de Tabla (@NombreTabla, si la versión del manejador lo permite) ó una Tabla Temporal (#NombreTabla)
DECLARE @Personas TABLE 
( 
      pk_id INT NOT NULL IDENTITY (1, 1), -- Secuencial para leer registro                                          a registro
      Cedula INT, 
      Nombre VARCHAR(50) NOT NULL,
      Apellido VARCHAR(50) NOT NULL
)

-- Inserción de registros
INSERT INTO @Personas 
(Cedula, Nombre, Apellido) 

SELECT Cedula, Nombre, Apellido
FROM Personas

-- Contar cuantos registros existen
SET @Rows = (SELECT MAX(pk_id) FROM @Personas)

DECLARE @Cedula INT
DECLARE @Nombre VARCHAR(50)
DECLARE @Apellido VARCHAR(50)

-- Recorrer Tabla
WHILE @i <= @Rows 
BEGIN 

      --Asignación de Variables
      SELECT 
            @Cedula = Cedula, 
            @Nombre = Nombre, 
            @Apellido = Apellido
      FROM @Personas 
      WHERE pk_id = @i --> Controla el movimiento por c/u de los registros

      -- Realizar las acciones con los valores obtenidos   
      EXEC SP_NombreDelSP @Cedula, @Nombre, @Apellido

      SET @i=@i + 1 
END
