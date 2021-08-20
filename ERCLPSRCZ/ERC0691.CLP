/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('DOWNLOAD TO XXERDLIB ACCNTAB ONLY')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERC0691 - DOWNLOAD TO XXERDLIB ACCNTAB ONLY                */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1992, 1996.   */
/*                                                                   */
/*       Last Amend No. LUC139             Date 18Jan21              */
/*       Prev Amend No. 178122 *CREATE     Date 28APR00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       178122 - USE ACCNTAB FROM XXERDLIB TO IGNORE POSTINGS       */
/*                FOR FOLLOWING MONTH                                */
/*                                                                   */
/*********************************************************************/
/**/
PGM
                                                                      /*USW004*/
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XXLIB) TYPE(*CHAR) LEN(2)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&XXLIB)
             CHGVAR     VAR(&ERDLIB) VALUE(&XXLIB *CAT 'ERDLIB')
                                                                      /*USW004*/
             CPYF       FROMFILE(ACCNTAB) TOFILE(&ERDLIB/ACCNTAB) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&ERDLIB/ACCNTAB))
ENDPGM
