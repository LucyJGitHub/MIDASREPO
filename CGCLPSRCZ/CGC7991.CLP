/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Create format option codes')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC7991  - Create Format Option Codes                       */
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
/*       Prev Amend No. 096647             Date 30Nov95              */
/*                      CCG009             Date 01Jun95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       096647 - Add new paramteres                )                */
/*       CCG009 - Private Banking UDC   (NEW PROGRAM)                */
/*                                                                   */
/*********************************************************************/
 
/************PGM                                                      /*096647*/
             PGM        PARM(&CURRENCY &COUNTRY &INDUSTRY &PB_INVEST +
                          &PB_VGROUP &OVER_WRITE)                     /*096647*/
 
/* Copyright Statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&OVER_WRITE)  TYPE(*CHAR) LEN(1)          /*096647*/
             DCL        VAR(&CURRENCY  )  TYPE(*CHAR) LEN(1)          /*096647*/
             DCL        VAR(&COUNTRY   )  TYPE(*CHAR) LEN(1)          /*096647*/
             DCL        VAR(&INDUSTRY  )  TYPE(*CHAR) LEN(1)          /*096647*/
             DCL        VAR(&PB_INVEST )  TYPE(*CHAR) LEN(1)          /*096647*/
             DCL        VAR(&PB_VGROUP )  TYPE(*CHAR) LEN(1)          /*096647*/
             DCL        VAR(&PARM      )  TYPE(*CHAR) LEN(256)        /*096647*/
             DCL        VAR(&RTN_CODE  )  TYPE(*CHAR) LEN(7)          /*096647*/
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('CGC7991 - Create Format Option Codes') +
                          TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(00000000)
 
/* Call the Format Option Code Creation Program                */
 
             CHGVAR     VAR(&PARM) VALUE(&CURRENCY *CAT &COUNTRY +
                          *CAT &INDUSTRY *CAT &PB_INVEST *CAT +
                          &PB_VGROUP)                                 /*096647*/
/************CALL       PGM(CG7991)                                    *096647*/
             CALL       PGM(CG7991) PARM(&RTN_CODE &PARM +
                          &OVER_WRITE)                                /*096647*/
 
/* Terminate Program normally                                        */
 
             GOTO       CMDLBL(ENDCLPGM)
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             DMPCLPGM
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC7991 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC7991 ended abnormally') MSGTYPE(*ESCAPE)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
