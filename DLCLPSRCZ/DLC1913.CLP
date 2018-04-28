/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA/IRS Summary File Rebuild Control')       */
/********************************************************************/
/*                                                                  */
/* Midas - FRA/IRS Module                                   */
/*                                                                  */
/* DLC1913 - CONTROL SUMMARY REBUILD                                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01194            DATE  17NOV89             */
/*       PREV AMEND NO. S01157            DATE  15/07/88            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01194 - NEW STANDING DATA                                 */
/*       S01157 - NEW PROGRAM FOR FRA/IRS PROJECT                   */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&SLT) TYPE(*CHAR) LEN(14) VALUE('vdat +
                          *ge      ')
 
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&FIRST) TYPE(*CHAR) LEN(1) VALUE(Y)
 
             DCLF       FILE(SDBANKPD)                                /*S01194*/
/************DCLF       FILE(TABTB10)*************************/       /*S01194*/
 
/* GLOBAL MSG TRAP                                                   */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
             RCVF
 
/* MONITOR FOR EOF */
 
             MONMSG     MSGID(CPF0864) EXEC(DO)
 
/**************SNDPGMMSG  MSG('DATABASE IN ERROR - TABTB11') +******/ /*S01194*/
/*************************TOMSGQ(MOPERQ MRUNQ)**********************/ /*S01194*/
             SNDPGMMSG  MSG('DATABASE IN ERROR - SDBANKPD') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01194*/
 
               GOTO       CMDLBL(END)
 
             ENDDO
 
             CLRPFM     FILE(DLDLHBPP)
 
             CLRPFM     FILE(DLDSMBPP)
 
             CLRPFM     FILE(DLIRSSPP)
 
/************CLRPFM*****FILE(DLMSB1PP)******************************/ /*S01194*/
             CLRPFM     FILE(DLMSY1PP)                                /*S01194*/
 
/************CLRPFM*****FILE(DLMSM1PP)******************************/ /*S01194*/
             CLRPFM     FILE(DLMSY2PP)                                /*S01194*/
 
/************CLRPFM*****FILE(DLMSB2PP)******************************/ /*S01194*/
             CLRPFM     FILE(DLMST1PP)                                /*S01194*/
 
/************CLRPFM*****FILE(DLMSM2PP)******************************/ /*S01194*/
             CLRPFM     FILE(DLMST2PP)                                /*S01194*/
 
/* CALL IRS SUMMARY REBUILD                                          */
 
             CALL       PGM(DL1910) PARM(&TERM)
 
/* IF PROGRAM TERMINATED ABNORMALLY                                  */
 
             IF         COND(&TERM *EQ 'E') THEN(DO)
 
               SNDPGMMSG  MSG('DATABASE IN ERROR - DL1910') +
                          TOMSGQ(MOPERQ MRUNQ)
 
               GOTO       CMDLBL(END)
 
             ENDDO
 
/* CALL FRA DEALING POSITIONS REBUILD                                */
 
             CALL       PGM(DL1903) PARM(&TERM)
 
/* IF PROGRAM TERMINATED ABNORMALLY                                  */
 
             IF         COND(&TERM *EQ 'E') THEN(DO)
 
               SNDPGMMSG  MSG('DATABASE IN ERROR - DL1903') +
                          TOMSGQ(MOPERQ MRUNQ)
 
               GOTO       CMDLBL(END)
 
             ENDDO
 
/* OPEN QUERY FILE TO SELECT RCDS WITH VAL DATE GREATER THAN OR EQUAL+
 DATE OF NEXT WORKING DAY - FILE DLDLDGLA */
 
             OVRDBF     FILE(DLDLDGLA) SHARE(*YES)
 
/************CHGVAR     VAR(%SST(&SLT 10 5)) VALUE(&RUND)***********/ /*S01194*/
             CHGVAR     VAR(%SST(&SLT 10 5)) VALUE(&BJRDNB)           /*S01194*/
 
             OPNQRYF    FILE((DLDLDGLA)) OPTION(*INP) QRYSLT(&SLT) +
                          KEYFLD(*FILE)
 
/* CALL CREATE MONTHLY SUMMARY 1                                     */
 
             CALL       PGM(DL1906) PARM(&TERM)
 
/* IF PROGRAM TERMINATED ABNORMALLY                                  */
 
             IF         COND(&TERM *EQ 'E') THEN(DO)
 
               SNDPGMMSG  MSG('DATABASE IN ERROR - DL1906') +
                          TOMSGQ(MOPERQ MRUNQ)
 
               GOTO       CMDLBL(END)
 
             ENDDO
 
/* CLOSE QUERY FILE - DLDLDGLA                                       */
 
             CLOF       OPNID(DLDLDGLA)
 
/* OPEN QUERY FILE TO SELECT RCDS WITH VAL DATE GREATER THAN OR EQUAL+
 DATE OF NEXT WORKING DAY - FILE DLDLDGLB */
 
             OVRDBF     FILE(DLDLDGLB) SHARE(*YES)
 
             OPNQRYF    FILE((DLDLDGLB)) OPTION(*INP) QRYSLT(&SLT) +
                          KEYFLD(*FILE)
 
/* CALL CREATE MONTHLY SUMMARY 2                                     */
 
             CALL       PGM(DL1907) PARM(&TERM)
 
/* IF PROGRAM TERMINATED ABNORMALLY                                  */
 
             IF         COND(&TERM *EQ 'E') THEN(DO)
 
               SNDPGMMSG  MSG('DATABASE IN ERROR - DL1907') +
                          TOMSGQ(MOPERQ MRUNQ)
 
               GOTO       CMDLBL(END)
 
             ENDDO
 
/* CLOSE QUERY FILE - DLDLDGLB                                       */
 
             CLOF       OPNID(DLDLDGLB)
 
             GOTO       CMDLBL(END)
 
/* SET &FIRST TO PREVENT LOOPING IF FOR EG. LDA DOESN'T EXIST        */
 
 ABNOR:      IF         COND(&FIRST *EQ 'Y') THEN(DO)
 
               CHGVAR     VAR(&FIRST) VALUE(N)
 
               CHGJOB     SWS(XXXXXX11)
 
               CHGDTAARA  DTAARA(LDA (171 7)) VALUE(DLC1913)
 
               DMPCLPGM
 
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
