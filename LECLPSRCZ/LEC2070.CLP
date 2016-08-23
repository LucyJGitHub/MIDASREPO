/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Rollover Maintenance')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2070 - Rollover Maintenance.                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 256407A            Date 01Oct08              */
/*       Prev Amend No. 256407             Date 04Sep08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE036             Date 22Sep03              */
/*                      CLE034             Date 05May03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAP062 *CREATE     Date 10May02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       256407A - Revert back APHEADPD to R4 length                 */
/*       256407 - Applied fixes 235136 and 230463.                   */
/*       CLE036 - LE Enh for Nordea Phase 1 Pty 2- Specific Base Rate*/
/*       CLE034 - Lending Enhancements.                              */
/*       CAP062 - Calls LE2070 (Rollover Maintenance.)               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&MODE &TYPE &PINPP &POUTP)                                   /*256407*/
             PGM        PARM(&MODE &TYPE &PINPP &POUTP &APHEAD)                           /*256407*/
 
/*/COPY WNCPYSRC,LEC2070INT                                          */
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(4)
/*********** DCL        VAR(&PINPP) TYPE(*CHAR) LEN(933)                                  /*CLE034*/
/**********  DCL        VAR(&PINPP) TYPE(*CHAR) LEN(964)             */            /*CLE034 CLE036*/
             DCL        VAR(&PINPP) TYPE(*CHAR) LEN(976)                                  /*CLE036*/
             DCL        VAR(&POUTP) TYPE(*CHAR) LEN(172)
             DCL        VAR(&TSTMP) TYPE(*CHAR) LEN(26)                                   /*CLE034*/
/**********  DCL        VAR(&APHEAD) TYPE(*CHAR) LEN(218)           */            /*256407 256407A*/
             DCL        VAR(&APHEAD) TYPE(*CHAR) LEN(200)                                /*256407A*/
             DCL        VAR(&returncode) TYPE(*CHAR) LEN(10)                              /*256407*/
             DCL        VAR(&msgidarr) TYPE(*CHAR) LEN(525)                               /*256407*/
             DCL        VAR(&fldnoarr) TYPE(*CHAR) LEN(225)                               /*256407*/
             DCL        VAR(&fldnamearr) TYPE(*CHAR) LEN(750)                             /*256407*/
             DCL        VAR(&msgdtaarr) TYPE(*CHAR) LEN(3375)                             /*256407*/
             DCL        VAR(&PTRANID) TYPE(*CHAR) LEN(20)                                 /*256407*/
             DCL        VAR(&dddlno) TYPE(*CHAR) LEN(6)                                   /*256407*/
             DCL        VAR(&msgfile) TYPE(*CHAR) LEN(10)                                 /*256407*/
             DCL        VAR(&ddactn) TYPE(*CHAR) LEN(1)                                   /*256407*/
             DCL        VAR(&transts) TYPE(*CHAR) LEN(1)                                  /*256407*/
             DCL        VAR(&procpgm) TYPE(*CHAR) LEN(10)                                 /*256407*/
             DCL        VAR(&procmod) TYPE(*CHAR) LEN(10)                                 /*256407*/
             DCL        VAR(&procname) TYPE(*CHAR) LEN(10)                                /*256407*/
             DCL        VAR(&ptimestamp) TYPE(*CHAR) LEN(26)                              /*256407*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)                                  /*256407*/
             DCL        VAR(&YYYY) TYPE(*CHAR) LEN(4)                                     /*256407*/
             DCL        VAR(&MM) TYPE(*CHAR) LEN(2)                                       /*256407*/
             DCL        VAR(&DD) TYPE(*CHAR) LEN(2)                                       /*256407*/
             DCL        VAR(&HH) TYPE(*CHAR) LEN(2)                                       /*256407*/
             DCL        VAR(&MN) TYPE(*CHAR) LEN(2)                                       /*256407*/
             DCL        VAR(&SS) TYPE(*CHAR) LEN(2)                                       /*256407*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2) VALUE('LE')                       /*256407*/
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(750) +
                          VALUE('DRSMM')                                                  /*256407*/
             DCL        VAR(&CLRPGMQ) TYPE(*CHAR) LEN(1) VALUE('N')                       /*256407*/
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(14)                                /*256407*/
             DCL        VAR(&CHECKNUM) TYPE(*CHAR) LEN(1)                                 /*256407*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(2)                                     /*256407*/
             DCLF       FILE(APHEADPD)                                                    /*256407*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create necessary file overrides */
 
             OVRDBF     FILE(LEIROLLX) TOFILE(LEIROLL2) +
                          OVRSCOPE(*CALLLVL) SHARE(*NO)
 
/*/COPY WNCPYSRC,LEC2070MPS                                          */
 
/*********** CALL       PGM(LE2070) PARM(&MODE &TYPE &PINPP &POUTP)                       /*CLE034*/
             CALL       PGM(LE2070) PARM(&MODE &TYPE &PINPP &POUTP &TSTMP)                /*CLE034*/
 
             CHGVAR     VAR(&MSGIDARR) VALUE(%SST(&POUTP 82 7))                           /*256407*/
             CHGVAR     VAR(&FLDNOARR) VALUE(X'00001F00000F')                             /*256407*/
             CHGVAR     VAR(&FLDNAMEARR) VALUE('LNRF')                                    /*256407*/
             CHGVAR     VAR(&PTRANID) VALUE(%SST(&POUTP 167 6))                           /*256407*/
             CHGVAR     VAR(&MSGFILE) VALUE('LERMSGF')                                    /*256407*/
             CHGVAR     VAR(&DDACTN) VALUE(%SST(&POUTP 56 1))                             /*256407*/
             IF         COND(((%SST(&POUTP 81 1)) *EQ 'E') +
                        *OR ((%SST(&POUTP 81 1)) *EQ 'D')) +
                          THEN(CHGVAR VAR(&TRANSTS) VALUE('F'))                           /*256407*/
             ELSE       CMD(CHGVAR VAR(&TRANSTS) VALUE('S'))                              /*256407*/
             CHGVAR     VAR(&PROCPGM) VALUE('LE2070')                                     /*256407*/
             CHGVAR     VAR(&PROCMOD) VALUE('LE2070')                                     /*256407*/
             CHGVAR     VAR(&PROCNAME) VALUE('LE2070')                                    /*256407*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                                    /*256407*/
             IF         COND(%SST(&RUNDAT 12 1) *EQ 'D') THEN(DO)                         /*256407*/
             CHGVAR &DD %SST(&POUTP 57 2)                                                 /*256407*/
             CHGVAR &MM %SST(&POUTP 59 2)                                                 /*256407*/
             CHGVAR &YYYY %SST(&POUTP 61 4)                                               /*256407*/
             ENDDO                                                                        /*256407*/
             ELSE       CMD(DO)                                                           /*256407*/
             CHGVAR &MM %SST(&POUTP 57 2)                                                 /*256407*/
             CHGVAR &DD %SST(&POUTP 59 2)                                                 /*256407*/
             CHGVAR &YYYY %SST(&POUTP 61 4)                                               /*256407*/
             ENDDO                                                                        /*256407*/
             CHGVAR &HH %SST(&POUTP 65 2)                                                 /*256407*/
             CHGVAR &MN %SST(&POUTP 67 2)                                                 /*256407*/
             CHGVAR &SS %SST(&POUTP 69 2)                                                 /*256407*/
                                                                                          /*256407*/
 /* Search through the time and date variables from POUTPP for blanks */                  /*256407*/
                                                                                          /*256407*/
             CHGVAR     VAR(&COUNT) VALUE(1)                                              /*256407*/
             CHGVAR     VAR(&DATETIME) VALUE(&DD *CAT &MM *CAT &YYYY +
                          *CAT &HH *CAT &MN *CAT &SS)                                     /*256407*/
             CHGVAR     VAR(&CHECKNUM) VALUE(%SST(&DATETIME &COUNT 1))                    /*256407*/
                                                                                          /*256407*/
 LOOP:       IF         COND(&CHECKNUM *NE ' ') THEN(DO)                                  /*256407*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                                     /*256407*/
             CHGVAR     VAR(&CHECKNUM) VALUE(%SST(&DATETIME &COUNT 1))                    /*256407*/
             IF         COND(&COUNT *LT 14) THEN(GOTO LOOP)                               /*256407*/
             ENDDO                                                                        /*256407*/
                                                                                          /*256407*/
 /* If any part of the time and date variables are blank then generate timestamp */       /*256407*/
                                                                                          /*256407*/
             IF         COND(&CHECKNUM *EQ ' ') THEN(DO)                                  /*256407*/
             CALL       PGM(ZAGENTS) PARM(&PTIMESTAMP)                                    /*256407*/
             ENDDO                                                                        /*256407*/
             ELSE       CMD(DO)                                                           /*256407*/
             CHGVAR     VAR(&PTIMESTAMP) VALUE(&YYYY *CAT '-' *CAT +
                          &MM *CAT '-' *CAT &DD *CAT '-' *CAT &HH +
                          *CAT '.' *CAT &MN *CAT '.' *CAT &SS *CAT +
                          '.' *CAT '000000')                                              /*256407*/
             ENDDO                                                                        /*256407*/
/**********  CHGVAR &APRPRLOCN %SST(&APHEAD 197 1)                  */            /*256407 256407A*/
/**********  CHGVAR &APCNFVALFO %SST(&APHEAD 196 1)                 */            /*256407 256407A*/
/**********  CHGVAR &APFOTRANID %SST(&APHEAD 156 20)                */            /*256407 256407A*/
/**********  CHGVAR &APRESPMODE %SST(&APHEAD 154 1)                 */            /*256407 256407A*/
/**********  CHGVAR &APRPYQUEUE %SST(&APHEAD 124 20)                */            /*256407 256407A*/
             CHGVAR &APRPRLOCN %SST(&APHEAD 180 1)                                       /*256407A*/
             CHGVAR &APCNFVALFO %SST(&APHEAD 179 1)                                      /*256407A*/
             CHGVAR &APFOTRANID %SST(&APHEAD 139 20)                                     /*256407A*/
             CHGVAR &APRESPMODE %SST(&APHEAD 137 1)                                      /*256407A*/
             CHGVAR &APRPYQUEUE %SST(&APHEAD 117 20)                                     /*256407A*/
                                                                                          /*256407*/
             CALL       PGM(ZAMSGHNDLE) PARM(&RETURNCODE &APRPRLOCN +
                          &APCNFVALFO &MSGIDARR &FLDNOARR &FLDNAMEARR +
                &MSGDTAARR &APFOTRANID &MODULE &PTRANID +
                          &MSGFILE &DDACTN &TRANSTS &APRESPMODE +
                          &PROCPGM &PROCMOD &PROCNAME &APRPYQUEUE +
                          &PTIMESTAMP &MSGF &CLRPGMQ)                                     /*256407*/
                                                                                          /*256407*/
/* Commit changes */
 
             COMMIT
 
/*/COPY WNCPYSRC,LEC2070MPE                                          */
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
/*/COPY WNCPYSRC,LEC2070ERR                                          */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC2070 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
 
 /* End program */
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,LEC2070END                                          */
 
             ENDPGM
