/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER automatic allocation process')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC6700 - SE ER Automatic Allocation Process                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK016             Date 04Jun03              */
/*       Prev Amend No. CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      094535             DATE 20OCT95              */
/*                      S01408             DATE 10MAY95              */
/*                      S01496             DATE 25OCT94              */
/*                      S10978             DATE 07APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CSC017 - Change to 250 library list.                        */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       094535 - Change the library list to have QTEMP at the top   */
/*                 of this job only                                  */
/*       S01408 - Addition of core hook SEC6700MPS                   */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL       VAR(&PARM)   TYPE(*CHAR) LEN(6)
             DCL       VAR(&MEM)    TYPE(*CHAR) LEN(52)
             DCL       VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL       VAR(&DLIB)   TYPE(*CHAR) LEN(10)
             DCL       VAR(&RSEQ)   TYPE(*CHAR) LEN(5)                /*S01496*/
/************DCL        VAR(&LIBL) TYPE(*CHAR) LEN(275)                     */ /*094535*/ /*CSC017*/
/************DCL        VAR(&CMD) TYPE(*CHAR) LEN(285)                      */ /*094535*/ /*CSC017*/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(2750)                                  /*CSC017*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2764)                                   /*CSC017*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*USE)
 
/* Start commitment control */                                                            /*CPK016*/
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*NONE)                          CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*NONE) CMTSCOPE(*JOB) */           /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             SNDPGMMSG  MSG('SE6700 - SE ER Automatic Allocation +
                          Processing') TOMSGQ(MRUNQ)
 
             RTVJOBA    USRLIBL(&LIBL)                                /*094535*/
             RMVLIBLE   LIB(QTEMP)                                    /*094535*/
             MONMSG     MSGID(CPF2104)                                /*094535*/
             ADDLIBLE   LIB(QTEMP) POSITION(*FIRST)                   /*094535*/
             MONMSG     MSGID(CPF2103 CPF2110 CPF2118)                /*094535*/
 
/* Copy file    */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DLIB')     */ /*S01496*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')       /*S01496*/
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC6700MPS                                          */
                                                                      /*S01408*/
             CPYF       FROMFILE(&DLIB/SETPALPD) +
                          TOFILE(QTEMP/SETPALPD) MBROPT(*NONE) +
                          CRTFILE(*YES)
 
             CLRPFM     FILE(QTEMP/SETPALPD)
/*/COPY WNCPYSRC,SEC6700001                                          */
 
/* Call RPG Pgm */
             CALL       PGM(SE6700) PARM(&PARM)
 
/* If error */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6700 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO      CMDLBL(END)                                 /*S01496*/
             ENDDO
 
/* Call RPG Pgm */
/*********** CALL       PGM(SE6800) PARM(' ' &PARM)                */ /*S01496*/
             CALL       PGM(SE6800) PARM(' ' &PARM &RSEQ)             /*S01496*/
 
/* If error */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6700 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
END:                                                                  /*S01496*/
             CHGVAR     VAR(&CMD) VALUE('CHGLIBL (' *CAT &LIBL *TCAT +
                          ')')                                        /*094535*/
/************CALL       PGM(QCMDEXC) PARM(&CMD 285)                         */ /*094535*/ /*CSC017*/
             CALL       PGM(QCMDEXC) PARM(&CMD 2764)                                      /*CSC017*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
