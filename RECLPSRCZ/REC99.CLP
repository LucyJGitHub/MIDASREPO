/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Error E2473 (re)')                              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                             */
/*                                                                  */
/*     REC99  -  PREPARATION OF CLEAR FILE                          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*     Last Amend No. LUC110             Date 24Jan19                */
/*     Prev Amend No. CER049             Date 06Dec10                */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    089310             DATE 27FRB98               */
/*                    BHF982             DATE 19FEB91               */
/*                    S01189             DATE 13MAR90               */
/*                    S01179             DATE 21/10/88              *  *S01098*/
/*                    S01098             DATE 21/07/86              *  *S01098*/
/*                    E2473              DATE 19/02/85              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     LUC110  -  Extended Narratives (Upgrade NUC002 to FBM 2.1)   */
/*                Use of core hook REC99001                         */
/*                Use of core hook REC99003                         */
/*     CER049  -  Stamp Tax                                         */
/*     089310  -  Do not do RMVM/ADDLFM on SACPO as it may take     */
/*                longer, and prevents other programs using SACPO   */
/*                to update other Generated Events files.           */
/*     BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                      */
/*     S01189  -  CLOSE OF BUSINESS IMPROVEMENTS                    */
/*     S01179  -  AS/400 CONVERSION                                 */
/*     S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,          *  *S01098*/
/*                INSTEAD OF CLEARING AND ADDING                    *  *S01098*/
/*                FROM AND TO FILES ARE NOW 'BLOCKED'               *  *S01098*/
/*                                                                  */
/********************************************************************/
/*           PGM */                                                    /*E2473*/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/********    PGM PARM(&ACCR)                                /*E2473*/ /*S01189*/
             PGM                                                      /*S01189*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL VAR(&ACCR) TYPE(*CHAR) LEN(5)                         /*E2473*/
/*/COPY WNCPYSRC,REC99001                                            */
/**/                                                                  /*S01189*/
/*   OBTAIN ACCRUAL TYPE FROM CLOSE OF BUSINESS DATA AREA          */ /*S01189*/
             RTVDTAARA  DTAARA(CBSTAT (46 5)) RTNVAR(&ACCR)           /*S01189*/
/**/                                                                  /*S01189*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILES OVER PHYSICALS BEFORE COPYING     */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
/*/COPY WNCPYSRC,REC99002                                            */
             RMVM       FILE(CLEAR) MBR(CLEAR)                        /*S01098*/
             MONMSG     MSGID(CPF0000)                                /*S01098*/
/************RMVM       FILE(SACPO) MBR(SACPO)              */ /*S01098 089310*/
/************MONMSG     MSGID(CPF0000)                      */ /*S01098 089310*/
/**/
/*********   CLRPFM FILE(CLEARHH)                          **********  *S01098*/
/*********   CLRPFM FILE(CLEARPD)                          **********  *S01098*/
/*********   CLRPFM FILE(CLEARZZ)                          **********  *S01098*/
/**/
/*********   CPYF FROMFILE(CLEAROHH) TOFILE(CLEARHH) MBROPT(*ADD) + *  *S01098*/
/*********        FMTOPT(*NOCHK)                                    *  *S01098*/
             CPYF       FROMFILE(CLEAROHH) TOFILE(CLEARHH) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
             MONMSG     (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CLEARHH)                          /*S01098*/
/*********   CPYF FROMFILE(CLEAROPD) TOFILE(CLEARPD) MBROPT(*ADD) + *  *S01098*/
/*********        FMTOPT(*NOCHK)                                    *  *S01098*/
             CPYF       FROMFILE(CLEAROPD) TOFILE(CLEARPD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
             MONMSG     (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CLEARPD)                          /*S01098*/
/*********   CPYF FROMFILE(CLEAROZZ) TOFILE(CLEARZZ) MBROPT(*ADD) + *  *S01098*/
/*********        FMTOPT(*NOCHK)                                    *  *S01098*/
             CPYF       FROMFILE(CLEAROZZ) TOFILE(CLEARZZ) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*S01098*/
             MONMSG     (CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM CLEARZZ)                          /*S01098*/
/*/COPY WNCPYSRC,REC99003                                            */
                                                                                          /*CER049*/
             CPYF       FROMFILE(GLCLERPD) TOFILE(CLEARPD) +
                          MBROPT(*ADD) FMTOPT(*NONE)                                      /*CER049*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CER049*/
                                                                                          /*CER049*/
             CALL       PGM(GL008145)                                                     /*CER049*/
/**/
/*           ADDLFM     FILE(CLEAR) MBR(CLEAR) */          /*S01098*/ /*BHF982*/
             ADDLFM     FILE(CLEAR) MBR(CLEAR) SHARE(*YES)            /*BHF982*/
             MONMSG     MSGID(CPF0000)                                /*S01098*/
/**/                                                                  /*S01098*/
             IF COND(&ACCR = 'THREE') THEN(DO)                         /*E2473*/
/**/                                                                  /*S01098*/
/*  BLOCK FILES   */                                                  /*S01098*/
/**/                                                                  /*S01098*/
                OVRDBF     FILE(GEIC2PD) SEQONLY(*YES 100)            /*S01098*/
                OVRDBF     FILE(GEICPD) SEQONLY(*YES 100)             /*S01098*/
/**/                                                                  /*S01098*/
/*   REMOVE LOGICAL FILES OVER PHYSICALS BEFORE COPYING     */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                RMVM       FILE(GEIC) MBR(GEIC)                       /*S01098*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/**/                                                                  /*S01098*/
/*********      CLRPFM FILE(GEICPD)                      *  *E2473***  *S01098*/
/*********      CLRPFM FILE(GEICZZ)                      *  *E2473***  *S01098*/
/* FOLLOWING FOUR LINES INSERTED UNDER ERROR E2473 */                  /*E2473*/
/*********      CPYF FROMFILE(GEIC2PD) TOFILE(GEICPD) MBROPT(*ADD) +*  *S01098*/
/*********        FMTOPT(*NOCHK)                         *  *E2473***  *S01098*/
                CPYF       FROMFILE(GEIC2PD) TOFILE(GEICPD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM GEICPD)                        /*S01098*/
/*********      CPYF FROMFILE(GEIC2ZZ) TOFILE(GEICZZ) MBROPT(*ADD) +*  *S01098*/
/*********        FMTOPT(*NOCHK)                         *  *E2473***  *S01098*/
                CPYF       FROMFILE(GEIC2ZZ) TOFILE(GEICZZ) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM GEICZZ)                        /*S01098*/
                CLRPFM FILE(GEIC2PD)                                   /*E2473*/
                CLRPFM FILE(GEIC2ZZ)                                   /*E2473*/
/**/                                                                  /*S01098*/
/*              ADDLFM     FILE(GEIC) MBR(GEIC) */         /*S01098*/ /*BHF982*/
                ADDLFM     FILE(GEIC) MBR(GEIC) SHARE(*YES)           /*BHF982*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/**/                                                                  /*S01098*/
                DLTOVR     FILE(GEIC2PD)                              /*S01098*/
                DLTOVR     FILE(GEICPD)                               /*S01098*/
/**/                                                                  /*S01098*/
             ENDDO                                                     /*E2473*/
/**/                                                                   /*E2473*/
/************ADDLFM     FILE(SACPO) MBR(SACPO) */          /*S01098*/ /*BHF982*/
/************ADDLFM     FILE(SACPO) MBR(SACPO) SHARE(*YES)  */ /*BHF982 089310*/
/************MONMSG     MSGID(CPF0000)                      */ /*S01098 089310*/
/**/                                                                  /*S01098*/
/*/COPY WNCPYSRC,REC99004                                            */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
