/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AK Dealing A/c Keys Generation Menu')           */
/*********************************************************************/
/*                                                                   */
/*   Midas - Account Key Generator                           */
/*                                                                   */
/*      AKC20  - Dealing Account Keys Generation Menu                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 131108             Date 06Oct98              */
/*       Prev Amend No. 092374             Date 07Jan97              */
/*                      S01408             Date 04May95              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       131108 - Screen not redisplayed after output of U5 message  */
/*                which requires shortening                          */
/*      092374 - Manage double keys                                  */
/*      S01408 - Addition Of Core Hook AKC20MP1                      */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
             DCLF       FILE(*LIBL/AKC20DF)
/*                                                                   */
             DCL       VAR(&JOB)    TYPE(*CHAR) LEN(10)
             DCL       VAR(&USRID)  TYPE(*CHAR) LEN(10)
             DCL       VAR(&LDA)    TYPE(*CHAR) LEN(256)
             DCL       VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL       VAR(&DMLIB)  TYPE(*CHAR) LEN(7)
             DCL       VAR(&LIBR)   TYPE(*CHAR) LEN(2)
             DCL       VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL       VAR(&RUNA)   TYPE(*CHAR) LEN(7)
             DCL       VAR(&WRN)    TYPE(*LGL)  LEN(1)  VALUE('0')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                   */
/* Create LDA if it does not already exist.                          */
/*                                                                   */
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNA)
             RTVJOBA    JOB(&JOB) USER(&USRID)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(END))
             CHGJOB     SWS(00000000)
/*                                                                   */
/*  Set up Copyright                                                 */
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             OVRDBF     FILE(ZACKEYAL) SEQONLY(*NO)
/*                                                                   */
/* Set up DM library with correct prefix.                            */
/*                                                                   */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&LIBR) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&LIBR *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,AKC20MP1                                            */
                                                                      /*S01408*/
/*                                                                   */
/* Create CHECKAK object - used to check if any records in work file */
/*                                                                   */
             CHKOBJ     OBJ(QTEMP/CHECKAK) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDUPOBJ  OBJ(ZACKEYAL) FROMLIB(&DMLIB) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(CHECKAK) +
                          DATA(*YES)
             ENDDO
/*                                                                   */
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Display menu. User may enter '1' or '2'.                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
   RDSPLY:   SNDRCVF    RCDFMT(MENUDL1)
             SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/*                                                                 */
/* If F3 pressed, send warning message if keys still exist in work */
/* file.                                                           */
/*                                                                 */
             IF         COND(&IN03) THEN(DO)
              IF         COND(&WRN) THEN(DO)
              CLRPFM     FILE(*LIBL/ZACKEYAL)
              GOTO       CMDLBL(END)
              ENDDO
             ELSE       CMD(DO)
              CPYF       FROMFILE(*LIBL/ZACKEYAL) TOFILE(QTEMP/CHECKAK) +
                          MBROPT(*REPLACE)
              MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(END))
/*                                                                  */
              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('There +
                          are still keys in the work file which +
                          will be lost unless you transfer') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
              CHGVAR     VAR(&WRN) VALUE('1')
              GOTO       CMDLBL(RDSPLY)
             ENDDO
             ENDDO
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  Menu option 1  -  Input generation parameters & produce report   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             IF         COND(&OPTION *EQ '1') THEN(DO)
             CPYF       FROMFILE(*LIBL/ZACKEYAL) TOFILE(QTEMP/CHECKAK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)  EXEC(DO)
 GENERATE:   CLRPFM     FILE(*LIBL/ZACKEYAL)
 
/*                                                                   */
/* Call RPG Generation Program & monitor for messages                */
/*                                                                   */
             CALL       PGM(AK0020)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Dealing Generation failed. Re-input +
                          necessary. Press ENTER to continue.') +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
             RTVJOBA    JOB(&JOB)
/* N.B.                                                              */
/* Database errors handled by Access Objects in RPG ACKEYDL.         */
/*                                                                   */
/* If Dealing Generation returns normally, test if keys generated    */
/* successfully, produce report and redisplay menu.                  */
/*                                                                   */
             CHGVAR     VAR(&OPTION) VALUE(' ')
             CPYF       FROMFILE(*LIBL/ZACKEYAL) TOFILE(QTEMP/CHECKAK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)  EXEC(GOTO  CMDLBL(RDSPLY))
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Keys +
                          are being generated..') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             DLYJOB     DLY(3)
/*                                                                   */
/*   Call RPG Report Program & monitor for messages.                 */
/*                                                                   */
             CALL       PGM(AK0120)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Report failed. Press ENTER to +
                          continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
             GOTO       CMDLBL(RDSPLY)
             ENDDO
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Display error screen if keys already exist in temporary file      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
   RDSPLY2:  SNDRCVF    RCDFMT(MENUDL2)
             SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/*                                                                   */
/*  If 'A' entered, clear file and generate new set of keys.         */
/*                                                                   */
             IF         COND(&REPLY *EQ 'A') THEN(DO)
             CHGVAR     VAR(&OPTION) VALUE(' ')
             CHGVAR     VAR(&REPLY)  VALUE(' ')
             GOTO CMDLBL(GENERATE)
             ENDDO
/*                                                                   */
/*  If 'B' entered, do not generate & return to menu of options.     */
/*                                                                   */
             IF         COND(&REPLY *EQ 'B') THEN(DO)
             CHGVAR     VAR(&OPTION) VALUE(' ')
             CHGVAR     VAR(&REPLY)  VALUE(' ')
             GOTO CMDLBL(RDSPLY)
             ENDDO
/*                                                                   */
/*  If F3 pressed, send error message.                               */
/*                                                                   */
             IF         COND(&IN03) THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('0')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Function Key not allowed') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY2)
             ENDDO
/*                                                                   */
/*  If neither 'A' or 'B' entered, display error message.            */
/*                                                                   */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          option - enter A or B') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY2)
             ENDDO
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  Menu option 2  -  Transfer generated keys to live files          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             IF         COND(&OPTION *EQ '2') THEN(DO)
             CPYF       FROMFILE(*LIBL/ZACKEYAL) TOFILE(QTEMP/CHECKAK) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('There +
                          are no keys in the work file - use option +
                          1 to generate') TOPGMQ(*EXT) MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY)
             ENDDO
/*                                                                   */
/*   Call RPG to update live files and monitor for errors.           */
/*                                                                   */
             CHGJOB SWS(XXXX0XXX)                                   /*092374*/
             CALL       PGM(AK0100)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transfer failed. Enter to continue.') +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
             RTVJOBA    JOB(&JOB)
/*                                                                   */
/* For database errors recover data from LDA.                        */
/*                                                                   */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/*********************************************************************092374*/
/**If*Dealing*Transfer*completes*normally,*clear*work*file*and********092374*/
/**redisplay*menu.****************************************************092374*/
/*********************************************************************092374*/
/* If Deeling  Transfer completes normally, do not clear work file    092374*/
/* redisplay menu.                                                    092374*/
/*                                                                    092374*/
             CHGVAR     VAR(&OPTION) VALUE(' ')
/************CLRPFM     FILE(*LIBL/ZACKEYAL)                          092374*/
             IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)            /*092374*/
/*           SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Keys +   /*131108*/
/*                     transferred successfully to live but some +
/*                     A/C keys are double and are still in work file +
/*                     If you want to transfer again don''t forget to  +
/*                     delete same keys in master file or come back at the-
/*                     the begining to clear work file') +
/*                     TOPGMQ(*EXT) MSGTYPE(*STATUS)           /*092374 131108*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Not all +
                          Keys transferred to live.  Some +
                          duplicates exist in the work file') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)             /*131108*/
             GOTO       CMDLBL(RDSPLY)                              /*131108*/
             ENDDO                                                  /*092374*/
             ELSE DO                                                /*092374*/
             CLRPFM     FILE(*LIBL/ZACKEYAL)                        /*092374*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Keys +
                          transferred successfully to live file') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             GOTO       CMDLBL(RDSPLY)
             ENDDO                                                  /*092374*/
             ENDDO
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  Invalid menu option - send error message.                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             IF         COND(&OPTION *NE '1' *AND &OPTION *NE '2') +
                          THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          option - enter 1 or 2') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             ENDDO
/*                                                                   */
             GOTO       CMDLBL(RDSPLY)
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Error handling.                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
  DBERR:     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(*LIBL/MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(*LIBL/MOPERQ)
             GOTO       CMDLBL(END)
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Close of program processing.                                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
  END:
             DLTF       FILE(QTEMP/CHECKAK)
             CLRPFM     FILE(*LIBL/ZACKEYAL)
             RETURN
             ENDPGM
