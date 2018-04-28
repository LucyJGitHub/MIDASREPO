/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Delete batch')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0111 - Delete Batch Control                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL016  *CREATE    Date 01Aug02              */
/*       Prev Amend No.                    Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL016 - Projected Movements Update Prior to Authorisation  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
 
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
                          Misys International Banking Systems Ltd. +
                          2002')
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/* Start commitment control - job is submitted                            */
 
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
/* Handle batch                                                           */
 
             CHGVAR     VAR(&PROGRAM) VALUE(%SST(&PARM1 1 10))
             CHGVAR     VAR(&BTCH) VALUE(%SST(&PARM2 1 3))
 
             CALL       PGM(&PROGRAM) PARM(&RTCD &BTCH)
 
/* Only if the whole transaction is ok, commit to DB                      */
 
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                COMMIT
                GOTO       CMDLBL(EXIT)
             ENDDO
 
 ERROR:
             SNDPGMMSG  MSG('Error in batch handling program - +
                          Rollback')
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 EXIT:
             ENDPGM
