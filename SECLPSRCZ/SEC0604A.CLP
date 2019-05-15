/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Generate A/c Keys - Posn Settlmnt')          */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                    */
/*                                                                  */
/*       SEC0604A  GENERATE A/C KEYS - POSITION SETTLEMENTS         */
/*                                                                  */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 236115             Date 21Sep05              */
/*                      234124             Date 29Jun05              */
/*                      233566             Date 02Jun05             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408                  DATE 11MAY95        */
/*                      067415                  DATE  25FEB94       */
/*                      S01189                  DATE  07JAN91       */
/*                      S01117                  DATE  10DEC90       */
/*                      E16870                  DATE  08/03/89      */
/*                      E16847                  DATE  20/02/89      */
/*                      S01179                  DATE  15/12/88      */
/*                      E15623                  DATE  10/10/88      */
/*                      E14884                  DATE  08/09/88      */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   236115 - SEC0604A failed at 16400.                              */
/*   234124 - Recovery of SDCSINPD failed                            */
/*   233566 - Add fields to CDEPPD                                   */
/*   S01408 - Addition of core hook SEC0604AM1                       *  S01189*/
/*   067415 - TAKE COPY OF POSETA AS WELL AS POSETD.                 */
/*   S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2                 */
/*   S01117 - MULTIBRANCHING                                         */
/*   E16870 - SESTAT REDEFINED AS 128 BYTES.                         * *E16870*/
/*   E16847 - OVERRIDE POSETD & POSETA TO USE ONLY RELEVANT MEMBERS  */
/*   S01179 - AS400 CHANGES TO COMMANDS                              */
/*   E15623 - ERROR E14884 INCOMPLETE - &BUSY MUST BE RESET TO       */
/*            'OLD' IF NO ERRORS OCCUR.                              */
/*   E14884 - POSETD NOW UPDATE FILE - SECURITY COPY TAKEN.          */
/*            PROCESSING FOR SESTAT ADDED.                           */
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/*           DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(256)       *E14884E16870*/
/********    DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)    *E16870* *S01189*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)            /*E15623*/
 
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(79)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/********    DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(3)        *E14884* *S01189*/
             DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(1)                /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*E15623*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*E15623*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*233566*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*233566*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*233566*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*233566*/
             DCL        VAR(&CGL031) TYPE(*CHAR) LEN(1)                                   /*233566*/
/*/COPY WNCPYSRC,SEC0604A01                                          */
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0604A - Generate A/C Keys +
                          - Position Settlements')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                                                                                          /*233566*/
/** Check for Switchable feature CGL031 **/                                               /*233566*/
                                                                                          /*233566*/
             CHGVAR      VAR(&OPTN) VALUE('*VERIFY')                                      /*233566*/
/**********  CHGVAR      VAR(&OPTN) VALUE('CGL031') ***/                           /*233566 234124*/
             CHGVAR      VAR(&SARD) VALUE('CGL031')                                       /*234124*/
             CALL        PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                         &FMT)                                                            /*233566*/
             IF          COND(&RTCD *EQ '       ') THEN(CHGVAR +
                           VAR(&CGL031) VALUE('Y'))                                       /*233566*/
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)  *E14884*  /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)             /*E15623*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *E15623 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0604AM1                                          */
                                                                      /*S01408*/
 
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
                                                                     /*E14884*/
/* CHECK FOR COMPONENT RESTART */
 
/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/* COPY FILES */
 
             OVRDBF     FILE(XPOSETD) SEQONLY(*YES 100)               /*E15623*/
             CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +
                          FROMMBR(POSETD) TOMBR(POSETD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETD) MBR(POSETD))
 
             OVRDBF     FILE(XPOSETA) SEQONLY(*YES 100)               /*067415*/
             CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +
                          FROMMBR(POSETA) TOMBR(POSETA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*067415*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETA) MBR(POSETA))                   /*067415*/
                                                                                          /*233566*/
             IF         COND(&CGL031 = 'Y') THEN(DO)                                      /*233566*/
             CPYF       FROMFILE(XSDCSINPD) TOFILE(SDCSINPD) +
                          MBROPT(*REPLACE)                                                /*233566*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SDCSINPD))                                                 /*233566*/
             ENDDO                                                                        /*233566*/
/*/COPY WNCPYSRC,SEC0604A02                                          */
/* CHANGE DATA AREA */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
             ENDDO
 
/* SAVE FILES TO BE UPDATED */
 
/*           CPYF       FROMFILE(POSETD) TOFILE(XPOSETD) +          *  *E15623*/
/*                        FROMMBR(POSETD) TOMBR(POSETD)    +        *  *E15623*/
/*                        MBROPT(*REPLACE) FMTOPT(*NONE)            *  *E15623*/
             CPYF       FROMFILE(POSETD) TOFILE(&TOLIB/XPOSETD) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*E15623*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPOSETD))
 
             CPYF       FROMFILE(POSETA) TOFILE(&TOLIB/XPOSETA) +
                MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*067415*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPOSETA))                     /*067415*/
                                                                                          /*233566*/
             IF         COND(&CGL031 = 'Y') THEN(DO)                                      /*233566*/
             CPYF       FROMFILE(SDCSINPD) +
                          TOFILE(&TOLIB/XSDCSINPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*233566*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDCSINPD))                                                /*236115*/
/***********              FILE(XSDCSINDPD))                       */              /*233566  236115*/
             ENDDO                                                                        /*233566*/
/*/COPY WNCPYSRC,SEC0604A03                                          */
/* CHANGE DATA AREA TO NEW */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
                                                                     /*E14884*/
/* CLEAR OUTPUT FILES                                            */
 
             CLRPFM     FILE(SEKEYD) MBR(PSETTLE)
             CLRPFM     FILE(SEKEYA) MBR(PSETTLE)
 
/* OVERRIDE TO REQUIRED FILE MEMBER                              */
 
             OVRDBF     FILE(SEKEYD) MBR(PSETTLE)
             OVRDBF     FILE(SEKEYA) MBR(PSETTLE)
             OVRDBF     FILE(POSETD) MBR(POSETD)                     /*E16847*/
             OVRDBF     FILE(POSETA) MBR(POSETA)                     /*E16847*/
/*/COPY WNCPYSRC,SEC0604A04                                          */
 
/* CALL PROGRAM                                                  */
 
             CALL       PGM(SE2300)
 
/*/COPY WNCPYSRC,SEC0604A06                                          */
             DLTOVR     FILE(*ALL)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*              RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       */ /*S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0604A - Job Terminated, +
                          Database in Error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             GOTO ENDPGM
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0604A - File Controls Out +
                        Of Balance')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD" & CLEAR PFs            *  *E15623*/
                                                                      /*E15623*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*E15623*/
/********       CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD') *E15623* /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
                DLTF       FILE(XPOSETD)                              /*E15623*/
                DLTF       FILE(XPOSETA)                              /*067415*/
                   MONMSG MSGID(CPF0000)                              /*E15623*/
                IF         COND(&CGL031 = 'Y') THEN(DO)                                   /*233566*/
                   DLTF       FILE(XPOSETA)                                               /*233566*/
                   MONMSG MSGID(CPF0000)                                                  /*233566*/
                ENDDO                                                                     /*233566*/
/*/COPY WNCPYSRC,SEC0604A05                                          */
             ENDDO                                                    /*E15623*/
                                                                      /*E15623*/
 
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
