/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Merge two driving files')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0098 - Merge two driving files                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015             Date 05Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CUP005 *CREATE     Date 29Oct99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - 4.01 packaging. Add MONMSG to error processing.    */
/*       CUP002 - Introduction of BRIDGE utility                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BASELIB &MRGLIB &TGTLIB)
 
             DCL        VAR(&BASELIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRGLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TGTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TITLE) TYPE(*CHAR) LEN(45)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create data area /MIDASMSG in QTEMP */
             DLTDTAARA  DTAARA(QTEMP/MIDASMSG)
             MONMSG     MSGID(CPF0000)
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ')
 
/* If Target library not same as Base library then copy driving file */
             IF         COND(&TGTLIB *NE '*BASELIB') THEN(DO)
                DLTF       FILE(&TGTLIB/UPDLVC*)
                MONMSG     MSGID(CPF2125)
                CRTDUPOBJ  OBJ(UPDLVC*) FROMLIB(&BASELIB) +
                          OBJTYPE(*FILE) TOLIB(&TGTLIB) DATA(*YES)
                CHGVAR     VAR(&BASELIB) VALUE(&TGTLIB)
             ENDDO
 
             CHGVAR     VAR(&TITLE) VALUE('Differences between' +
                          *BCAT &BASELIB *BCAT 'and' *BCAT &MRGLIB)
 
/* Put in necessary overrides */
             OVRDBF     FILE(UPDLVCB) TOFILE(&BASELIB/UPDLVCL0)
             OVRDBF     FILE(UPDLVCM) TOFILE(&MRGLIB/UPDLVCL0)
 
             CALL       PGM(UP0098) PARM(&TITLE)
 
             DLTOVR     FILE(UPDLVCB)
             DLTOVR     FILE(UPDLVCM)
 
             GOTO       CMDLBL(END)
 ABNOR:
             RTVMSG     MSGID(UPM0001) MSGF(UTMSGF) +
                          MSGDTA('UPC0098') MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE('Check +
                          joblog for details')
             MONMSG     MSGID(CPF0000)                                                    /*CPK015*/
             CALL       PGM(SCC0010) PARM('UPC0098' 'JOBLOG' 'Y')
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CPK015*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
