#Proyecto Manolo

                #Definicion de Funcion Menu.
function Get-Menu
{
#Limpieza de Pantalla.
Clear-Host

#Menu que es mostrado en pantalla.
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
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
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

Write-Host "Ha seleccionado Crear un Disco Virtual, recuerde que debe desactivar en Servicios la deteccion de Hardware de Powershell."
Write-Host `n
$rutacrear = Read-Host "Indique el Nombre del disco (ademÃ¡s de la ruta para el mismo) Ejemplo: E:\Discos\Disco01.vhd"
[int]$temp = Read-Host "Tamanoo del disco en GByte"
[double]$tamano = $temp * 1000000000
New-VHD -Path $rutacrear -Dynamic -SizeBytes $tamano|Mount-VHD -Passthru|Initialize-Disk -PassThru|New-Partition -AssignDriveLetter -UseMaximumSize|Format-Volume -FileSystem NTFS -Confirm:$false
Write-Host `n
Write-Host `n
Write-Host "Disco Virtual creado con Exito $rutacrear"
Write-Host `n
    
$respuesta = Read-Host "Quieres crear otro disco (S/N)?"}
while ($respuesta -eq 'S')

}


                #Definicion de Funcion Borrar Disco Virtual

function Borrar-Disco
{
do{
Write-Host "Ha seleccionado Borrar un Disco Virtual"
Write-Host `n

#Definicion de Parametros.
$rutaborrar = Read-Host "Indique el Nombre del disco (ademas de la ruta para el mismo) Ejemplo: E:\Discos\Disco01.vhd"

                #Inicio del programa de Borrado
Dismount-VHD -Path $rutaborrar -Confirm:$false
Write-Host `n
Write-Host "Disco Desmontado"
Write-Host `n
$respuestaborrar = Read-Host "A continuacion se borrara $rutaborrar. ¿Desea Borrar? S/N"
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
                #Definicion de Funcion Encriptar Disco Virtual

function Encriptar-Disco
{

Write-Host "Ha seleccionado Encriptar un Disco Virtual"
Write-Host `n
Write-Host "A continuacion se mostraran los modulos instalados, para continuar es necesario tener el modulo Bitlocker"
Get-Module
Write-Host `n
$respuestaBitlocker = Read-Host "¿Aparece el modulo Bitlocker? S/N"
Write-Host `n

                #Definicion de IF para continuar segun la respuesta 

if ($respuestaBitlocker -eq 'n')
{

                #Si la entrada es N (No) se 

Write-Host "A continuacion se importara el modulo Bitlocker"
Import-Module Bitlocker -Verbose    
#Solo existe una accion si no esta instalado, osea si la respuesta es N
Write-Host `n
Write-Host "Bitlocker ha sido importado satisfactoriamente"
Write-Host `n
    

}

                #Inicio del programa de encriptacion


                #Pregunta de Variables
Get-Volume |ft -AutoSize
Write-Host `n
$rutaBitlocker = Read-Host "¿Que unidad desea encriptar?. Ejemplo: D:"
Write-Host `n
$rutaRecovery = Read-Host "¿Donde desea almacenar la contrasena Recovery? No se puede almacenar en el disco duro a Encriptar. Ejemplo: E:"
Write-Host `n
$contrasena = Read-Host "Introduzca la contrasena que desea utilizar para encriptar. Mi­nimo 8 Caracteres"
Write-Host `n

                #Inicio de comandos
$bitlockerContrasena = ConvertTo-SecureString "$contrasena" -AsPlainText -Force
Enable-BitLocker -MountPoint "$rutaBitlocker" -EncryptionMethod Aes128 -PasswordProtector $bitlockerContrasena
Add-BitLockerKeyProtector -MountPoint "$rutaBitlocker" -RecoveryPasswordProtector
#Ayuda encontrada en https://blogs.technet.microsoft.com/heyscriptingguy/2013/08/17/powertip-use-powershell-to-write-bitlocker-recovery-key-to-text-file/
(Get-BitLockerVolume -MountPoint "$rutaBitlocker").KeyProtector.recoverypassword > "$rutarecovery\Bitlocker.txt"
                #FIN
                
Write-Host "Encriptado completado con Exito, recovery almacenado en $rutarecovery"
Write-Host `n
Write-Host "El disco esta abierto, al reconectarlo pedira su contrasena." 
}


#Definicion de un Do-While para que el menu sea un Bucle.
do
{

Get-Menu

#Seleccion de la Variable para continuar el menu.
$switch01 = Read-Host "Seleccione la funcion con el numero correspondiente"
Write-Host `n


#Definicion del Switch para el Menu.
switch ($switch01)
{

                #Opcion Default (cuando se introduce un numero invalido)
 Default {Write-Host "ERROR - Opcion Inexistente."}   

                #Opcion numero 0.- Salir
 0 {Exit}
 
                #Opcion numero 1.- Crear Disco Duro Virtual
 1 {

 get-menucrear

 }
 
                #Opcion numero 1.- Borrar Disco Duro Virtual
 2 {

 Borrar-Disco

 }
 
                #Opcion numero 3.- Encriptar Duro Virtual
 3 {

 Encriptar-Disco

 }



}
    

#Para que no salga del menu inmediatamente preguntamos un read-host
Write-Host `n
Read-Host "Pulse intro para continuar"
Write-Host `n

    
}
while ($True)
