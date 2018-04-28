/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Statement Fees Generation')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC5314 - STATEMENT FEES GENERATION                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 121058             Date 11FEB98              */
/*       PREV AMEND NO. S01408             DATE 05MAY95              */
/*                      CPK002             DATE 17MAY95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       121058 - Retail Statement Charges Fix                       */
/*       S01408 - Addition of core hook REC5314MP1                   */
/*       CPK002 - Remove creation parameters which were using the    */
/*                adoption profile - USRPRF(*OWNER) -                */
/*                Use the standard CLP creation parameters instead.  */
/*       S01413 - Retail 3 Incorporation.                            */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*121058*/
             PGM        PARM(&MODE)                                   /*121058*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*121058*/
             DCL        VAR(&ANWD) TYPE(*CHAR) LEN(1)                 /*121058*/
             DCLF       FILE(TABTBRE)
 
/**/
/*    Check if 'Statement Charges' Ind. is on. */
/**/
             RCVF       RCDFMT(TABTBREF)
             IF         COND(&TSTMC *EQ 'Y') THEN(DO)
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/**/                                                                  /*121058*/
/*  Bypass component if this is the first component and type of   */  /*121058*/
/*  run is 'Accrual Day followed by a Non-working Day'            */  /*121058*/
/**/                                                                  /*121058*/
             CHGVAR    VAR(&ANWD) VALUE(%SST(&SDSTAT 116 1))          /*121058*/
             IF         COND(&MODE *EQ '1' *AND &ANWD *EQ '3') THEN(+
                GOTO       CMDLBL(ENDPGM))                            /*121058*/
 
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC5314MP1                                          */
                                                                      /*S01408*/
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
             SNDPGMMSG  MSG('REC5314 - Statement fees generation') +
                        TOMSGQ(MRUNQ) +
                        MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/*  SET OFF ALL SWITCHES                                            */
 
             CHGJOB SWS(00000000)
/**/                                                                  /*121058*/
/*  If component is running prior to Post 5 (i.e. &MODE = '2'),   */  /*121058*/
/*  then override to new files GESF2PD and GESF2ZZ                */  /*121058*/
/**/                                                                  /*121058*/
             IF         COND(&MODE *EQ '2') THEN(DO)                  /*121058*/
                CLRPFM     FILE(GESF2PD)                              /*121058*/
                MONMSG     MSGID(CPF0000)                             /*121058*/
                CLRPFM     FILE(GESF2ZZ)                              /*121058*/
                MONMSG     MSGID(CPF0000)                             /*121058*/
                OVRDBF     FILE(GESFPD) TOFILE(GESF2PD)               /*121058*/
                OVRDBF     FILE(GESFZZ) TOFILE(GESF2ZZ)               /*121058*/
             ENDDO                                                    /*121058*/
 
/*  CLEAR EXTRACT FILES                                             */
 
                CLRPFM     FILE(GESFPD)
                   MONMSG MSGID(CPF0000)
                CLRPFM     FILE(GESFZZ)
                   MONMSG MSGID(CPF0000)
 
             CALL       PGM(RE5314)
 
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
 
                 SNDPGMMSG  MSGID(PEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             ENDDO
/**/                                                                  /*121058*/
/*  End of program  */                                                /*121058*/
/**/                                                                  /*121058*/
ENDPGM:                                                               /*121058*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
