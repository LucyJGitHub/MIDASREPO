/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC000799)   VLDCKR(UPC000799V)  MSGF(UTMSGF)           */
/*EXI    HLPPNLGRP(ACTIONFILE)  HLPID(ACTIONFILE)                    */
/*EXI    TEXT('Midas UP Action File handler')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       ACTIONFILE - Action File handler                            */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP040             Date 22Feb13              */
/*                      A1084804           Date 30Jan13              */
/*                      CUP021 *REWRITE    Date 24Jan11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CUP022 *CREATE     Date 09Feb04              */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP040 - New deliverable data methodology.                  */
/*              - Add 'original file' parameter.                     */
/*       A1084804 - New *MRG option.                                 */
/*       CUP021 - Rewrite of Action File processing.                 */
/*       CUP022 - Creation of new set of Action File utilities.      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Action File handler')
 
/**********  PARM       KWD(MODE) TYPE(*CHAR) LEN(4) RSTD(*YES) +                    */ /*A1084804*/
/**********               VALUES(*ADD *BLD *RVW *CFT *UPD *PRC) +                    */ /*A1084804*/
/**********               MIN(1) PROMPT('Mode' 1)                                    */ /*A1084804*/
             PARM       KWD(MODE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          VALUES(*ADD *BLD *RVW *CFT *UPD *PRC +
                          *MRG) MIN(1) PROMPT('Mode' 1)                                 /*A1084804*/
 
             PARM       KWD(FILE) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          PROMPT('File name' 2)
 
             PARM       KWD(OLDLIB) TYPE(*CHAR) LEN(10) MIN(0) +
                          PMTCTL(PMTCTL1) PROMPT('Old library:' 3)
             PARM       KWD(NEWLIB) TYPE(*CHAR) LEN(10) MIN(0) +
                          PMTCTL(PMTCTL1) PROMPT('New library:' 4)
 
             PARM       KWD(MBROPT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*ADD) VALUES(*REPLACE *ADD) MIN(0) +
                          PMTCTL(PMTCTL1) PROMPT('Member option' 5)
 
             PARM       KWD(TKOOPT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*POSTTKO) VALUES(*POSTTKO *PRETKO) +
                          MIN(0) PMTCTL(PMTCTL2) PROMPT('Pre or +
                          post take-on' 6)
 
             PARM       KWD(KEYF) TYPE(*CHAR) LEN(10) MIN(0) +
                          PMTCTL(PMTCTL3) PROMPT('Keyed file' 7)
             PARM       KWD(LAYER) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*ZONE) VALUES(*ZONE *GLOBAL) MIN(0) +
                          PMTCTL(PMTCTL3) PROMPT('Layer' 8)
 
             PARM       KWD(ORIF) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          SPCVAL((*NONE)) PMTCTL(PMTCTL3) +
                          PROMPT('Original file name' 10)                                 /*CUP040*/
 
             DEP        CTL(&MODE *EQ '*ADD') PARM((&KEYF *NE ' ')) +
                          MSGID(BRG0005)
             DEP        CTL(&MODE *EQ '*ADD') PARM((&ORIF *NE ' ')) +
                          MSGID(BRG0009)                                                  /*CUP040*/
 
             DEP        CTL(&MODE *EQ '*BLD') PARM((&OLDLIB *NE ' ') +
                          (&NEWLIB *NE ' ')) MSGID(BRG0004)
 
/**********  DEP        CTL(&MODE *NE '*UPD') PARM((&FILE *NE ' ')) +                */ /*A1084804*/
/**********               MSGID(BRG0003)                                             */ /*A1084804*/
             DEP        CTL(&FILE *EQ ' ') PARM((&MODE *NE '*ADD') +
                          (&MODE *NE '*BLD') (&MODE *NE '*RVW') +
                          (&MODE *NE '*CFT') (&MODE *NE '*PRC')) +
                          MSGID(BRG0003)                                                /*A1084804*/
 
 PMTCTL1:    PMTCTL     CTL(MODE) COND((*EQ '*BLD'))
             PMTCTL     CTL(MODE) COND((*EQ '*MRG')) LGLREL(*OR)                        /*A1084804*/
 
 PMTCTL2:    PMTCTL     CTL(MODE) COND((*EQ '*RVW'))
             PMTCTL     CTL(MODE) COND((*EQ '*UPD')) LGLREL(*OR)
 
 PMTCTL3:    PMTCTL     CTL(MODE) COND((*EQ '*ADD'))
