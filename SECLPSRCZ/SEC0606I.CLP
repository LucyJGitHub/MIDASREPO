/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Mature Customer/User Depot Posns')           */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0606I - MATURE CUSTOMER/USER DEPOT POSITIONS            */
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
/*                      S01117             Date 08Jan91              */
/*                      S01189                  DATE  08JAN91       */
/*                      E16870                  DATE  08/03/89      */
/*                      S01179                  DATE  19/12/88      */
/*                      E15498                  DATE  04/10/88      */
/*                      E14236                  DATE  12/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook SEC0606IMS                  *  *E15549*/
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            *  *S01189*/
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    *  *E16870*/
/*       S01179 - AS400 CHANGES                                     */
/*       E15498 - SECURITY COPIES XCDEPPD AND XUDEPPD ARE NOT       */
/*                COPIED WITH CRTFILE(*YES), CAUSING CPF            */
/*                MESSAGE TO BE GENERATED.                          */
/*       E14236 - NEW PROGRAM TO MATURE POSITIONS                   */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*E15498*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*E15498*/
 
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
/*           DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(256)             E16870*/
/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)   *E16870* *S01189*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
                                                                      /*E15498*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*E15498*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0606IMS                                          */
                                                                      /*S01408*/
 
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0606I - Mature Cust/User +
                          Depot Positions')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
 
/* CHECK FOR COMPONENT RESTART                                      */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/* IF RESTART                       */
 
/************IF COND(&BUSY = 'NEW') THEN(DO)                         * *S01189*/
             IF COND(&BUSY = 'Y') THEN(DO)                            /*S01189*/
 
/* COPY FILES                       */
 
                CPYF FROMFILE(XCDEPPD) TOFILE(CDEPPD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CDEPPD)
 
                CPYF FROMFILE(XUDEPPD) TOFILE(UDEPPD) +
                MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM UDEPPD)
 
/* CHANGE DATA AREA                     */
 
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
             ENDDO
 
/*   SAVE TO BE UPDATED FILES TO X(filename)                        */
 
             DLTF       FILE(XCDEPPD)                                 /*E15498*/
             MONMSG MSGID(CPF0000)                                    /*E15498*/
             DLTF       FILE(XUDEPPD)                                 /*E15498*/
             MONMSG MSGID(CPF0000)                                    /*E15498*/
/*           CPYF FROMFILE(CDEPPD) TOFILE(XCDEPPD) +
             MBROPT(*REPLACE) FMTOPT(*NONE)                        */ /*E15498*/
/*           MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCDEPPD)                                  */ /*E15498*/
             CPYF FROMFILE(CDEPPD) TOFILE(&TOLIB/XCDEPPD)   MBROPT(*REPLACE) +
CRTFILE(*YES)  FMTOPT(*NONE)            /*E15498*/
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XCDEPPD)                                     /*E15498*/
 
/*           CPYF FROMFILE(UDEPPD) TOFILE(XUDEPPD) +
             MBROPT(*REPLACE) FMTOPT(*NONE)                        */ /*E15498*/
/*           MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XUDEPPD)                                  */ /*E15498*/
             CPYF FROMFILE(UDEPPD) TOFILE(&TOLIB/XUDEPPD)  MBROPT(*REPLACE) +
CRTFILE(*YES)  FMTOPT(*NONE)            /*E15498*/
             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
             EXEC(CLRPFM XUDEPPD)                                     /*E15498*/
 
/* CHANGE DATA AREA   TO 'NEW'          */
 
/************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')             * *S01189*/
             CHGVAR    VAR(&BUSY) VALUE('Y')                          /*S01189*/
             CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)                 /*S01189*/
 
 
/*  CALL SE2365 (UPDATE) */
 
             CALL       PGM(SE2365)
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0606I - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
              CHGVAR    VAR(&MEM) VALUE('SEC0606I - File Controls out +
                          of Balance')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* NORMAL COMPLETION */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* CHANGE DATA AREA   TO 'OLD'          */
 
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
 
/**/
             DLTF       FILE(XCDEPPD)                                 /*E15498*/
             MONMSG MSGID(CPF0000)                                    /*E15498*/
             DLTF       FILE(XUDEPPD)                                 /*E15498*/
             MONMSG MSGID(CPF0000)                                    /*E15498*/
             ENDDO
 
 
/*ENDPGM:*********ENDPGM                                             * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
