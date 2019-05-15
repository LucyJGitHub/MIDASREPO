/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Update Portfolio Holdings')                  */
/********************************************************************/
/*                                                                  */
/*       MIDAS AS400 PORTFOLIO MANAGMENT MODULE                 */
/*                                                                  */
/*       PMC1136 - PM - UPDATE LB PORTFOLIO HOLDINGS                */
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
/*       Prev Amend No. CPM005             Date 03Jul96              */
/*                      085813             Date 13Mar95              */
/*                      S01486             DATE 17NOV94              */
/*                      049421             DATE 18JAN93             */
/*                      049467             DATE 18JAN93             */
/*                      B08253             DATE 04OCT91             */
/*                      B08040             DATE 08JUL91             */
/*                      R5570              DATE 02MAR91             */
/*                      R00300             DATE 28AUG90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                Recompiled due to changes in PM files.             */
/*       085813  -  ALTER TO USE FILE LF/SDPLCSL1                   */
/*       S01486  -  Portfolio Management Upgrade to R10             */
/*       049421  -  HEADER BOX STANDARDISATION                      */
/*       049467  -  RECOMPILED FOR RELEASE 3 PTF 02                  */
/*       B08253  -  EXTRACT MATURE/FLAT POSITION TO THE NEW         */
/*                  'MATURED' HOLDINGS FILE                         */
/*       B08040  -  SUNDRY FIXES TO SPEED UP COB                    */
/*       R5570   -  REMOVE SELECTION ON PGALLW IN QUERY FILE        */
/*       B08040  -  SUNDRY FIXES TO SPEED UP COB                    */
/*       R5570   -  REMOVE SELECTION ON PGALLW IN QUERY FILE        */
/*       R00300  -  Message file changes.                           */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM                                               B08040*/
             PGM        PARM(&WWTVPS)                        /*B08040*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*********** DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52) ****/          /*S01486*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCL        VAR(&WWTVPS) TYPE(*CHAR) LEN(1)      /*B08040*/
 
 
/* SET OFF SWITCHES                                                 */
             CHGJOB     SWS(00000000)
/*********** OVRDBF     FILE(PMPLEGPO) TOFILE(SDPLCSPD) SHARE(*YES)*/ /*S01486*/
/*********** OVRDBF     FILE(PMPLEGPN) TOFILE(SDPLCSLL) SHARE(*YES)*/ /*S01486*/
             OVRDBF     FILE(PMPLEGQ1) TOFILE(SDPLCSPD) SHARE(*YES)   /*S01486*/
/***********OVRDBF FILE(PMPLEGQ0) TOFILE(SDPLCSLL) SHARE(*YES)*S01486* *085813*/
             OVRDBF     FILE(PMPLEGQ0) TOFILE(SDPLCSL1) SHARE(*YES)   /*085813*/
                                                                      /*S01486*/
/*R5571 B08253 OPNQRYF    FILE((*LIBL/SDPLCSPD) (LBPLEGPD)) +
                          FORMAT(PMPLEGPO) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "D" *OR PGRECI = "M") & (PGTYPE +
                          = "P" *OR PGTYPE = "C" *OR PGTYPE = "S" +
                          *OR PGTYPE = "G")') +
                          KEYFLD((PGCNUM) (PGCCY)) JFLD((PGCNUM +
                          *MAPFLD/WWCUST)) MAPFLD((WWCUST QBCUST +
                          *ZONED 6 0)) */
 
/*R5571 B08253 OPNQRYF    FILE((*LIBL/SDPLCSLL) (LBPLEGPD)) +
                          FORMAT(PMPLEGPN) QRYSLT('QBRECI = "D" +
                          & (PGRECI = "D" *OR PGRECI = "M") & +
                          (PGTYPE = "P" *OR PGTYPE = "C" *OR PGTYPE +
                          = "S" *OR PGTYPE = "G")') +
                          KEYFLD((PGISSB) (PGCCY)) JFLD((PGISSB +
                          *MAPFLD/WWCUST)) MAPFLD((WWCUST QBCUST +
                          *ZONED 6 0)) */
 
/*  R5571 B08253 */
/************OPNQRYF    FILE((*LIBL/SDPLCSPD) (LBPLEGPD)) +           /*S01486*/
/************             FORMAT(PMPLEGPO) QRYSLT('QBRECI = "D" & +   /*S01486*/
/************             (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE + /*S01486*/
/************             = "C" *OR PGTYPE = "S" *OR PGTYPE = +       /*S01486*/
/************             "G")') KEYFLD((PGCNUM) (PGCCY)) +           /*S01486*/
/************             JFLD((PGCNUM *MAPFLD/WWCUST)) +             /*S01486*/
/************             MAPFLD((WWCUST QBCUST *ZONED 6 0))          /*S01486*/
             OPNQRYF    FILE((*LIBL/SDPLCSPD) (LBPLEGPD)) +
                          FORMAT(PMPLEGQ1) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE +
                          = "C" *OR PGTYPE = "S" *OR PGTYPE = +
                          "G")') KEYFLD((PGCNUM) (PGCCY)) +
                          JFLD((PGCNUM *MAPFLD/WWCUST)) +
                          MAPFLD((WWCUST QBCUST *ZONED 6 0))          /*S01486*/
/************                                                         /*S01486*/
/*  R5571 B08253 */
/************OPNQRYF    FILE((*LIBL/SDPLCSLL) (LBPLEGPD)) +           /*S01486*/
/************             FORMAT(PMPLEGPN) QRYSLT('QBRECI = "D" & +   /*S01486*/
/************             (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE + /*S01486*/
/************             = "C" *OR PGTYPE = "S" *OR PGTYPE = +       /*S01486*/
/************             "G")') KEYFLD((PGISSB) (PGCCY)) +           /*S01486*/
/************             JFLD((PGISSB *MAPFLD/WWCUST)) +             /*S01486*/
/************             MAPFLD((WWCUST QBCUST *ZONED 6 0))          /*S01486*/
/************OPNQRYF    FILE((*LIBL/SDPLCSLL) (LBPLEGPD)) +          * *085813*/
/************             FORMAT(PMPLEGQ0) QRYSLT('QBRECI = "D" & +  * *085813*/
/************             (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE +* *085813*/
/************             = "C" *OR PGTYPE = "S" *OR PGTYPE = +      * *085813*/
/************             "G")') KEYFLD((PGISSB) (PGCCY)) +          * *085813*/
/************             JFLD((PGISSB *MAPFLD/WWCUST)) +            * *085813*/
/************             MAPFLD((WWCUST QBCUST *ZONED 6 0))  *S01486* *085813*/
             OPNQRYF    FILE((*LIBL/SDPLCSL1) (LBPLEGPD)) +
                          FORMAT(PMPLEGQ0) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE +
                          = "C" *OR PGTYPE = "S" *OR PGTYPE = +
                          "G")') KEYFLD((PGISSB) (PGCCY)) +
                          JFLD((PGISSB *MAPFLD/WWCUST)) +
                          MAPFLD((WWCUST QBCUST *ZONED 6 0))          /*085813*/
 
/*           CALL       PGM(PM1136)                            B08040*/
/*           CALL       PGM(PM1136) PARM(&WWTVPS)      B08253 *B08040*/
             CALL       PGM(PM1136) PARM(&WWTVPS 'L') /*B08253*B08040*/
 
             CLOF       OPNID(SDPLCSPD)
/*********** CLOF       OPNID(SDPLCSLL)                              * *085813*/
             CLOF       OPNID(SDPLCSL1)                               /*085813*/
 
             DLTOVR     FILE(*ALL)
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52)) /*S01486*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01486*/
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          */
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  /*S01486*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/*                                                                    /*R00300*/
             CHGVAR     VAR(&MEM) VALUE('PMC1136  - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
