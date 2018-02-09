/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Delete batch')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0112 - Delete Batch Control 1                            */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL016  *CREATE    Date 01Aug02              */
/*                                         Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL016 - Projected Movements Update Prior to Authorisation  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &BTCH &PROGRAM)
 
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&BTCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/* Handle batch */
 
             CHGVAR     VAR(%SST(&PARM1 1 10)) VALUE(&PROGRAM)
             CHGVAR     VAR(%SST(&PARM2 1 3)) VALUE(&BTCH)
 
             CALL       PGM(MLC0000) PARM('GLC0111' &PARM1 &PARM2 &PARM3 +
                          &PARM4 &PARM5)
 
             GOTO       CMDLBL(EXIT)
 
 ERROR:
             SNDPGMMSG  MSG('Error in batch handling program - +
                          Rollback')
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 EXIT:
             ENDPGM
