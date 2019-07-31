/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Standing Journal Maintenance')                  */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*      GLC1440  - STANDING JOURNAL MAINTENANCE                     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 259359             Date 20Mar09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      244686             Date 28Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL013             Date 29Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 06Mar95              */
/*                      BHF852             Date 22Nov90              */
/*                      S01251             Date 03FEB90              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       259359 - Override GLBTNOL0 with SHARE(*NO)                 */
/*       244686 - Added missing fields to GLJESHPD which CAP086     */
/*                and CSC024 introduced to GZGLJENHPD in order for  */
/*                2 files to be synchronized. (Recompile only)      */
/*       CGL013 - MT94x Messages Generation                          */
/*       S01408 - Addition of core hooks GLC1440MPE                 */
/*                                       GLC1440END                 */
/*       BHF852 - ADD OVERIDE FOR GLJESSL3                          */
/*       S01251 - SYNON FIELD/PROGRAM NAME CHANGES                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
PGM
/**/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CGL013*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CGL013*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CGL013*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CGL013*/
             DCL        VAR(&CGL013) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CGL013*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,GLC1440001                                          */
 
/**********  OVRDBF     FILE(GLBRREL0) TOFILE(GLBRTEL0) SHARE(*NO) */ /*S01251*/
/**********  OVRDBF     FILE(GLBRREL1) TOFILE(GLBRTEL1)            */ /*S01251*/
/**********  OVRDBF     FILE(GLBTREL0) TOFILE(GLBTTEL0)            */ /*S01251*/
/**********  OVRDBF     FILE(GLBTREL1) TOFILE(GLBTTEL1)            */ /*S01251*/
/**********  OVRDBF     FILE(GLBTREL2) TOFILE(GLBTTEL2)            */ /*S01251*/
/**********  OVRDBF     FILE(GLBSREL0) TOFILE(GLBSTEL0)            */ /*S01251*/
/**********  OVRDBF     FILE(GLBSREL1) TOFILE(GLBSTEL1)            */ /*S01251*/
 
             OVRDBF     FILE(GLJENHL0) TOFILE(GLJESHL0) SHARE(*NO)    /*S01251*/
             OVRDBF     FILE(GLJENHL1) TOFILE(GLJESHL1)               /*S01251*/
             OVRDBF     FILE(GLJENPL0) TOFILE(GLJESPL0)               /*S01251*/
             OVRDBF     FILE(GLJENPL1) TOFILE(GLJESPL1)               /*S01251*/
             OVRDBF     FILE(GLJENPL2) TOFILE(GLJESPL2)               /*S01251*/
             OVRDBF     FILE(GLJENSL0) TOFILE(GLJESSL0)               /*S01251*/
             OVRDBF     FILE(GLJENSL1) TOFILE(GLJESSL1)               /*S01251*/
             OVRDBF     FILE(GLJENSL3) TOFILE(GLJESSL2)               /*BHF852*/
             OVRDBF     FILE(GLBTNOL0) SHARE(*NO)                                         /*259359*/
                                                                                          /*CGL013*/
/** Access SCSARDPD to check if CGL013 is on */                                           /*CGL013*/
                                                                                          /*CGL013*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CGL013*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CGL013*/
             CHGVAR     VAR(&PSARD) VALUE('CGL013')                                       /*CGL013*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                  /*CGL013*/
             IF         COND(&PRTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CGL013) VALUE('Y'))                                        /*CGL013*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 = 'Y') THEN(DO)                                      /*CGL013*/
             OVRDBF     FILE(GLJENXL2) TOFILE(GLJESXL2)                                   /*CGL013*/
             OVRDBF     FILE(GLJENXL3) TOFILE(GLJESXL3)                                   /*CGL013*/
             OVRDBF     FILE(GLJENXL4) TOFILE(GLJESXL4)                                   /*CGL013*/
             ENDDO                                                                        /*CGL013*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC1440MPE                                           /*S01408*/
/**/                                                                  /*S01408*/
 
/**********  CALL       PGM(GLIEDFR) PARM(' ')                     */ /*S01251*/
             CALL       PGM(GL0160D) PARM(' ')                        /*S01251*/
 
/**********  DLTOVR     FILE(GLBRREL0 GLBRREL1 GLBTREL0 GLBTREL1 + */ /*S01251*/
/**********               GLBTREL2 GLBSREL0 GLBSREL1)              */ /*S01251*/
 
             DLTOVR     FILE(GLJENHL0 GLJENHL1 GLJENPL0 GLJENPL1 +
                          GLJENPL2 GLJENSL0 GLJENSL1)                 /*S01251*/
             DLTOVR     FILE(GLBTNOL0)                                                    /*259359*/
                                                                                          /*CGL013*/
             IF         COND(&CGL013 = 'Y') THEN(DO)                                      /*CGL013*/
             DLTOVR     FILE(GLJENXL2 GLJENXL3 GLJENXL4)
             ENDDO                                                                        /*CGL013*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC1440END                                           /*S01408*/
/**/                                                                  /*S01408*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
