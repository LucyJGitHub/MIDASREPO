/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI daily cashier interface files set-up')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4407 - CI Daily Cashier Interface Files Set-Up           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRT008             Date 18Oct02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 25Feb02              */
/*                      CRT005             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163583             Date 05Jul99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCI001             Date 10Nov98              */
/*                      122060             Date  5Aug97              */
/*                      CRT003 *CREATE     Date 22Jul96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRT008 - Cashier forwarding enhancement                     */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       CRT005 - Cashier Enhancement Cash In/Cash Out               */
/*       163583 - Insert MONMSG on DSPOBJD CASHDTAQ                  */
/*       CCI001 - Midas Cashier Enhancements - dtaq RECASH in XLIB   */
/*                not DILIB                                          */
/*       122060 - Drafts Issuance.                                   */
/*       CRT003 - Cashier Interface.                                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*********** DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)       */       /*CCI001*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)                /*CCI001*/
             DCL        VAR(&PREF)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&SEQ)   TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&RCV)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD)  TYPE(*CHAR) LEN(7) VALUE(' ')                         /*CRT005*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)                                  /*CRT005*/
                                                                                          /*CRT005*/
 
             DCLF       FILE(SDBAITPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/
/**Get*System*Prefix*and*concat*to*DPLIB****************************/ /*CCI001*/
/**/                                                                  /*CCI001*/
                                                                      /*CCI001*/
/*********** RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)       */   /*CCI001*/
/*********** CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')   */   /*CCI001*/
 
/**/                                                                  /*CCI001*/
/* Get System Prefix and concat to XLIB */                            /*CCI001*/
/**/                                                                  /*CCI001*/
                                                                      /*CCI001*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)            /*CCI001*/
             CHGVAR     VAR(&XLIB) VALUE(&PREF *TCAT 'XLIB')          /*CCI001*/
 READ:
             RCVF       RCDFMT(SDBAITD0)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))
 
             IF         COND(&FXDQLN *GT 0) THEN(DO)
/********************** DLTDTAQ    DTAQ(&DPLIB/&FXDQNM) */            /*CCI001*/
/************           DLTDTAQ    DTAQ(&XLIB/&FXDQNM)                         /*CCI001*/ /*CPK015*/
/************           MONMSG     MSGID(CPF2105)                                         /*CPK015*/
/********************** CRTDTAQ    DTAQ(&DPLIB/&FXDQNM) MAXLEN(&FXDQLN) +
/**********************   TEXT(&FXTXDS)                 */            /*CCI001*/
/************           CRTDTAQ    DTAQ(&XLIB/&FXDQNM) MAXLEN(&FXDQLN)  +
/************             TEXT(&FXTXDS)                                        /*CCI001*/ /*CPK015*/
/************           MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))                /*CPK015*/
                        CALL       PGM(QCLRDTAQ) PARM(&FXDQNM '*LIBL')                    /*CPK015*/
                        ENDDO
 
             GOTO       CMDLBL(READ)
EOF:
                                                                                          /*CRT005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CRT005' +
                          &DSFDY)                                                         /*CRT005*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                                      /*CRT005*/
                CALL       PGM(QCLRDTAQ) PARM('RE412200E' '*LIBL ')                       /*CRT005*/
                CALL       PGM(QCLRDTAQ) PARM('RE412200F' '*LIBL ')                       /*CRT005*/
                CALL       PGM(QCLRDTAQ) PARM('RE41220JE' '*LIBL ')                       /*CRT005*/
                CALL       PGM(QCLRDTAQ) PARM('RE41220JF' '*LIBL ')                       /*CRT005*/
             ENDDO                                                                        /*CRT005*/
 
/**/
/* Clear Cashier Interface  files */
/**/
             CLRPFM     FILE(REPLOGPD)
             CLRPFM     FILE(REACJBPD)
             CLRPFM     FILE(RECITFPD)
             CLRPFM     FILE(RECIADPD)
             CLRPFM     FILE(RECISCPD)
             CLRPFM     FILE(RECICSPD)
             CLRPFM     FILE(RECICFPD)
             CLRPFM     FILE(REFWDEPD)                                /*CRT008*/
             CLRPFM     FILE(REPDRIPD)                                /*122060*/
                                                                      /*122060*/
/**/                                                                  /*122060*/
/* Clear transaction data queues CASHxxxxxx where xxxxxx is the job*/ /*122060*/
/**/                                                                  /*122060*/
             DSPOBJD    OBJ(CASH*) OBJTYPE(*DTAQ) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/CASHDTAQ)                     /*122060*/
             MONMSG     MSGID(CPF2123)                                /*163583*/
             CALL       PGM(REC4408)                                  /*122060*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*122060*/
                          GOTO CMDLBL(ABNOR)                          /*122060*/
             ENDDO                                                    /*122060*/
 
/**/
/* Reset data areas */
/**/
             CHGDTAARA  DTAARA(CISTAT (1 6)) VALUE('000001')
             CHGDTAARA  DTAARA(CIREST (1 10)) VALUE('          ')
             CHGDTAARA  DTAARA(CITFSQ (1 6)) VALUE('000001')
             CHGDTAARA  DTAARA(CITFTS (1 2)) VALUE('01')
 
/**/
/* Retrieve latest journal sequence and journal entry */
/**/
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) SEARCH(*DESCEND) +
                          RTNSEQNBR(&SEQ) RTNRCV(&RCV)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**/
/* Update trickle feed header, reset branch status */
/**/
             CALL       PGM(RE4407) PARM(&RCV &SEQ)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4407 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
