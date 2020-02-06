/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas New Spot Historic REVALUATION')                 */
/********************************************************************/
/*                                                                  */
/*             MIDAS/ABS EUROPEAN REPORTING SYSTEM                  */
/*                                                                  */
/*       ERC5348 - New Spot Historic Revaluation                    */
/*                 (based on DLC07 - Spot Revaluation)              */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ER0004 AD          Date 26Nov92              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*  ER0004 - Writted to call new revaluation program, based on      */
/*           coding from CLP/DLC07.                                 */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL   VAR(&SWS) TYPE(*CHAR)
/**/
             CHGJOB     SWS(00000000)
/* ER0004 ***SNDMSG     MSG('Spot Revaluations')  TOMSGQ(MRUNQ)    */
/* ER0004 ***CLRPFM     FILE(GESRHH)                               */
/* ER0004 ***CLRPFM     FILE(GESRPD)                               */
/* ER0004 ***CLRPFM     FILE(GESRZZ)                               */
             SNDMSG     MSG('New Spot Historic Revaluations') +
                          TOMSGQ(MRUNQ)
/**********  CLRPFM     FILE(GESTHRHH)                                                      CER001*/
             CLRPFM     FILE(GLSRX1PD)                                                    /*CER001*/
/**********  CLRPFM     FILE(GESTHRPD)                                                      CER001*/
             CLRPFM     FILE(GLSRX2PD)                                                    /*CER001*/
/**********  CLRPFM     FILE(GESTHRZZ)                                                    /*CER001*/
             CLRPFM     FILE(GLSRX2PA)                                                    /*CER001*/
             OVRDBF     FILE(TABLE)   TOFILE(TABDLEI)
             OVRDBF     FILE(TABLE2)  TOFILE(TABDLEE)
/**/
/* ER0004 ***CALL       PGM(DL0450)                                */
             CALL       PGM(ER5348)
/**/
             RTVJOBA    SWS(&SWS)
             DLTOVR     FILE(TABLE TABLE2)
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                        MSG('JOB TERMINATED - DATABASE IN ERROR') +
                        TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                        MSG('FILE CONTROLS OUT OF BALANCE') +
                        TOMSGQ(MOPERQ))
/**/
             ENDPGM
