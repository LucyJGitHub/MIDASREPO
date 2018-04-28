/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Enter Support System ID')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC1601 - Enter Support System ID                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP016 *CREATE     Date 02Dec02              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SSYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&EXIST) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Parameters for QCLSCAN. */
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(2) VALUE('@@')
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(2) VALUE(2)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)
 
             DCLF       FILE(SMSETULA)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/* Request new system ID. */
             ?          SYSTEMID
             MONMSG     MSGID(CPF6801) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
             RTVDTAARA  DTAARA(QTEMP/SYSID) RTNVAR(&SSYSID)
 
/* Check if any libraries with this prefix already exist. */
CHECK:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(CHGDTAARA))
 
             IF         COND(&DFTYPE *NE '*LIB') THEN(DO)
                GOTO       CMDLBL(CHECK)
             ENDDO
/* Scan object name to replace '@@' with system ID. */
             CHGVAR     VAR(&RESULT) VALUE('0')
             CHGVAR     VAR(&STRLEN) VALUE(10)
             CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&SSYSID)
/* If library does not exist then continue ... */
                CHKOBJ     OBJ(&DFNAME) OBJTYPE(*LIB)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   GOTO       CMDLBL(CHECK)
                ENDDO
/* ... otherwise flag that it does exist. */
                CHGVAR     VAR(&EXIST) VALUE('Y')
                GOTO       CMDLBL(CHECK)
             ENDDO
             ELSE       CMD(DO)
                GOTO       CMDLBL(CHECK)
             ENDDO
 
CHGDTAARA:
/* If any of the libraries exist then send warning message. */
             IF         COND(&EXIST *EQ 'Y') THEN(DO)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE('One or more +
                             library with prefix' *BCAT &SSYSID *BCAT +
                             'already exists.')
                CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Do you wish +
                          to continue?')
                CALL       PGM(SCC0010) PARM('UPC1601' 'OPTION' &REPLY1)
                IF         COND(&REPLY1 *EQ 'N') THEN(DO)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/* Change data area SC24X7 to store system ID name. */
             CHGDTAARA  DTAARA(SC24X7 (3 2)) VALUE(&SSYSID)
 
             GOTO       CMDLBL(END)
 
ABNOR:
/* Set up messages for Midas Information Screen  */
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC1601') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(SCC0010) PARM('UPC1601' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
