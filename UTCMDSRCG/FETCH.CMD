/*********************************************************************/
/*S*D****FETCH********************************************************/                   /*CPK010*/
/*STD    CMDBASE                                                     */                   /*CPK010*/
/*EXI    TEXT('Midas UT Fetch latest source from signoff libs')      */
/*E*I****PGM(UTC0013)*VLDCKR(*NONE)*MSGF(QCPFMSG)*********************/ /*  */ /*CPK010*/ /*CUT015*/
/*EXI    PGM(UTC0013) VLDCKR(UTC0013V) MSGF(QCPFMSG)                 */                   /*CUT015*/
/*EXI    HLPPNLGRP(FETCH) HLPID(*CMD)                                */                   /*CPK010*/
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       FETCH - Fetch latest source member                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CUT015             Date 19Jun12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CPK010             Date 08Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01516             DATE 02NOV94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUT015 - Rewrite for Midas Plus naming conventions.         */
/*       CPK010 - MDB3 Alpha site enhancements                       */
/*                - Standardisation of creation parameters           */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Fetch Source')
 
/**********  PARM       KWD(MBR) TYPE(*NAME) LEN(10) MIN(1) +                             /*CUT015*/
/**********               PROMPT('Source Member')                                         /*CUT015*/
             PARM       KWD(MBR) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Source Member' 1)                                       /*CUT015*/
/**********  PARM       KWD(MOD) TYPE(*NAME) LEN(2) CHOICE('Module +                      /*CUT015*/
/**********               prefix') PROMPT('Module')                                       /*CUT015*/
/**********  PARM       KWD(TYPE) TYPE(*CHAR) LEN(3) RSTD(*YES) +                         /*CUT015*/
/**********               VALUES(DDS RPG CL CMD DTA) PROMPT('Source +                     /*CUT015*/
/**********               Type')                                                          /*CUT015*/
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          VALUES(DDS RPG CL SRVPGM PGM SQL CMD +
                          PNLGRP DTAARA DTAQ VLDL TBL CPY) MIN(1) +
                          PROMPT('Source Type' 3)                                         /*CUT015*/
             PARM       KWD(TOSRCF) TYPE(QUAL1) PROMPT('To Source +
                          File' 4)                                                        /*CUT015*/
             PARM       KWD(MOD) TYPE(*NAME) LEN(2) DFT(*PFX) +
                          SPCVAL((*PFX QQ)) CHOICE('Module prefix') +
                          PROMPT('Module Prefix' 2)                                       /*CUT015*/
/**********  PARM       KWD(WRKMBR) TYPE(*CHAR) LEN(4) RSTD(*YES) +                       /*CUT015*/
/**********               DFT(*NO) VALUES(*YES *NO) PROMPT('Work +                        /*CUT015*/
/**********               with Source Member')                                            /*CUT015*/
/**********  PARM       KWD(DEVSUPP) TYPE(*CHAR) LEN(1) RSTD(*YES) +                      /*CUT015*/
/**********               DFT(S) VALUES(D S) +                                            /*CUT015*/
/**********               PROMPT('Development/Support Libraries')                         /*CUT015*/
 
/**********  PARM       KWD(TOSRCF) TYPE(QUAL1) PMTCTL(PROMPT1) +                         /*CUT015*/
/**********               PROMPT('To Source File')                                        /*CUT015*/
/**********  PARM       KWD(TOMBR) TYPE(*NAME) LEN(10) DFT(*MBR) +                        /*CUT015*/
/**********               SPCVAL((*MBR)) PMTCTL(PROMPT1) +                                /*CUT015*/
/**********               PROMPT('To Source Member')                                      /*CUT015*/
             PARM       KWD(TOMBR) TYPE(*NAME) LEN(10) DFT(*MBR) +
                          SPCVAL((*MBR)) PROMPT('To Source Member')                       /*CUT015*/
/**********  PARM       KWD(OVERWRITE) TYPE(*CHAR) LEN(4) RSTD(*YES) +                    /*CUT015*/
/**********               DFT(*NO) VALUES(*NO *YES) PMTCTL(PROMPT1) +                     /*CUT015*/
/**********               PROMPT('Overwrite Existing Member')                             /*CUT015*/
             PARM       KWD(OVERWRITE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) +
                          PROMPT('Overwrite Existing Member')                             /*CUT015*/
 
/*PROMPT1:****PMTCTL     CTL(WRKMBR) COND((*EQ *YES))                                     /*CUT015*/
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) DFT(*MBR) SPCVAL((*MBR))
/**********  QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +                                  /*CUT015*/
/**********               SPCVAL((*CURLIB) (*LIBL)) MIN(0) +                              /*CUT015*/
/**********               PROMPT('Library')                                               /*CUT015*/
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT('Library')                      /*CUT015*/
