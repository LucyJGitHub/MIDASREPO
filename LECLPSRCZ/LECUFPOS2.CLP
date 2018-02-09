/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Retrieve Position of first window field 2')  */
/*OVR  : OVRDBF FILE(LEUFPOPP) TOFILE(QAFDRFMT)                     :*/                   /*CER001*/
/********************************************************************/
/*                                                                   */
/*                                                                   */
/*   MIDAS/ABS  EUROPEAN REPORTING - LUXEMBOURG                      */
/*                                                                   */
/*                                                                   */
/*   LECUFPOS2 - RETRIEVE POS OF FIRST WINDOW FIELD                  */
/*                                                                   */
/*       This CLP retrieve the position of the first window field    */
/*       in order to split message between Core data and Extra data  */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX612             Date 11Jan02              */
/*                                                                   */
/*********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX612 - LE Loans & Part Purch API for Lux                 */
/*********************************************************************/
/*C*T**:*CRTCLPGM***************************************************:*/
/*C*T**:**PGM(BISBISBISB/BISBISBISB)*SRCFILE(BISBISBISB/BISBISBISB)*:*/
/*C*T**:*SRCMBR(*PGM)*USRPRF(*USER)*LOG(*JOB)***********************:*/
/*C*T**:*ALWRTVSRC(*YES)****AUT(*USE*)**TEXT(*SRCMBRTXT)************:*/
/*********************************************************************/
             PGM        PARM(&FPOS1 &PLIB)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
             DCL        VAR(&FPOS1) TYPE(*DEC) LEN(5)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(7)
 
             DCLF       FILE(LEUFPOPP)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
 READ:       RCVF       RCDFMT(QWHFDFMT)
             CHGVAR     VAR(&FPOS1) VALUE(&RFLEN)
             GOTO       ENDPGM
 
ERROR:
             SNDPGMMSG  MSG('LECUFPOS2 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)
             CHGJOB (XXXXXX11)
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
