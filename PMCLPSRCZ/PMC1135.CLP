/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Update LB Portfolio Holdings')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1135 - PM Matured Positions                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPM005             Date 03Jul96              */
/*                      091910             Date 01Jun95              */
/*                      080736             DATE 22DEC94              */
/*                      S01486             DATE 11AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      049467             DATE 18JAN93              */
/*                      B08253             DATE 04OCT91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       091910 - Wrong files PMPLEGQ0/Q1 used.                      */
/*       080736 - Wrong file used                                    */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       049467 - RECOMPILED FOR RELEASE 3 PTF 02                    */
/*       B08253 - EXTRACT MATURE/FLAT POSITION TO THE NEW            */
/*                'MATURED' HOLDINGS FILE                            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*           PGM                                               B08040*/
             PGM        PARM(&WWTVPS)                        /*B08040*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCL        VAR(&WWTVPS) TYPE(*CHAR) LEN(1)      /*B08040*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CPM005*/
 
/* SET OFF SWITCHES                                                 */
             CHGJOB     SWS(00000000)
/*********** OVRDBF     FILE(PMPLEGPO) TOFILE(SDPLCSPD) SHARE(*YES)*/ /*S01486*/
/*********** OVRDBF     FILE(PMPLEGPN) TOFILE(SDPLCSLL) SHARE(*YES)*/ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** OPNQRYF    FILE((*LIBL/SDPLCSPD) (LBPLEGPD)) +        */ /*S01486*/
/***********              FORMAT(PMPLEGPO) QRYSLT('QBRECI = "D" & +*/ /*S01486*/
/***********              (PGRECI = "M") & (PGHLEX *EQ " ") & +    */ /*S01486*/
/***********            (PGTYPE = "P" *OR PGTYPE = "C" *OR PGTYPE +*/ /*S01486*/
/***********            = "S" *OR PGTYPE = "G")') KEYFLD((PGCNUM) +*/ /*S01486*/
/***********              (PGCCY)) JFLD((PGCNUM *MAPFLD/WWCUST)) + */ /*S01486*/
/***********              MAPFLD((WWCUST QBCUST *ZONED 6 0))       */ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** OPNQRYF    FILE((*LIBL/SDPLCSLL) (LBPLEGPD)) +        */ /*S01486*/
/***********              FORMAT(PMPLEGPN) QRYSLT('QBRECI = "D" & +*/ /*S01486*/
/***********              (PGRECI = "M") & (PGHLEX *EQ " " *OR +   */ /*S01486*/
/***********              PGHLEX *EQ "O") & (PGTYPE = "P" *OR +    */ /*S01486*/
/***********             PGTYPE = "C" *OR PGTYPE = "S" *OR PGTYPE +*/ /*S01486*/
/***********              = "G")') KEYFLD((PGISSB) (PGCCY)) +      */ /*S01486*/
/***********              JFLD((PGISSB *MAPFLD/WWCUST)) +          */ /*S01486*/
/***********              MAPFLD((WWCUST QBCUST *ZONED 6 0))       */ /*S01486*/
                                                                      /*S01486*/
/**** OVRDBF     FILE(PMPLEGQ1) TOFILE(SDPLCSPD) SHARE(*YES)   /*S01486 080736*/
/**** OVRDBF     FILE(PMPLEGQ0) TOFILE(SDPLCSL0) SHARE(*YES)   /*S01486 080736*/
/************OVRDBF     FILE(PMPLEGQ0) TOFILE(SDPLCSPD) SHARE(*080736 /*091910*/
/************OVRDBF     FILE(PMPLEGQ1) TOFILE(SDPLCSL0) SHARE(*080736 /*091910*/
                                                                      /*S01486*/
/*********** OPNQRYF    FILE((*LIBL/SDPLCSPD) (LBPLEGPD)) +
                          FORMAT(PMPLEGQ1) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "M") & (PGHLEX *EQ " ") & +
                          (PGTYPE = "P" *OR PGTYPE = "C" *OR PGTYPE +
                          = "S" *OR PGTYPE = "G")') KEYFLD((PGCNUM) +
                          (PGCCY)) JFLD((PGCNUM *MAPFLD/WWCUST)) +
                          MAPFLD((WWCUST QBCUST *ZONED 6 0))   /*S01486 080736*/
/************OPNQRYF    FILE((*LIBL/SDPLCSPD) (LBPLEGPD)) +           /*091910*/
/************             FORMAT(PMPLEGQ0) QRYSLT('QBRECI = "D" & +   /*091910*/
/************             (PGRECI = "M") & (PGHLEX *EQ " ") & +       /*091910*/
/************             (PGTYPE = "P" *OR PGTYPE = "C" *OR PGTYPE + /*091910*/
/************             = "S" *OR PGTYPE = "G")') KEYFLD((PGCNUM) + /*091910*/
/************             (PGCCY)) JFLD((PGCNUM *MAPFLD/WWCUST)) +    /*091910*/
/************             MAPFLD((WWCUST QBCUST *ZONED 6 0)) *080736* /*091910*/
                                                                      /*S01486*/
/*********** OPNQRYF    FILE((*LIBL/SDPLCSL0) (LBPLEGPD)) +
                          FORMAT(PMPLEGQ0) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "M") & (PGHLEX *EQ " " *OR +
                          PGHLEX *EQ "O") & (PGTYPE = "P" *OR +
                          PGTYPE = "C" *OR PGTYPE = "S" *OR PGTYPE +
                          = "G")') KEYFLD((PGISSB) (PGCCY)) +
                          JFLD((PGISSB *MAPFLD/WWCUST)) +
                          MAPFLD((WWCUST QBCUST *ZONED 6 0))   /*S01486 080736*/
/************OPNQRYF    FILE((*LIBL/SDPLCSL0) (LBPLEGPD)) +          /*091910*/
/************             FORMAT(PMPLEGQ1) QRYSLT('QBRECI = "D" & +  /*091910*/
/************             (PGRECI = "M") & (PGHLEX *EQ " " *OR +     /*091910*/
/************             PGHLEX *EQ "O") & (PGTYPE = "P" *OR +      /*091910*/
/************             PGTYPE = "C" *OR PGTYPE = "S" *OR PGTYPE + /*091910*/
/************             = "G")') KEYFLD((PGISSB) (PGCCY)) +        /*091910*/
/************             JFLD((PGISSB *MAPFLD/WWCUST)) +            /*091910*/
/************             MAPFLD((WWCUST QBCUST *ZONED 6 0))*080736* /*091910*/
/**/                                                                  /*CPM005*/
/**  Ensure that SDPLCSL0 is closed */                                /*CPM005*/
             CALL       PGM(AOPLCSR0) PARM('       ' '*FREE  ' +
                           '          ' &FMT)                         /*CPM005*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMPLEGQ1) TOFILE(SDPLCSPD) SHARE(*YES)   /*091910*/
             OVRDBF     FILE(PMPLEGQ0) TOFILE(SDPLCSL0) SHARE(*YES)   /*091910*/
             OPNQRYF    FILE((*LIBL/SDPLCSPD) (LBPLEGPD)) +
                          FORMAT(PMPLEGQ1) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "M") & (PGHLEX *EQ " ") & +
                          (PGTYPE = "P" *OR PGTYPE = "C" *OR PGTYPE +
                          = "S" *OR PGTYPE = "G")') KEYFLD((PGCNUM) +
                          (PGCCY)) JFLD((PGCNUM *MAPFLD/WWCUST)) +
                          MAPFLD((WWCUST QBCUST *ZONED 6 0))          /*091910*/
             OPNQRYF    FILE((*LIBL/SDPLCSL0) (LBPLEGPD)) +
                          FORMAT(PMPLEGQ0) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "M") & (PGHLEX *EQ " " *OR +
                          PGHLEX *EQ "O") & (PGTYPE = "P" *OR +
                          PGTYPE = "C" *OR PGTYPE = "S" *OR PGTYPE +
                          = "G")') KEYFLD((PGISSB) (PGCCY)) +
                          JFLD((PGISSB *MAPFLD/WWCUST)) +
                          MAPFLD((WWCUST QBCUST *ZONED 6 0))         /*091910*/
 
             CALL       PGM(PM1136) PARM(&WWTVPS 'M')
 
             CLOF       OPNID(SDPLCSPD)
/*********** CLOF       OPNID(SDPLCSLL)                            */ /*S01486*/
             CLOF       OPNID(SDPLCSL0)                               /*S01486*/
 
             DLTOVR     FILE(*ALL)
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52))
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          */
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+*/ /*S01486*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        */ /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
/*                                                                    /*R00300*/
             CHGVAR     VAR(&MEM) VALUE('PMC1136  - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
 
/*ENDPGM:      ENDPGM                                              */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
