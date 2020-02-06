/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Edit FETCH search library list')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       UTC0014  - EDITS FETCH LIBRARY SEARCH LIST                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01516             Date 18Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       S01516 - Incorporation of enhanced FETCH into core          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DEVSUPP)
 
             DCL        &DEVSUPP *CHAR LEN(1)
             DCL        &DEVSUPTXT *CHAR LEN(11)
             DCL        &FETCH *CHAR LEN(500)
             DCL        &RTNCDE *CHAR LEN(8)
             DCL        &FTCHLIBL *CHAR LEN(250)
 
             DCL        &MSG *CHAR LEN(77)
             DCL        &ERRORSW *LGL                     /* Std err */
             DCL        &MSGID *CHAR LEN(7)               /* Std err */
             DCL        &MSGDTA *CHAR LEN(100)            /* Std err */
             DCL        &MSGF *CHAR LEN(10)               /* Std err */
             DCL        &MSGFLIB *CHAR LEN(10)            /* Std err */
             DCL        &KEYVAR *CHAR LEN(4)              /* Std err */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO STDERR1) /* Std err */
             RMVMSG     CLEAR(*ALL)
 
/*    Set up development or support search list                      */
 
             RTVDTAARA  DTAARA(FETCH) RTNVAR(&FETCH)
             IF         COND(&DEVSUPP *EQ 'S') THEN(DO)
             CHGVAR     VAR(&FTCHLIBL) VALUE(%SST(&FETCH 1 250))
             CHGVAR     VAR(&DEVSUPTXT) VALUE('Support')
             ENDDO
             IF         COND(&DEVSUPP = 'D') THEN(DO)
             CHGVAR     VAR(&FTCHLIBL) VALUE(%SST(&FETCH 251 250))
             CHGVAR     VAR(&DEVSUPTXT) VALUE('Development')
             ENDDO
 
 CALL:       CALL       PGM(UT0014) PARM(&FTCHLIBL &DEVSUPTXT &MSG +
                          &RTNCDE)
             IF         (&RTNCDE *EQ 'GOOD') DO
 
/*    Change support search list                                     */
 
             IF         COND(&DEVSUPP = 'S') THEN(DO)
             CHGDTAARA  DTAARA(FETCH (1 250)) VALUE(&FTCHLIBL)
             MONMSG     MSGID(CPF0000) EXEC(DO)    /* Error occurred */
             RCVMSG     MSGTYPE(*DIAG) MSG(&MSG)
             GOTO       CALL
             ENDDO                                 /* Error occurred */
             ENDDO
 
/*    Change development search list                                 */
 
             IF         COND(&DEVSUPP = 'D') THEN(DO)
             CHGDTAARA  DTAARA(FETCH (251 250)) VALUE(&FTCHLIBL)
             MONMSG     MSGID(CPF0000) EXEC(DO)    /* Error occurred */
             RCVMSG     MSGTYPE(*DIAG) MSG(&MSG)
             GOTO       CALL
             ENDDO                                 /* Error occurred */
             ENDDO
 
/*    Loop to output any diagnostic messages                         */
 
 DIAGLOOP:
             RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             IF         (&MSGID *NE '       ') DO     /* Display msg */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       DIAGLOOP
             ENDDO                                    /* Display msg */
/*********** SNDPGMMSG  MSG('The FETCH search list for'****+         */ /*BG18886*/
/***********              &DEVSUPTXT****' libraries was changed') +  */ /*BG18886*/
/***********              MSGTYPE(*COMP)                             */ /*BG18886*/
             SNDPGMMSG  MSG('The FETCH search list for' *BCAT +
                          &DEVSUPTXT *TCAT ' libraries was changed') +
                          MSGTYPE(*COMP)                                /*BG18886*/
             RETURN     /* Normal end of program */
             ENDDO      /* FSLIBL changed */
 
             IF         (&RTNCDE *EQ 'F3') GOTO NOCHGMSG
             IF         (&RTNCDE *EQ 'F12') GOTO NOCHGMSG
             IF         (&RTNCDE *EQ 'NOCHG') GOTO NOCHGMSG
                        /* Error if fall thru to here */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('UT0014 program +
                          failed with a return code of ' *CAT +
                          &RTNCDE)
 
 NOCHGMSG:   SNDPGMMSG  MSG('No change made to FETCH search list') +
                          MSGTYPE(*COMP)
             RETURN     /* Normal end of program */
 
/* Standard error handling                                           */
 
 STDERR1:
             IF         &ERRORSW SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE) /* Func chk */
             CHGVAR     &ERRORSW '1' /* Set to fail if error occurs */
 STDERR2:    RCVMSG     MSGTYPE(*DIAG) RMV(*NO) KEYVAR(&KEYVAR) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             IF         (&KEYVAR *EQ '    ') GOTO STDERR3
             RMVMSG     MSGKEY(&KEYVAR)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       STDERR2 /* Loop back for addl diagnostics */
 STDERR3:    RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
