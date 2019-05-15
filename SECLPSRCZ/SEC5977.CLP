/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Telekurs processing by tape')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5977 - Telekurs Processing By Tape (SERVITIA)            */
/*                                                                   */
/*       Function: Copy Tape file from Servitia to a Telekur file    */
/*                 for Midas processing.  Create Telekur Extract     */
/*                 File and Update the price of securities.          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE009             Date 16Mar99              */
/*                      S01502  *CREATE    Date 08Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE009 - Telekurs Changes                                   */
/*       S01502 - BLI Telekurs Processing.                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,SEC5977001                                          */
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
             DCL        VAR(&TELK)   TYPE(*CHAR) LEN(7) VALUE('       ')                  /*CSE009*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7) VALUE('*FIRST ')                  /*CSE009*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)                                   /*CSE009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSE009*/
             DCL        VAR(&DAYS) TYPE(*DEC) LEN(5 0)                                    /*CSE009*/
                                                                                          /*CSE009*/
             DCLF       FILE(SDBANKPD)                                                    /*CSE009*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
             IF         COND(%SST(&SESTAT 129 1) *EQ 'N') THEN(GOTO +
                          CMDLBL(END))
/*/COPY WNCPYSRC,SEC5977002                                          */
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(00000000)
                                                                                          /*CSE009*/
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)                                         /*CSE009*/
             RCVF                                                                         /*CSE009*/
             CHGVAR     VAR(&DAYS) VALUE(&BJRDNB)                                         /*CSE009*/
                                                                                          /*CSE009*/
             CHGVAR     VAR(&TELK) VALUE('       ')                                       /*CSE009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE009*/
             CHGVAR     VAR(&SAR)  VALUE('CSE009')                                        /*CSE009*/
                                                                                          /*CSE009*/
             CALL       PGM(AOSARDR0) PARM(&TELK &OPTN &SAR &SCSARD)                      /*CSE009*/
 
/**/
/** CHECK IF RERUN                                                   */
/**/
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
             IF         COND((%SST(&SESTAT 130 1) *EQ 'N')) THEN(DO)
 
/**/
/** COPY TO DISK                                                     */
/**/
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
 
             CALL       PGM(SEC5979)
 
             ALCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
             IF         COND((%SST(&SESTAT 130 1) *EQ 'C')) THEN(DO)
             CHGVAR     VAR(%SST(&SESTAT 130 1)) VALUE('N')
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
             GOTO       CMDLBL(END)
             ENDDO
 
/**/
/** SET FLAG THAT TAPE COPIED TO DISK                                */
/**/
             CHGVAR     VAR(%SST(&SESTAT 130 1)) VALUE('Y')
             ENDDO
 
/**/
/** CREATE EXTRACT FILE                                              */
/**/
             IF         COND((%SST(&SESTAT 131 1) *EQ 'N')) THEN(DO)
 
/*/COPY WNCPYSRC,SEC5977003                                          */
             CLRPFM     FILE(TELKXPF2)
/*/COPY WNCPYSRC,SEC5977004                                          */
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(OVRDBF FILE(TELEKR2) +
                          TOFILE(SETKURL0))                                               /*CSE009*/
             CALL       PGM(SE5985)
 
/**/
/** FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
             IF    COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOMSGQ(MOPERQ)
                   GOTO CMDLBL(END)
             ENDDO
/*/COPY WNCPYSRC,SEC5977009                                          */
 
/**/
/** SET FLAG THAT EXTRACT CREATED OK                                 */
/**/
             CHGVAR     VAR(%SST(&SESTAT 131 1)) VALUE('Y')
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
             ENDDO
 
/**/
/** UPDATE SECURITY MASTER FILE - ALLOCATE SECTY FILE                */
/**/
             ALCOBJ     OBJ((SECTY *FILE *EXCLRD))
             MONMSG     MSGID(CPF1002) EXEC(DO)
                SNDPGMMSG  MSG('SECURITIES FILE IN USE - PLEASE RETRY') +
                          TOPGMQ(*EXT)
                GOTO       CMDLBL(END)
             ENDDO
 
/**/
/** UPDATE SECURITY MASTER FILE                                      */
/**/
 
             CALL       PGM(SE5977)
/**/
/** FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
             IF    COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOMSGQ(MOPERQ)
                   GOTO CMDLBL(END)
             ENDDO
 
             DLCOBJ     OBJ((SECTY *FILE   *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
/** SET FLAG THAT SECURITY UPDATED OK                                */
/**/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             CHGVAR     VAR(%SST(&SESTAT 130 2)) VALUE('NN')
             CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
/*/COPY WNCPYSRC,SEC5977007                                          */
             IF         COND((&TELK *EQ '       ') *OR (&DAYS >= +
                          09978)) THEN(DO)                                                /*CSE009*/
                CALL       PGM(SE5986) PARM('     ' '   ')                                /*CSE009*/
                                                                                          /*CSE009*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CSE009*/
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                                     /*CSE009*/
                  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))                           /*CSE009*/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                /*CSE009*/
                  GOTO       CMDLBL(END)                                                  /*CSE009*/
                ENDDO                                                                     /*CSE009*/
             ENDDO                                                                        /*CSE009*/
/*/COPY WNCPYSRC,SEC5977008                                          */
                                                                                          /*CSE009*/
             GOTO       CMDLBL(END)
 
/**/
/** ERROR PROCESSING                                                 */
/**/
 ERROR:      SNDPGMMSG  MSG('TELEKURS PRICES UPDATE ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((SECTY *FILE   *EXCLRD))
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 END:        DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((SESTAT *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,SEC5977005                                          */
             ENDPGM
/*/COPY WNCPYSRC,SEC5977006                                          */
