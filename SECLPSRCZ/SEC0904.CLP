/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Customer Valuation Statements')              */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0904 - CUSTOMER VALUATION STATEMENT                     */
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
/*       Prev Amend No. S01408             Date 11May95              */
/*                      S01502             Date 08Jul94              */
/*                      E30860             DATE 30OCT91              */
/*                      S01117                  DATE  10JAN91       */
/*                      S01189                  DATE  10JAN91       */
/*                      E23408                  DATE  06SEP90       */
/*                      E19137                  DATE  07FEB90       */
/*                      E19821                  DATE  28/07/89      */
/*                      S01219                  DATE  28/07/89      */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*         S01408 - Addition of core hook SEC0904MPS                */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*         E30830 - Wrong RCF sequence parameter is being passed    */
/*         S01117 - MULTIBRANCHING                                  */
/*         S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2          */
/*         E23408 - PRINT CUSTOMER VALUATION STATEMENT IF RETAIL II */
/*                  OR INTEREST ON ACCOUNTS INSTALLED IN SYSTEM.    */
/*         E19137 - SAVE CLINTSE IN CASE OF SE0930 HALT/RESTART     *  *E19821*/
/*         E19821 - DEALS AND RETAIL A/C CASH BALANCES DO NOT       *  *E19821*/
/*                  APPEAR ON THE CUSTOMER VALUATION STATEMENTS.    *  *E19821*/
/*         S01219 - SE MODULE FUNCTIONALITY SPLIT                   */
/*         S01179 - ABS RELEASE                                     */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM    PARM(&CNAM &CSEQ &RENT)                           /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
 
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/   /*S01219 S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)            /*S01502*/
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)              /*E19281*/
                                                                     /*E19281*/
             DCL        VAR(&DL) TYPE(*LGL) LEN(1)                   /*E19281*/
                                                                     /*E19281*/
             DCL        VAR(&RE) TYPE(*LGL) LEN(1)                   /*E19281*/
             DCL        VAR(&IA) TYPE(*LGL) LEN(1)                   /*E23408*/
 
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)         *E19137* *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                 /*E19137*/
 
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)            /*E19137*/
 
/************DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(6)      /*E19137   *S01117*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)               /*S01177*/
/*/COPY WNCPYSRC,SEC0904001                                          */
 
/* RETREIVE SDSTAT */                                                /*E19137*/
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)               /*E19137*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))           /*E19137*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *E19137 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0904MPS                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0904 - Customer +
                          Valuation Statement')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CHECK FOR COMPONENT RESTART */                                    /*E19137*/
 
/************RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)    *E19137* *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF COMPONENT RESTART RESTORE */                                   /*E19137*/
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)          *E19137* *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/* COPY FILES */                                                     /*E19137*/
 
             CPYF       FROMFILE(XCLINTSE) TOFILE(CLINTSE) +
                          MBROPT(*REPLACE) CRTFILE(*NO)              /*E19137*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CLINTSE))                             /*E19137*/
 
/* CHANGE DATA AREA TO 'OLD' */                                      /*E19137*/
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')     *E19137* *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
                ENDDO                                                /*E19137*/
 
             DLTF       FILE(XCLINTSE)                               /*E19137*/
             MONMSG     MSGID(CPF0000)                               /*E19137*/
             CPYF       FROMFILE(CLINTSE) TOFILE(&TOLIB/XCLINTSE) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*E19137*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCLINTSE))                            /*E19137*/
 
/* CHANGE DATA AREA TO 'NEW' */                                      /*E19137*/
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')     *E19137* *S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/**CLEAR*FILES**********/                                             /*S01117*/
 
/************CLRPFM     FILE(CVALSD) MBR(EXTRACT)   */                /*S01117*/
/************CLRPFM     FILE(CVALSA) MBR(EXTRACT)     */              /*S01117*/
 
/**OVERRIDE*TO*FILE*MEMBER*********/                                  /*S01117*/
 
/************OVRDBF     FILE(CVALSD) MBR(EXTRACT) */                  /*S01117*/
/************OVRDBF     FILE(CVALSA) MBR(EXTRACT)   */                /*S01117*/
 
/*DETERMINE MODULES PRESENT BY CHECKING FLAGS IN DTAARA MMOD*/        /*E19821*/
                                                                      /*E19821*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*E19821*/
                                                                      /*E19821*/
             CHGVAR     VAR(&DL) VALUE(%SST(&MMOD 2 1) *EQ 'Y')       /*E19821*/
             CHGVAR     VAR(&RE) VALUE(%SST(&MMOD 16 1) *EQ 'Y')      /*E19821*/
             CHGVAR     VAR(&IA) VALUE(%SST(&MMOD 23 1) *EQ 'Y')      /*E23408*/
                                                                      /*E19821*/
             IF         COND(&DL) THEN(DO)                            /*E19821*/
             CHGJOB     SWS(X1XXXXXX)                                 /*E19821*/
             ENDDO                                                    /*E19821*/
/************IF*********COND(&RE) THEN(DO)                      *E19821*E23408*/
             IF         COND(&RE *OR &IA) THEN(DO)                    /*E23408*/
             CHGJOB     SWS(1XXXXXXX)                                 /*E19821*/
             ENDDO                                                    /*E19821*/
 
/* CALL FREQUENCY BASED CUSTOMER VALUATION STATEMENTS PROGRAM */
 
/************CALL       PGM(SE0930)          */                       /*S01117*/
/************CALL       PGM(SE0930) PARM(&CSEQ) */             /*S01117 E30860*/
/*/COPY WNCPYSRC,SEC0904003                                          */
             CALL       PGM(SE0930)                                   /*E30860*/
/*/COPY WNCPYSRC,SEC0904004                                          */
 
             DLTOVR     FILE(*ALL)
 
/* IF NO ERRORS CALL CUSTOMER VALUATION STATEMENTS PROGRAM */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')  *E19137* *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
                DLTF       FILE(XCLINTSE)                            /*E19137*/
                                                                     /*S01219*/
/* CHECK IF PORTFOLIO PROCESSING IS LICENSED */                      /*S01219*/
                                                                     /*S01219*/
/*/COPY WNCPYSRC,SEC0904007                                          */
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)               /*S01219*/
             IF         COND(%SST(&SESTAT 64 1) *EQ 'Y') THEN(DO)    /*S01219*/
/*/COPY WNCPYSRC,SEC0904008                                          */
                                                                     /*S01219*/
/***************CALL       PGM(SE0935)                                /*S01117*/
/***************CALL       PGM(SE0935) PARM(&CSEQ &RENT)       /*S01117 E20860*/
/*/COPY WNCPYSRC,SEC0904005                                          */
                CALL       PGM(SE0935) PARM('     ' &RENT)            /*E30860*/
/*/COPY WNCPYSRC,SEC0904006                                          */
                                                                     /*S01219*/
/*/COPY WNCPYSRC,SEC0904009                                          */
             ENDDO                                                   /*S01219*/
/*/COPY WNCPYSRC,SEC0904010                                          */
 
             ENDDO
/*/COPY WNCPYSRC,SEC0904002                                          */
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0904 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
               CHGVAR    VAR(&MEM) VALUE('SEC0904 - File Controls Out +
                          of Balance')
               SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
