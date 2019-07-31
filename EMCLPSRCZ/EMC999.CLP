/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM Help Control Program')                       */
/********************************************************************/
/*                                                                  */
/*       Midas      EXPOSURE MANAGEMENT LINK ENQURY MODULE      */
/*                                                                  */
/*       EMC999 - CONTROL HELP FUNCTION                             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BUG18886           Date 20May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      00                 Date 00/00/00             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       BUG18886 - Non-standard codes exist in Midas Plus core     */
/*                  sources                                         */
/********************************************************************/
/*                                                                            */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&EXEC) TYPE(*CHAR) LEN(60)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DOCN) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(1)
/*  CHECK PROGRAM NAME PASSED HAS DOCUMENT                                    */
             CHGVAR     VAR(&DOCN) VALUE(&PARM)
             CHGVAR     VAR(&LIB) VALUE('N')
LOOP1:       CHKOBJ     OBJ(EMHLPSRC) OBJTYPE(*FILE) MBR(&PARM)
             MONMSG     MSGID(CPF9815) EXEC(DO)
/*     IF NOT THEN USE GENERAL HELP DOCUMENT                                  */
             CHGVAR     VAR(&DOCN) VALUE('EMH999  ')
             ENDDO
             CHGVAR     VAR(&RTCD) VALUE(' ')
/*                                                                            */
             OVRDBF     FILE(EMHLPSRC) TOFILE(EMHLPSRC) MBR(&DOCN)
             CALL       PGM(EMH990) PARM(&RTCD)
             DLTOVR     FILE(EMHLPSRC)
/*     CHECK RETURN CODES - IF 9  THEN UPDATE DOCUMENT                        */
             IF         COND(&RTCD *EQ '9') THEN(DO)
/*     IF GENERAL DOCUMENT THEN CREATE NEW DOCUMENT                           */
             IF         COND(&DOCN *EQ 'EMH999  ') THEN(DO)
             CHGVAR     VAR(&DOCN) VALUE(&PARM)
             ENDDO
/*     USE EDTSRC TO UPDATE DOCUMENT                                          */
             ADDLIBLE   QIDU
             MONMSG     MSGID(CPF2103) EXEC(CHGVAR VAR(&LIB) +
                          VALUE('Y'))
/*           CHGVAR     VAR(&EXEC) VALUE('EDTSRC SRCFILE(EMHLPSRC) +
                        SRCMBR(' ** &DOCN ** ')')                    */ /* BUG18886 */
             CHGVAR     VAR(&EXEC) VALUE('EDTSRC SRCFILE(EMHLPSRC) +
                          SRCMBR(' *CAT &DOCN *CAT ')')                 /* BUG18886 */
             CALL       PGM(QCAEXEC) PARM(&EXEC 60)
             IF         COND(&LIB *EQ 'N') THEN(DO)
             RMVLIBLE   QIDU
             ENDDO
/*                                                                            */
             GOTO       CMDLBL(LOOP1)
             ENDDO
/*                                                                            */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
