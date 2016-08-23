/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP CPYDBLIB validity checker')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0259_VC - Validity checker for CPYDBLIB                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP034  *MOVED     Date 03Oct06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 13Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CPK010 *CREATE     Date 08Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP034 - Reduce size of implementation library.             */
/*       CPK015 - 4.01 packaging.  Improvements to CPYDBLIB.         */
/*       CPK010 - DBA R3.00 alpha site problems.                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&LIBF &LIBT &CRT &SYSPFX &THRESHOLD &JUMP)                */ /*CPK015*/
             PGM        PARM(&LIBF &LIBT &CRT &RERUN &SYSPFX +
                          &EXCEPTION &EXCPTACT &QUALJOBQ &THRESHOLD +
                          &JUMP)                                                          /*CPK015*/
 
             DCL        VAR(&LIBF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CRT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(4)                                    /*CPK015*/
             DCL        VAR(&SYSPFX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&EXCEPTION) TYPE(*CHAR) LEN(362)                              /*CPK015*/
             DCL        VAR(&EXCPTACT) TYPE(*CHAR) LEN(7)                                 /*CPK015*/
             DCL        VAR(&QUALJOBQ) TYPE(*CHAR) LEN(20)                                /*CPK015*/
             DCL        VAR(&THRESHOLD) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&JUMP) TYPE(*DEC) LEN(2 0)
 
             DCL        VAR(&EXCPTOBJ) TYPE(*CHAR) LEN(10)                                /*CPK015*/
             DCL        VAR(&EXCPTTYP) TYPE(*CHAR) LEN(8)                                 /*CPK015*/
             DCL        VAR(&NOOFEXCPTB) TYPE(*CHAR) LEN(2)                               /*CPK015*/
             DCL        VAR(&NOOFEXCPTS) TYPE(*DEC) LEN(2 0)                              /*CPK015*/
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(10)                                    /*CPK015*/
             DCL        VAR(&JOBQLIB) TYPE(*CHAR) LEN(10)                                 /*CPK015*/
 
             DCL        VAR(&REMOVE) TYPE(*CHAR) LEN(1) VALUE('Y')                        /*CPK015*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(2 0)                                   /*CPK015*/
             DCL        VAR(&STARTOBJ) TYPE(*DEC) LEN(3 0)                                /*CPK015*/
             DCL        VAR(&STARTTYP) TYPE(*DEC) LEN(3 0)                                /*CPK015*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check that first library exists */
             CHKOBJ     OBJ(&LIBF) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &LIBF +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Check that second library exists */
             CHKOBJ     OBJ(&LIBT) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Library' *BCAT &LIBT +
                          *BCAT 'does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Check that the 'to' library is not the same as the 'from' library */
             IF         COND(&LIBT *EQ &LIBF) THEN(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000The +
                             "to" library can not be the same as the +
                             "from" library') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Attempt to add 'from' library to library list. */                                      /*CPK015*/
             ADDLIBLE   LIB(&LIBF)                                                        /*CPK015*/
             MONMSG     MSGID(CPF2103) EXEC(DO)                                           /*CPK015*/
                CHGVAR     VAR(&REMOVE) VALUE('N')                                        /*CPK015*/
             ENDDO                                                                        /*CPK015*/
             MONMSG     MSGID(CPF2118) EXEC(DO)                                           /*CPK015*/
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA('0000Unable to add' *BCAT &LIBF +
                             *BCAT 'to library list.') MSGTYPE(*DIAG)                     /*CPK015*/
                CHGVAR     VAR(&ERROR) VALUE('Y')                                         /*CPK015*/
                GOTO       CMDLBL(ABNOR)                                                  /*CPK015*/
             ENDDO                                                                        /*CPK015*/
             IF         COND(&REMOVE *EQ 'Y') THEN(DO)                                    /*CPK015*/
                RMVLIBLE   LIB(&LIBF)                                                     /*CPK015*/
             ENDDO                                                                        /*CPK015*/
 
/* If exceptions have been entered check that they exist. */                              /*CPK015*/
             CHGVAR     VAR(&NOOFEXCPTB) VALUE(%SST(&EXCEPTION 1 2))                      /*CPK015*/
             CHGVAR     VAR(&NOOFEXCPTS) VALUE(%BIN(&NOOFEXCPTB))                         /*CPK015*/
             IF         COND(&NOOFEXCPTS *NE 0) THEN(DO)                                  /*CPK015*/
                CHGVAR     VAR(&COUNT) VALUE(1)                                           /*CPK015*/
                CHGVAR     VAR(&STARTOBJ) VALUE(3)                                        /*CPK015*/
                CHGVAR     VAR(&STARTTYP) VALUE(13)                                       /*CPK015*/
LOOP1:                                                                                    /*CPK015*/
                IF         COND(&COUNT *LE &NOOFEXCPTS) THEN(DO)                          /*CPK015*/
                   CHGVAR     VAR(&EXCPTOBJ) VALUE(%SST(&EXCEPTION +
                                &STARTOBJ 10))                                            /*CPK015*/
                   CHGVAR     VAR(&EXCPTTYP) VALUE(%SST(&EXCEPTION +
                                &STARTTYP 8))                                             /*CPK015*/
                   CHKOBJ     OBJ(&LIBF/&EXCPTOBJ) OBJTYPE(&EXCPTTYP)                     /*CPK015*/
                   MONMSG     MSGID(CPF9801) EXEC(DO)                                     /*CPK015*/
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                   MSGDTA('0000Object' *BCAT &EXCPTOBJ  +
                                   *TCAT ', type' *BCAT &EXCPTTYP *BCAT +
                                   'does not exist in' *BCAT &LIBF) +
                                   MSGTYPE(*DIAG)                                         /*CPK015*/
                      CHGVAR     VAR(&ERROR) VALUE('Y')                                   /*CPK015*/
                      GOTO       CMDLBL(ABNOR)                                            /*CPK015*/
                   ENDDO                                                                  /*CPK015*/
                   CHGVAR     VAR(&COUNT) VALUE(&COUNT +1)                                /*CPK015*/
                   CHGVAR     VAR(&STARTOBJ) VALUE(&STARTOBJ + 18)                        /*CPK015*/
                   CHGVAR     VAR(&STARTTYP) VALUE(&STARTTYP + 18)                        /*CPK015*/
                   GOTO       CMDLBL(LOOP1)                                               /*CPK015*/
                ENDDO                                                                     /*CPK015*/
             ENDDO                                                                        /*CPK015*/
 
/* If exceptions have been entered and *SUBMIT specified as an action */                  /*CPK015*/
/*  then check a job queue has been entered and that it exists.       */                  /*CPK015*/
             IF         COND(&NOOFEXCPTS *GT 0 *AND &EXCPTACT *EQ +
                          '*SUBMIT') THEN(DO)                                             /*CPK015*/
                CHGVAR     VAR(&JOBQ) VALUE(%SST(&QUALJOBQ 1 10))                         /*CPK015*/
                CHGVAR     VAR(&JOBQLIB) VALUE(%SST(&QUALJOBQ 11 10))                     /*CPK015*/
                IF         COND(&JOBQ *EQ ' ') THEN(DO)                                   /*CPK015*/
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000A +
                                job queue must be entered') MSGTYPE(*DIAG)                /*CPK015*/
                   CHGVAR     VAR(&ERROR) VALUE('Y')                                      /*CPK015*/
                   GOTO       CMDLBL(ABNOR)                                               /*CPK015*/
                ENDDO
                ELSE       CMD(DO)
                   CHKOBJ     OBJ(&JOBQLIB/&JOBQ) OBJTYPE(*JOBQ) AUT(*USE)
                   MONMSG     MSGID(CPF9801) EXEC(DO)
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000Job +
                                   queue' *BCAT &JOBQLIB *TCAT '/' *TCAT +
                                   &JOBQ *BCAT 'does not exist.') MSGTYPE(*DIAG)          /*CPK015*/
                      CHGVAR     VAR(&ERROR) VALUE('Y')                                   /*CPK015*/
                      GOTO       CMDLBL(ABNOR)                                            /*CPK015*/
                   ENDDO                                                                  /*CPK015*/
                   MONMSG     MSGID(CPF9820) EXEC(DO)
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000You +
                                   do not have authority to the library +
                                   containing the job queue.') +
                                   MSGTYPE(*DIAG)                                         /*CPK015*/
                      CHGVAR     VAR(&ERROR) VALUE('Y')                                   /*CPK015*/
                      GOTO       CMDLBL(ABNOR)                                            /*CPK015*/
                   ENDDO                                                                  /*CPK015*/
                   MONMSG     MSGID(CPF9820) EXEC(DO)
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000You +
                                   do not have authority to the job queue.') +
                                   MSGTYPE(*DIAG)                                         /*CPK015*/
                      CHGVAR     VAR(&ERROR) VALUE('Y')                                   /*CPK015*/
                      GOTO       CMDLBL(ABNOR)                                            /*CPK015*/
                   ENDDO                                                                  /*CPK015*/
                ENDDO                                                                     /*CPK015*/
             ENDDO                                                                        /*CPK015*/
 
             GOTO       CMDLBL(END)
 
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
 ABNOR:      IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
