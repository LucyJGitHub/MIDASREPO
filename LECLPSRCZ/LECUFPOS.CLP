/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Retrieve Position of first window field')    */
/********************************************************************/
/*                                                                   */
/*                                                                   */
/*   MIDAS/ABS  EUROPEAN REPORTING - LUXEMBOURG                      */
/*                                                                   */
/*                                                                   */
/*   LECUFPOS - RETRIEVE POS OF FIRST WINDOW FIELD                   */
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
/*       CER001 - LUX Upgrade to MidasPlus (Recompile only)          */
/*       ULX612 - LE Loans & Part Purch API for Lux                 */
/*********************************************************************/
/*C*T**:*CRTCLPGM***************************************************:*/
/*C*T**:**PGM(BISBISBISB/BISBISBISB)*SRCFILE(BISBISBISB/BISBISBISB)*:*/
/*C*T**:*SRCMBR(*PGM)*USRPRF(*USER)*LOG(*JOB)***********************:*/
/*C*T**:*ALWRTVSRC(*YES)****AUT(*USE*)**TEXT(*SRCMBRTXT)************:*/
/*********************************************************************/
 
             PGM        PARM(&FPOS)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FPOS) TYPE(*DEC) LEN(5)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBR)
             CHGVAR     VAR(&PLIB) VALUE(&LIBR *TCAT 'DPLIB')
 
             DLTF       FILE(&PLIB/LEUFPOPP)
 
             DSPFD      FILE(&PLIB/LEN1MFPD) TYPE(*RCDFMT) +
                          OUTPUT(*OUTFILE) OUTFILE(&PLIB/LEUFPOPP) +
                          OUTMBR(*FIRST)
             CALL       PGM(LECUFPO2) PARM(&FPOS &PLIB)
 
             GOTO       CMDLBL(ENDPGM)
ERROR:
             SNDPGMMSG  MSG('LECUFPOS - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)
             CHGJOB (XXXXXX11)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
