/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Sweeps processed control')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC0732 - Sweeps Processed Control                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. 155098             Date 15Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE004 *CREATE     Date 20Jan97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       155098 - Real time post can result in double sweep.  Add    */
/*                new parameter as existing one is used for multiple */
/*                checks.                                            */
/*       CRE004 - Sweep Accounting.                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Program variables */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&ANWD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&UPD) TYPE(*CHAR) LEN(1) VALUE('Y')
/* Start of 155098 */
             DCL        VAR(&CUPD) TYPE(*CHAR) LEN(1) VALUE('Y')    /*155098*/
/* End of 155098 */
             DCL        VAR(&FRF) TYPE(*CHAR) LEN(7) VALUE('GESPPD ')
             DCL        VAR(&TOF) TYPE(*CHAR) LEN(7) VALUE('REEODPF')
/*/COPY WNCPYSRC,REC0732005                                          */
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('REC0732 Sweep Processing') TOMSGQ(MRUNQ +
                          MOPERQ)
 
/* Get system prefix from data area  */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&DPLIB) VALUE(&LID *CAT 'DPLIB')
             RTVDTAARA DTAARA(SDSTAT (116 1)) RTNVAR(&ANWD)
 
/* Get component status  */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If a restart */
 
             IF         COND(&STAT *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(&DPLIB/XRESWEPPD) TOFILE(RESWEPPD) +
                          MBROPT(*REPLACE)
/*/COPY WNCPYSRC,REC0732001                                          */
             ENDDO
             ELSE       CMD(DO)
             CPYF       FROMFILE(RESWEPPD) TOFILE(&DPLIB/XRESWEPPD) +
                          MBROPT(*ADD) CRTFILE(*YES)
/*/COPY WNCPYSRC,REC0732002                                          */
               CHGVAR    VAR(&STAT) VALUE('Y')
               CALL      PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
/* Clear  Work Files */
 
             IF         COND(&CSEQ *EQ 00001) THEN(DO)
               CLRPFM     FILE(GESPPD)
               CLRPFM     FILE(GESPZZ)
             ENDDO
 
             IF         COND(&CSEQ *EQ 00002) THEN(DO)
               CLRPFM   FILE(GESP2PD)
               CLRPFM   FILE(GESP2ZZ)
               OVRDBF   FILE(GESPPD) TOFILE(GESP2PD)
               OVRDBF   FILE(GESPZZ) TOFILE(GESP2ZZ)
               CHGVAR   VAR(&FRF) VALUE('GESP2PD')
             ENDDO
/*/COPY WNCPYSRC,REC0732006                                          */
 
/* Set off job switches */
 
             CHGJOB     SWS(00000000)
 
/* Generate SWEEP entries */
/* Do not update Next Sweep Date if this is the first component */
/*    and type of run is accrual day followed by a non-working day */
 
             IF         COND(&CSEQ *EQ 00001 *AND &ANWD *EQ '3') +
                          THEN(CHGVAR VAR(&UPD) VALUE('N'))
/* Start of 155098 */
             IF         COND(&CSEQ *NE 00001) +
                          THEN(CHGVAR VAR(&CUPD) VALUE('N'))          /*155098*/
/*********** CALL       PGM(RE0732) PARM(&UPD)        **********/     /*155098*/
             CALL       PGM(RE0732) PARM(&UPD &CUPD)                  /*155098*/
/* End of 155098 */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Add Generated Sweep Entries (Retail Postings only) */
/* from PF/GESPPD/GESP2PD to PF/REEODPF  */
 
/*/COPY WNCPYSRC,REC0732003                                          */
               CPYF       FROMFILE(&FRF) TOFILE(&TOF) MBROPT(*ADD) +
                          INCREL((*IF RIND *EQ 1) (*AND RECI *EQ 'P')) +
                          FMTOPT(*MAP *DROP)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2802) EXEC(DO)
                 CHGJOB   SWS(XXXXXX11)
                 CHGVAR  VAR(&MEM) VALUE('File ' *CAT &FRF *TCAT ' +
                         not found - REC0732')
                 SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
               ENDDO
             ENDDO
 
/* Database Error */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG  MSG('Database error - RE0732') TOMSGQ(MRUNQ +
                          MOPERQ)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
             ELSE       CMD(DO)
               DLTF     &DPLIB/XRESWEPPD
/*/COPY WNCPYSRC,REC0732004                                          */
               CHGVAR   VAR(&STAT) VALUE('N')
               CALL     PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Unmonitored error */
 
 ABNOR:      SNDPGMMSG  MSG('RE0732 ended in error - check joblog') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
