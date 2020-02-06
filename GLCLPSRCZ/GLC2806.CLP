/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis File Transfer Process')               */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-Fontis Interface                                 */
/*                                                                  */
/*   GLC2806 - Fontis File Transfer Process                         */
/*                                                                  */
/*   Function : This program checks each message file for each      */
/*              member of LF/GLFREFL0 by calling GL2806. It then    */
/*              transfers the file using GLC2807. GL2806 is then    */
/*              recalled to update the status of the file on        */
/*              LF/GLFREFL0. Finally when all accepted files have   */
/*              been listed, all files are checked by calling       */
/*              GLC2808.                                            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Prev Amendment No. CGL004 *CREATE   Date 07MAR97               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   MD046248 - Finastra Rebranding                                 */
/*   CGL004 - Midas-Fontis Interface                                */
/*                                                                  */
/*********************************************************************/
 
             PGM        PARM(&WAITTM)
 
/* Copyright statement.                                              */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* Declare variables.                                                */
             DCL        VAR(&SYSPRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&GLFONT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIBNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MTYPE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MAXTRY) TYPE(*DEC) LEN(1)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(30)
             DCL        VAR(&WAITTM) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&F3MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&F3DNLS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(10 0)
 
/* Declare file.                                                     */
             DCLF       FILE(GLFREFL0)
 
/* Global Message Monitor.                                           */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Send message to MRUNQ.                                            */
             SNDPGMMSG  MSG('GLC2806 - Fontis File Processing') +
                          TOMSGQ(MRUNQ)
 
/* Set off all user job switches.                                   */
             CHGJOB     SWS(00000000)
 
/* Check Line Device and Controller                                  */
/**/
/*       VFYTCPCNN                                                   */
/**/
 
             OVRDBF     FILE(GLFREFL0) SHARE(*NO)
 
/* Recieve first record from GLFREFL0.                               */
 LOOP:       RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))
 
/* If file is not FONTIS942 or not already processed, process        */
/* transfer request.                                                 */
             IF         COND(&F3MBRN *NE 'FONTIS942' *AND (&F3DNLS = +
                          'P' *OR &F3DNLS = 'R')) THEN(DO)
               CLRPFM     FILE(GLFOINPD)
 
/* Retrieve system ID from Data area SDSTAT.                         */
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPRE)
 
/* Set parameters for calling GL2806.                                */
               CHGVAR     VAR(&LIBNAM) VALUE(&SYSPRE *CAT 'DMLIB')
               CHGVAR     VAR(&MODE) VALUE('*SEND')
               CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
               CHGVAR     VAR(&MTYPE) VALUE('940')
               CHGVAR     VAR(&RTCD) VALUE(' ')
               CHGVAR     VAR(&MAXTRY) VALUE('0')
               CHGVAR     VAR(&HOST) VALUE(' ')
               CHGVAR     VAR(&WAITTM) VALUE('0')
 
/* Call GL2806 to set up transfer request.                           */
               CALL       PGM(GL2806) PARM(&MODE &LIBNAM &MBRNM +
                          &MTYPE &RTCD &MAXTRY &HOST &WAITTM)
 
                 IF         COND(&RTCD *NE ' ') THEN(DO)
                   IF         COND(&RTCD = 'SENT') THEN(SNDPGMMSG +
                          MSG('File already sent') TOMSGQ(MOPERQ))
                   ELSE       CMD(GOTO CMDLBL(ABNOR))
                 ENDDO
                 ELSE       CMD(DO)
 
/* Retrieve Fontis enabled flag from Data Area GLFONTDA.             */
                 RTVDTAARA  DTAARA(GLFONTDA (30 1)) RTNVAR(&GLFONT)
                   IF           COND(&GLFONT = 'Y') THEN(DO)
                    RTVMBRD FILE(GLFDTAPD) MBR(&F3MBRN) NBRCURRCD(&COUNT)
                    IF           COND(&COUNT >  0) THEN(DO)
 
/* Call GLC2807 to transfer the file.                                */
                     CALL       PGM(GLC2807) PARM(&HOST &MAXTRY &RTCD)
 
/* If transfer was successful, then call GL2806 to update file.      */
                     IF         COND(&RTCD *EQ 'READY') THEN(DO)
 
/* Set up parameters for calling GL2806.                             */
                     CHGVAR     VAR(&MODE) VALUE('*DOWNLD')
                     CHGVAR     VAR(&LIBNAM) VALUE(' ')
                     CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
                     CHGVAR     VAR(&MTYPE) VALUE('940')
                     CHGVAR     VAR(&RTCD) VALUE(' ')
                     CHGVAR     VAR(&MAXTRY) VALUE('0')
                     CHGVAR     VAR(&HOST) VALUE(' ')
                     CHGVAR     VAR(&WAITTM) VALUE('0')
 
                     CALL       PGM(GL2806) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST &WAITTM)
 
                     ENDDO
 
/* Transfer was not successful, call GL2806 to update file.          */
                     ELSE       CMD(DO)
 
/* Set up parameters for calling GL2806                              */
                     CHGVAR     VAR(&MODE) VALUE('*FAIL')
                     CHGVAR     VAR(&LIBNAM) VALUE(' ')
                     CHGVAR     VAR(&MBRNM) VALUE(&F3MBRN)
                     CHGVAR     VAR(&MTYPE) VALUE('940')
                     CHGVAR     VAR(&RTCD) VALUE(' ')
                     CHGVAR     VAR(&MAXTRY) VALUE('0')
                     CHGVAR     VAR(&HOST) VALUE(' ')
                     CHGVAR     VAR(&WAITTM) VALUE('0')
 
                     CALL       PGM(GL2806) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST &WAITTM)
                     GOTO       CMDLBL(ABNOR)
                     ENDDO
                    ENDDO
                   ENDDO
                 ENDDO
               ENDDO
             GOTO       CMDLBL(LOOP)
 
/* All MT940 messages have been sent, transfer MT942 file.           */
 ENDLOOP:    RTVDTAARA  DTAARA(GLFONTDA (27 1)) RTNVAR(&GLFONT)
             IF         COND(&GLFONT *EQ 'Y') THEN(DO)
               CLRPFM     FILE(GLFOINPD)
 
/* Retrieve system ID from Data area SDSTAT.                         */
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPRE)
 
/* Set up parameters for calling of GL2806.                          */
               CHGVAR     VAR(&MODE) VALUE('*SEND')
               CHGVAR     VAR(&LIBNAM) VALUE(&SYSPRE *CAT 'DMLIB')
               CHGVAR     VAR(&MBRNM) VALUE('FONTIS942')
               CHGVAR     VAR(&MTYPE) VALUE('942')
               CHGVAR     VAR(&RTCD) VALUE(' ')
               CHGVAR     VAR(&MAXTRY) VALUE('0')
               CHGVAR     VAR(&HOST) VALUE(' ')
               CHGVAR     VAR(&WAITTM) VALUE('0')
 
/* Call GL2806 to set up transfer request for MT942 file.            */
               CALL       PGM(GL2806) PARM(&MODE &LIBNAM &MBRNM +
                          &MTYPE &RTCD &MAXTRY &HOST &WAITTM)
 
               IF         COND(&RTCD *NE ' ') THEN(DO)
                 IF         COND(&RTCD = SENT) THEN(DO)
                 SNDPGMMSG  MSG('File already sent.') TOMSGQ(MOPERQ)
                 ENDDO
                 ELSE       CMD(GOTO CMDLBL(ABNOR))
                 ENDDO
               ELSE       CMD(DO)
               RTVDTAARA  DTAARA(GLFONTDA (30 1)) RTNVAR(&GLFONT)
                 IF         COND(&GLFONT = 'Y') THEN(DO)
                  RTVMBRD FILE(GLFDTAPD) MBR(FONTIS942) NBRCURRCD(&COUNT)
                  IF           COND(&COUNT >  0) THEN(DO)
 
/* Call GLC2807 to transfer FONTIS942 member.                        */
                   CALL       PGM(GLC2807) PARM(&HOST &MAXTRY &RTCD)
 
/* Transfer successful, call GL2806 to update file.                 */
                   IF         COND(&RTCD *EQ 'READY') THEN(DO)
 
/* Set up parameters for calling of GL2806.                          */
                   CHGVAR     VAR(&MODE) VALUE('*DOWNLD')
                   CHGVAR     VAR(&LIBNAM) VALUE(' ')
                   CHGVAR     VAR(&MBRNM) VALUE('FONTIS942')
                   CHGVAR     VAR(&MTYPE) VALUE('942')
                   CHGVAR     VAR(&RTCD) VALUE(' ')
                   CHGVAR     VAR(&MAXTRY) VALUE('0')
                   CHGVAR     VAR(&HOST) VALUE(' ')
                   CHGVAR     VAR(&WAITTM) VALUE('0')
 
                   CALL       PGM(GL2806) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST &WAITTM)
                   ENDDO
 
/* Transfer was not successful, call GL2806 to update file.          */
                   ELSE       CMD(DO)
 
/* Set up parameters for calling of GL2806.                         */
                   CHGVAR     VAR(&MODE) VALUE('*FAIL')
                   CHGVAR     VAR(&LIBNAM) VALUE(' ')
                   CHGVAR     VAR(&MBRNM) VALUE('FONTIS942')
                   CHGVAR     VAR(&MTYPE) VALUE('942')
                   CHGVAR     VAR(&RTCD) VALUE(' ')
                   CHGVAR     VAR(&MAXTRY) VALUE('0')
                   CHGVAR     VAR(&HOST) VALUE(' ')
                   CHGVAR     VAR(&WAITTM) VALUE('0')
 
                   CALL       PGM(GL2806) PARM(&MODE &LIBNAM &MBRNM +
                              &MTYPE &RTCD &MAXTRY &HOST &WAITTM)
                   ENDDO
                  ENDDO
                 ENDDO
               ENDDO
             ENDDO
 
/* All files have been sent, check status of accepted files.         */
             CLRPFM     FILE(GLFOINPD)
 
/* Set up parameters for calling of GL2806.                          */
             CHGVAR     VAR(&MODE) VALUE('*CHECK')
             CHGVAR     VAR(&LIBNAM) VALUE(' ')
             CHGVAR     VAR(&MBRNM) VALUE(' ')
             CHGVAR     VAR(&MTYPE) VALUE('   ')
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CHGVAR     VAR(&MAXTRY) VALUE('0')
             CHGVAR     VAR(&HOST) VALUE(' ')
             CHGVAR     VAR(&WAITTM) VALUE('0')
 
/* Call GL2806 to set up list request.                               */
             CALL       PGM(GL2806) PARM(&MODE &LIBNAM &MBRNM &MTYPE +
                          &RTCD &MAXTRY &HOST &WAITTM)
 
/* Call GLC2808 to check accepted files.                             */
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CALL       PGM(GLC2808) PARM(&HOST &MAXTRY &RTCD)
             GOTO       CMDLBL(END)
 
/* Abnormal Processing                                               */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC2806 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
