#Proyecto Manolo

                #Definición de Función Menú.
function Get-Menu
{
#Limpieza de Pantalla.
Clear-Host

#Menú que es mostrado en pantalla.
Write-Host `n
Write-Host "1.- Crear Disco virtual."
Write-Host `n
Write-Host `t "2.- Borrar Disco Virtual."
Write-Host `n
Write-Host `t`t "3.- Encriptar Disco Virtual."
Write-Host `n
Write-Host `t`t`t "0.- Salir."
Write-Host `n
Write-Host `n

    
}


#funcion para activar el hiper-v
function get-hiperv {
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
}

#desactiva el hiper-v
function get-hipervdown{
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
}

#funcion menucrear
function get-menucrear {
Cls
Write-Host `n
Write-Host "1.-Activar Hiper-v"
Write-Host `n
Write-Host `t "2.-Desactivar Hiper-v"
Write-Host `n
Write-Host `t`t "3.-Crear disco"
Write-Host `n
Write-Host `t`t`t "4.-volver al menu principal"
Write-Host `n
Write-Host `n
[int]$omg=Read-Host "elige una opcion"
switch($omg){
#llama a las diferentes funciones
  1 {get-hiperv}
  2 {get-hipervdown}
  3 {get-creardisco}
  4 {Get-Menu}

}#fin switch
}

function get-creardisco{
#crea un disco lo monta y lo formatea como ntfs

do{

Write-Host "Ha seleccionado Crear un Disco Virtual, recuerde que debe desactivar en Servicios la detección de Hardware de Powershell."
Write-Host `n
$rutacrear = Read-Host "Indique el Nombre del disco (además de la ruta para el mismo) Ejemplo: E:\Discos\Disco01.vhd"
[int]$temp = Read-Host “Tamaño del disco en GBytes”
[double]$tamano = $temp * 1000000000
New-VHD -Path $rutacrear -Dynamic -SizeBytes $tamano|Mount-VHD -Passthru|Initialize-Disk -PassThru|New-Partition -AssignDriveLetter -UseMaximumSize|Format-Volume -FileSystem NTFS -Confirm:$false
Write-Host `n
Write-Host `n
Write-Host "Disco Virtual creado con éxito $rutacrear"
Write-Host `n
    
$respuesta = Read-Host “Quieres crear otro disco (S/N)?”}while ($respuesta -eq ‘s’)

}


                #Definicion de Función Borrar Disco Virtual

function Borrar-Disco
{
do{
Write-Host "Ha seleccionado Borrar un Disco Virtual"
Write-Host `n

#Definición de Parametros.
$rutaborrar = Read-Host "Indique el Nombre del disco (además de la ruta para el mismo) Ejemplo: E:\Discos\Disco01.vhd"

                #Inicio del programa de Borrado
Dismount-VHD -Path $rutaborrar -Confirm:$false
Write-Host `n
Write-Host "Disco Desmontado"
Write-Host `n
$respuestaborrar = Read-Host "A continuación se borrará $rutaborrar. ¿Desea Borrar? S/N"
Write-Host `n

#Pregunta de Seguridad para borrar
if ($respuestaborrar -eq 'S')
{
Remove-Item -Path $rutaborrar -Force -Confirm:$false
#Usamos un Break para abortar
}else{break}
Write-Host `n
$continuarborrar = Read-Host "¿Desea Borrar otro? S/N"
}while($continuarborrar -eq 'S')
}
                #Definicion de Función Encriptar Disco Virtual

function Encriptar-Disco
{

Write-Host "Ha seleccionado Encriptar un Disco Virtual"
Write-Host `n
Write-Host "A continuación se mostrarán los módulos instalados, para continuar es necesario tener el módulo Bitlocker"
Get-Module
Write-Host `n
$respuestaBitlocker = Read-Host "¿Aparece el módulo Bitlocker? S/N"
Write-Host `n

                #Definición de IF para continuar según la respuesta 

if ($respuestaBitlocker -eq 'n')
{

                #Si la entrada es N (No) se 

Write-Host "A continuación se importará el módulo Bitlocker"
Import-Module Bitlocker -Verbose    
#Solo existe una acción si no esta instalado, osea si la respuesta es N
Write-Host `n
Write-Host "Bitlocker ha sido importado satisfactoriamente"
Write-Host `n
    

}

                #Inicio del programa de encriptación


                #Pregunta de Variables
Get-Volume |ft -AutoSize
Write-Host `n
$rutaBitlocker = Read-Host "¿Que unidad desea encriptar?. Ejemplo: D:"
Write-Host `n
$rutaRecovery = Read-Host "¿Dónde desea almacenar la contraseña Recovery? No se puede almacenar en el disco duro a Encriptar. Ejemplo: E:"
Write-Host `n
$contrasena = Read-Host "Introduzca la contraseña que desea utilizar para encriptar. Mínimo 8 Carácteres"
Write-Host `n

                #Inicio de comandos
$bitlockerContrasena = ConvertTo-SecureString "$contrasena" -AsPlainText -Force
Enable-BitLocker -MountPoint "$rutaBitlocker" -EncryptionMethod Aes128 -PasswordProtector $bitlockerContrasena
Add-BitLockerKeyProtector -MountPoint "$rutaBitlocker" -RecoveryPasswordProtector
#Ayuda encontrada en https://blogs.technet.microsoft.com/heyscriptingguy/2013/08/17/powertip-use-powershell-to-write-bitlocker-recovery-key-to-text-file/
(Get-BitLockerVolume -MountPoint "$rutaBitlocker").KeyProtector.recoverypassword > "$rutarecovery\Bitlocker.txt"
                #FIN
                
Write-Host "Encriptado completado con éxito, recovery almacenado en $rutarecovery"
Write-Host `n
Write-Host "El disco está abierto, al reconectarlo pedirá su contraseña." 
}


#Definición de un Do-While para que el menú sea un Bucle.
do
{

Get-Menu

#Selección de la Variable para continuar el menú.
$switch01 = Read-Host "Seleccione la función con el número correspondiente"
Write-Host `n


#Definición del Switch para el Menú.
switch ($switch01)
{

                #Opción Default (cuando se introduce un número inválido)
 Default {Write-Host "ERROR - Opción Inexistente."}   

                #Opción número 0.- Salir
 0 {Exit}
 
                #Opción número 1.- Crear Disco Duro Virtual
 1 {

 get-menucrear

 }
 
                #Opción número 1.- Borrar Disco Duro Virtual
 2 {

 Borrar-Disco

 }
 
                #Opción número 3.- Encriptar Duro Virtual
 3 {

 Encriptar-Disco

 }



}
    

#Para que no salga del menú inmediatamente preguntamos un read-host
Write-Host `n
Read-Host "Pulse intro para continuar"
Write-Host `n

    
}
while ($True)

