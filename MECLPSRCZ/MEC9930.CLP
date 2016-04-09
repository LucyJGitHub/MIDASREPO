/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Get Object Attributes')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC9930  -  Check object exists in library list, and        */
/*                   return attributes.                              */
/*                                                                   */
/*       Return code values: MEM9931 Object exists                   */
/*                           MEM9932 Object does not exist           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CSW096             DATE 04JUN96              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSW096 - SWIFT Changes November 1996                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RET_CODE &PROGRAM &OBJ_NAME &OBJ_TYPE +
                          &OBJ_LIB &OBJ_ATR &OBJ_UDFN &OBJ_TEXT +
                          &OBJ_OWNR)
 
/* Copyright statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Input parameters                                                  */
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_TYPE) TYPE(*CHAR) LEN(10)
 
/* Output parameters                                                 */
             DCL        VAR(&OBJ_LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_ATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_UDFN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OBJ_OWNR) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RET_CODE) TYPE(*CHAR) LEN(7)
 
/* Work                                                              */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
 
/* Global Monitor Message                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/*/COPY WNCPYSRC,MEC9930MPS                                          */
 
 
/* Clear program message queue and initialise return code            */
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
             CHGVAR     VAR(&RET_CODE) VALUE('MEM9932')
 
/* Retrieve object definition                                        */
             RTVOBJD    OBJ(&OBJ_NAME) OBJTYPE(&OBJ_TYPE) +
                          RTNLIB(&OBJ_LIB) OBJATR(&OBJ_ATR) +
                          USRDFNATR(&OBJ_UDFN) TEXT(&OBJ_TEXT) +
                          OWNER(&OBJ_OWNR)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* If error occurs, copy messages to calling program                 */
 LOOP:       RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             IF         COND(&MSGID *NE '       ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) TOPGMQ(*SAME (&PROGRAM))
             GOTO       CMDLBL(LOOP)
             ENDDO
 
/* Terminate normally                                                */
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* If no error, send message to ourseleves with retrieved data, so   */
/* that object attributes can be viewed in joblog, and terminate.    */
             CHGVAR     VAR(&RET_CODE) VALUE('MEM9931')
             SNDPGMMSG  MSGID(MEM9931) MSGF(CGUSRMSG) +
                          MSGDTA(&OBJ_NAME *CAT &OBJ_TYPE *CAT +
                          &OBJ_LIB *CAT &OBJ_ATR *CAT &OBJ_UDFN +
                          *CAT &OBJ_TEXT *CAT &OBJ_OWNR) TOPGMQ(*SAME)
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,MEC9930MPE                                          */
 
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination processing                                   */
ABNORMAL:
 
/*/COPY WNCPYSRC,MEC9930ERR                                          */
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program MEC9930 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC9930 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*/COPY WNCPYSRC,MEC9930END                                          */
 
             ENDPGM
