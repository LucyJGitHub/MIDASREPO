/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Rep Last Sucs. Trans on Primary Mach')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1764 - Open and Close all members in list MBRLIST       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E13205             DATE  14/02/89           */
/*       PREV AMEND NO. E00000             DATE  00/00/00           */
/*                                                                  */
/********************************************************************/
/*       New Program Overview                                       */
/*                                                                  */
/*       E13205 - Program is passed the name of a member list       */
/*                created by DSPFD option *MBRLIST. Each file       */
/*                member in the list is opened and closed.          */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MBRFILE &MBRLIB &MBRNAME)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&MBRFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
/**/
             DCLF       FILE(*LIBL/QAFDMBRL)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/*           Override file and read until end of file                */
/**/
             OVRDBF     FILE(QAFDMBRL) TOFILE(&MBRLIB/&MBRFILE) +
                          MBR(&MBRNAME)
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             IF         COND(&MLFILE *EQ '         ') THEN(GOTO +
                          CMDLBL(READ))
/**/
/*           Verify if rebuilt                                       */
/**/
             CALL       PGM(*LIBL/SD1731) PARM('*VERIFY' &MLFILE +
                          &MLLIB &MLNAME &RTNCDE)
             IF         COND(&RTNCDE *EQ '*DONE') THEN(GOTO +
                          CMDLBL(READ))
/**/
/*           Open and close member specified                         */
/**/
             OPNDBF     FILE(&MLLIB/&MLFILE) OPTION(*INP) MBR(&MLNAME)
             CLOF       OPNID(&MLFILE)
/**/
/*           Set up file as being rebuilt                            */
/**/
             CALL       PGM(*LIBL/SD1731) PARM('*REBUILT' &MLFILE +
                          &MLLIB &MLNAME &RTNCDE)
             IF         COND(&RTNCDE *EQ '*ERROR') THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
             GOTO       CMDLBL(READ)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1764 - Open and Close all +
                          members in list MBRLIST - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
