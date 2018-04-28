/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI COB generation for TI postings')             */
/*********************************************************************/
/*                                                                   */
/*       Midas/TI Interface                                          */
/*                                                                   */
/*       TIC0360 - TI COB Events Generation for TI postings          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CTI001  *CREATE    Date 28JUN97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CTI001 - Midas/TI Interface (Phase 1)                       */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10) VALUE('TIC0360')
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0) VALUE(1)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(50)
 
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('TIC0360 - TI COB Events Generation for +
                          TI Postings') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas Local Data Area'))
 
 
/*  Check the status of restart flag  */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
 
/*  If this is not a restart  */
             IF         COND(&BUSY *EQ 'N') THEN(DO)
/*  Update status to 'Y' in case component fails to update the file */
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y')
             ENDDO
 
/*  Main processing  */
             CLRPFM     FILE(BVNTXEA)
             CLRPFM     FILE(BVNTXED)
             CLRPFM     FILE(BVNTXEZ)
 
             CALL       PGM(TI0360)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
 
/* Abnormal termination processing */
 ABNOR:      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&LDA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
