/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ZA Create the Midas Local Data Area')           */
/*********************************************************************/
/*                                                                   */
/*       Midas Standard routines                                     */
/*                                                                   */
/*       ZACCRTLDA - Create the Midas Local Data Area                */
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
/*       Prev Amend No. CAP002  *CREATE    Date 24Nov97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP002 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RETURNCODE)
/**/
/** Declares                                                         */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Return code **/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
 
/** +
    The global monitor sends an escape message, which will end the +
    program instantly if it is executed. +
**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas Local Data Area')
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RETURN
 
ABNOR:
             CHGVAR     VAR(&RETURNCODE) VALUE('Error')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Error +
                          while creating LDA data area') +
                          MSGTYPE(*ESCAPE)
             ENDPGM
