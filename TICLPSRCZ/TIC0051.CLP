/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Check Midas/TI background jobs have ended')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0051 - Check that Midas/TI background jobs have ended    */
/*                                                                   */
/*       Called by CoB                                               */
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
/*       Prev Amend No. 156300 *CREATE     Date 02MAr99              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       156300 - Midas/TI jobs keep running and halting database    */
/*                 save.                                             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CHECK) TYPE(*CHAR) LEN(2) VALUE('NN')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('TIC0051 - Check Midas/TI background +
                           jobs') TOMSGQ(MRUNQ)
 
/* Attempt to allocate data areas which are locked by the jobs       */
/* TIJRNENT and TISHDPST.                                            */
 
TIJRNENT:
             IF         COND(%SST(&CHECK 1 1) *EQ 'N') THEN(DO)
                ALCOBJ     OBJ((TIJRNENT *DTAARA *EXCL))
                MONMSG     MSGID(CPF1002) EXEC(DO)
                   GOTO       CMDLBL(TISHDPST)
                ENDDO
                CHGVAR     VAR(%SST(&CHECK 1 1)) VALUE('Y')
             ENDDO
 
TISHDPST:
             IF         COND(%SST(&CHECK 2 1) *EQ 'N') THEN(DO)
                ALCOBJ     OBJ((TISHDPST *DTAARA *EXCL))
                MONMSG     MSGID(CPF1002) EXEC(DO)
                   GOTO       CMDLBL(DELAY)
                ENDDO
                CHGVAR     VAR(%SST(&CHECK 2 1)) VALUE('Y')
             ENDDO
 
             IF         COND(&CHECK *EQ 'YY') THEN(DO)
                DLCOBJ     OBJ((TIJRNENT *DTAARA *EXCL))
                DLCOBJ     OBJ((TISHDPST *DTAARA *EXCL))
                GOTO       CMDLBL(END)
             ENDDO
 
DELAY:
             DLYJOB     DLY(60)
             GOTO       CMDLBL(TIJRNENT)
 
/* Abnormal termination  */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             CHGVAR     VAR(&MSG) VALUE('TIC0051 - Check Midas/TI +
                          background jobs terminated abnormally')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
