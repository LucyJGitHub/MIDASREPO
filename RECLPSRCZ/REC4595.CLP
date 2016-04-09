/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE CI Heartbeat to change Branch status')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4595 - Midas Cashier TCP/IP Heartbeat Job.               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CRT007  *CREATE    Date 14Jan02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CRT007 - PING Server for Communication check.               */
/*                Set Branch Off-Line if fail when open.             */
/*                N.B. A Server which is shut down normally to the   */
/*                re-start/switch off screen is still shown as       */
/*                active by PING.                                    */
/*                                                                   */
/*********************************************************************/
     PGM &BRC
             DCL        VAR(&BRC) TYPE(*CHAR) LEN(3)
             DCL        VAR(&HBEAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PORT) TYPE(*DEC) LEN(4)
             DCL        VAR(&RMTAD) TYPE(*CHAR) LEN(17)
             DCL        VAR(&MSGR) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PUNKT) TYPE(*CHAR) LEN(1) VALUE('.')
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCLF       RECITCPD
             MONMSG CPF0000 TCP0000
/**/
/* RECITCPD IS A DPLIB FILE WHICH LINKS BRANCH TO PORT TO SERVER  */
/* IP ADDRESS.                                                    */
/**/
NEXT:     RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
          IF (&TCBRCH *NE &BRC) GOTO NEXT
             CHGVAR VAR(&RMTAD) VALUE(&TCIP1 *TCAT +
              &PUNKT *TCAT &TCIP2 *TCAT &PUNKT *TCAT &TCIP3 +
              *TCAT &PUNKT *TCAT &TCIP4)
 /**/
 /* PING THE SERVER.  */
 /* IF THERE IS AN ERROR, EXIT THE LOOP, UPDATE THE STATUS AND END */
 /* READ ALL MESSAGES AFTER THE PING AND CHECK FOR ERROR           */
 /**/
 HBEAT:      PING       RMTSYS(&RMTAD) WAITTIME(10)
             MONMSG     MSGID(TCP0000)
 /**/
 CHKMSG:     RCVMSG     MSGQ(*PGMQ) RMV(*YES) MSGID(&MSGR)
             MONMSG     MSGID(CPF2400) CMPDTA(EXEC) EXEC(GOTO +
                          CMDLBL(DLY))
             IF         COND(&MSGR *EQ 'TCP3204' *OR &MSGR *EQ +
        'TCP3210' *OR &MSGR *EQ 'TCP3211' *OR &MSGR *EQ 'TCP3215') +
                          THEN(GOTO CMDLBL(CHKMSG))
              IF         COND(&MSGR *NE 'TCP3206') THEN(GOTO +
                         CMDLBL(DLY))
              ELSE DO
                 /* CALL RE4595 TO UPDATE BRANCH STATUS IF NECESSARY */
             CALL       PGM(RE4595) PARM(&BRC &RMTAD)
                 CHGVAR &HBEAT 'PING_ERROR'
                 DMPCLPGM
             SNDUSRMSG  MSG('Connection to Cashier Server failed for +
             Branch' *BCAT &BRC) MSGTYPE(*INFO) TOMSGQ(*LIBL/MOPERQ)
                 GOTO END
              ENDDO
 /**/
DLY:   DLYJOB     DLY(120)
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**********   IF         COND(&MPHAS *NE 'A') THEN(GOTO +                              */ /*CCB020*/
/**********              CMDLBL(END))                                                  */ /*CCB020*/
              IF         COND((&MPHAS *NE 'A') *AND (&MPHAS *NE +
                           'G')) THEN(GOTO CMDLBL(END))                                   /*CCB020*/
       CHGJOB     LOG(*SAME 40) LOGCLPGM(*NO) /*REDUCE LOG ENTRIES */
       GOTO HBEAT
 /**/
END:
     ENDPGM
