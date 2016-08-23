/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Project Book Position Events')               */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC1105 - PROJECT BOOK POSITION EVENTS                     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408                  DATE 11MAY95         */
/*       PREV AMEND NO. S01117                  DATE  10JAN91       */
/*                      S01189                  DATE  10JAN91       */
/*                      S01220                  DATE  20/07/90      */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*         S01408 - Addition of core hook SEC1105MPS                */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2          */
/*         S01220 - STRATEGIC RISK MANAGEMENT                       */
/*         S01179 - ABS RELEASE                                     */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)         *S01220* *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)              /*S01220*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                 /*S01220*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)            /*S01220*/
/*/COPY WNCPYSRC,SEC1105001                                          */
                                                                     /*S01220*/
/* DETERMINE LIBRARY PREFIX AND FORM LIBRARY NAME */                 /*S01220*/
                                                                     /*S01220*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)               /*S01220*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))           /*S01220*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01220 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1105MPS                                          */
                                                                      /*S01408*/
                                                                     /*S01220*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC1105 - Project Book +
                          Position Events')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CHECK FOR COMPONENT RESTART */                                    /*S01220*/
/* THIS CHECK AND COPY OF FILE PIBKPD NEEDED BECAUSE SE1440 HAS   */ /*S01220*/
/* BEEN AMENDED TO UPDATE A FIELD ON PIBKPD                       */ /*S01220*/
                                                                     /*S01220*/
/************RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)    *S01220* *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
                                                                     /*S01220*/
/* IF RESTART, OVERRIDE FILE TO SEQONLY(*YES 100) */                 /*S01220*/
                                                                     /*S01220*/
/************IF         COND(&BUSY *EQ 'NEW') THEN(DO)        *S01220* *S01189*/
             IF         COND(&BUSY *EQ 'Y') THEN(DO)                  /*S01189*/
                OVRDBF     FILE(XPIBKPD) SEQONLY(*YES 100)           /*S01220*/
                                                                     /*S01220*/
/* AND COPY FILE */                                                  /*S01220*/
                                                                     /*S01220*/
                CPYF       FROMFILE(XPIBKPD) TOFILE(PIBKPD)          /*S01220*/+
                             MBROPT(*REPLACE) FMTOPT(*NONE)          /*S01220*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)            /*S01220*/+
                             EXEC(CLRPFM FILE(PIBKPD))               /*S01220*/
                                                                     /*S01220*/
/* CHANGE DATA AREA TO 'OLD' */                                      /*S01220*/
                                                                     /*S01220*/
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')  *S01220* *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
                                                                     /*S01220*/
             ENDDO                                                   /*S01220*/
                                                                     /*S01220*/
/* ELSE BACKUP FILES */                                              /*S01220*/
                                                                     /*S01220*/
             ELSE       CMD(DO)                                      /*S01220*/
                                                                     /*S01220*/
/* OVERRIDE TO SEQONLY(*YES 100) */                                  /*S01220*/
                                                                     /*S01220*/
                OVRDBF     FILE(PIBKPD) SEQONLY(*YES 100)            /*S01220*/
                OVRDBF     FILE(XPIBKPD) SEQONLY(*YES 100)           /*S01220*/
                                                                     /*S01220*/
/* DELETE COPY FILE */                                               /*S01220*/
                                                                     /*S01220*/
                DLTF       FILE(XPIBKPD)                             /*S01220*/
                MONMSG     MSGID(CPF0000)                            /*S01220*/
                                                                     /*S01220*/
/* AND COPY FILE */                                                  /*S01220*/
                                                                     /*S01220*/
                CPYF       FROMFILE(PIBKPD) TOFILE(&TOLIB/XPIBKPD)   /*S01220*/+
                             MBROPT(*REPLACE) CRTFILE(*YES)          /*S01220*/+
                             FMTOPT(*NONE)                           /*S01220*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)            /*S01220*/+
                             EXEC(CLRPFM FILE(XPIBKPD))              /*S01220*/
                                                                     /*S01220*/
             ENDDO                                                   /*S01220*/
                                                                     /*S01220*/
/* CHANGE DATA AREA TO 'NEW' */                                      /*S01220*/
                                                                     /*S01220*/
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')     *S01220* *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
                                                                     /*S01220*/
/* CLEAR OUTPUT FILES */
 
             CLRPFM     FILE(BPEVED)
             CLRPFM     FILE(BPEVEA)
             CLRPFM     FILE(RMSPEVP)                               /* S01220*/
 
/* OVERRIDE FILE USED IN CALLED PROGRAMS */
 
             OVRDBF     FILE(SECEF) SHARE(*NO)
             OVRDBF     FILE(SECEFRM) SHARE(*NO)                     /*S01220*/
/*/COPY WNCPYSRC,SEC1105002                                          */
 
/* CALL PROGRAM */
 
             CALL       PGM(SE1440)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC1105 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
              CHGVAR     VAR(&MEM) VALUE('SEC1105 - File Controls Out +
                          of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* IF U7 AND U8 OFF, CHANGE SESTAT TO 'OLD' */                       /*S01220*/
                                                                     /*S01220*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)             /*S01220*/
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')  *S01220* *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
                                                                     /*S01220*/
/* CLEAR FILES */                                                    /*S01220*/
                                                                     /*S01220*/
                DLTF       FILE(XPIBKPD)                             /*S01220*/
                MONMSG     MSGID(CPF0000)                            /*S01220*/
                                                                     /*S01220*/
             ENDDO                                                   /*S01220*/
                                                                     /*S01220*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                ENDPGM
