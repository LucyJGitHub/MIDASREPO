/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER - folder path for PCFiles - Maintenance')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERCLU25 - Folder Path for PCFiles - Maintenance             */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX040  *CREATE    Date 28Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX040 - FIRE - RT30 Generation in Midas                    */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                   */              /*CER001*/
/**********  DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)                   */              /*CER001*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
             CALL ERLU25
 
  /* make a copy in xxCADLIB */
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)              */
/**********  CHGVAR     VAR(&TOLIB) VALUE(&PREFIX *CAT 'CADLIB')          */
/**********  CPYF       FROMFILE(ERPATHPD) TOFILE(&TOLIB/ERPATHPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                  */              /*CER001*/
             CPYF       FROMFILE(ERPATHPD) TOFILE(ERPTHXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CER001*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      SNDPGMMSG  MSG('Error on ERPATHPD') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
