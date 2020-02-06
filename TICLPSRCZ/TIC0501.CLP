/********************************************************************/
/*S*D****CLPBASEBND**************************************************/                  /*MD029775*/
/*STD    CLPBASE                                                    */                  /*MD030956*/
/*EXI    TEXT('Midas TI Midas/TI Interface Cob Control Job (2nd)')   */
/********************************************************************/
/*                                                                  */
/*       Midas/Trade Innovation Interface Module                    */
/*                                                                  */
/*       TIC0501 - TI COB Control Program                           */
/*                                                                  */
/*       Function : This program controls the latter stages of the  */
/*                  TI Close of Business. It starts the TI phases   */
/*                  of COB and handles the response messages.       */
/*                                                                  */
/*          COB  -  The program runs in the Close of Business to    */
/*                  and will handle all errors as they arise.       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD030956           Date 09Oct14              */
/*                      MD029775           Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG5295            Date 23Dec04             */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CTI003 *CREATE     Date 15Sep00             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       MD030956 - Additional changes to BFM-TI enhancement.       */
/*                  Reinstated for future use in case of downgrade. */
/*       MD029775 - TI/Midas EOD sync will no longer be used by TI  */
/*                  Plus                                            */
/*       BUG5295 - Handle *PROP STOP message left on data queue.    */
/*       CTI003 - Midas/TI Interface CoB                            */
/*                                                                  */
/********************************************************************/
             PGM
 
/* Declarations */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&STS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EODOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STARTPROP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATEWAIT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SODOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RELOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SONL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SONLOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&KEYWD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIRSTRUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESGS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             CHGJOB     SWS(XXXXXX00)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Retrieve the Data area flags for status of TI CoB Phases */
             RTVDTAARA  DTAARA(TIDTA (61 10)) RTNVAR(&STS)
             CHGVAR     VAR(&EOD) VALUE(%SST(&STS 1 1))
             CHGVAR     VAR(&EODOK) VALUE(%SST(&STS 2 1))
             CHGVAR     VAR(&STARTPROP) VALUE(%SST(&STS 3 1))
             CHGVAR     VAR(&DATEWAIT) VALUE(%SST(&STS 4 1))
             CHGVAR     VAR(&SOD) VALUE(%SST(&STS 5 1))
             CHGVAR     VAR(&SODOK) VALUE(%SST(&STS 6 1))
             CHGVAR     VAR(&REL) VALUE(%SST(&STS 7 1))
             CHGVAR     VAR(&RELOK) VALUE(%SST(&STS 8 1))
             CHGVAR     VAR(&SONL) VALUE(%SST(&STS 9 1))
             CHGVAR     VAR(&SONLOK) VALUE(%SST(&STS 10 1))
 
/* Check status of send STREOD message to ensure it was sent */
 EOD:
             IF         COND((&EOD *EQ 'B') *OR (&EOD *EQ 'C')) +
                          THEN(DO)
                GOTO       CMDLBL(EODOK)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status */
                CHGDTAARA  DTAARA(TIDTA (61 1)) VALUE('R')
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&KEYWD) VALUE('*BATCH    ')
                CHGVAR     VAR(&MESGS) VALUE('STREOD')
                CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect STREOD failed */
                   CHGDTAARA  DTAARA(TIDTA (61 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0032) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect STREOD successful */
                CHGDTAARA  DTAARA(TIDTA (61 1)) VALUE('C')
 
             ENDDO
 
/* Receive STREOD message */
 EODOK:
/* Decide which phase to start from */
             IF         COND(&EODOK *EQ 'C') THEN(DO)
                GOTO       CMDLBL(STARTPROP)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TI program KAPENEQ */
                CHGDTAARA  DTAARA(TIDTA (62 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(0)
                CHGVAR     VAR(&SEND) VALUE(' ')
                SNDPGMMSG  MSGID(TIM0059) MSGF(TIUSRMSG)
                CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
 
/* If component times out then end. */
                IF         COND(&LENGTH *EQ 0) THEN(DO)
                      CHGDTAARA  DTAARA(TIDTA (62 1)) VALUE('T')
                      SNDPGMMSG  MSGID(TIM0036) MSGF(TIUSRMSG)
                      GOTO       CMDLBL(ABNOR)
                ENDDO
                                                                                        /*BUG5295*/
/* If the return parameter is *PROP STOPPED, this has been left on the queue */         /*BUG5295*/
/* in error so re-read the queue to access the following STREOD* message */             /*BUG5295*/
               IF      COND(%SST(&SEND 11 10) *EQ 'STOPPED') THEN(DO)                   /*BUG5295*/
                  SNDPGMMSG  MSGID(TIM0082) MSGF(TIUSRMSG)                              /*BUG5295*/
                  GOTO       CMDLBL(EODOK)                                              /*BUG5295*/
               ENDDO                                                                    /*BUG5295*/
 
 /* If the return parameter shows failure then end */
                IF         COND(%SST(&SEND 11 10) *EQ 'STREODFAIL') +
                          THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (62 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0037) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter is correct then continue */
                IF      COND(%SST(&SEND 11 10) *EQ 'STREODOK') THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (62 1)) VALUE('C')
                   GOTO       CMDLBL(STARTPROP)
                ENDDO
                ELSE       CMD(DO)
 
                   SNDPGMMSG  MSGID(TIM0038) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (62 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
 
/* Send message to start Propigation Job */
 STARTPROP:
/* Decide which phase to start from */
             IF         COND(&STARTPROP *EQ 'C') THEN(DO)
                GOTO       CMDLBL(DATEWAIT)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TI program KAPENEQ */
                CHGDTAARA  DTAARA(TIDTA (63 1)) VALUE('R')
 
/* If this is the first run then do not start the Prop. Job now */
                RTVDTAARA  DTAARA(TIDTA (31 1)) RTNVAR(&FIRSTRUN)
                IF         COND(&FIRSTRUN *EQ 'Y') THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (63 2)) VALUE('CC')
                   GOTO       CMDLBL(SOD)
                ENDDO
/* Otherwise call KAPEQEN to send message to TI */
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&SEND) VALUE('*PROP     START')
                SNDPGMMSG  MSGID(TIM0066) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect that attempt to start Prop. Job failed */
                   CHGDTAARA  DTAARA(TIDTA (63 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0057) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect Start of Prop. job successful */
                CHGDTAARA  DTAARA(TIDTA (63 1)) VALUE('C')
 
             ENDDO
 DATEWAIT:
/* Decide which phase to start from */
             IF         COND(&DATEWAIT *EQ 'C') THEN(DO)
                GOTO       CMDLBL(SOD)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TIC0052 */
                CHGDTAARA  DTAARA(TIDTA (64 1)) VALUE('R')
                CALL       PGM(TIC0052)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
/* Update TIDTA to reflect that TIC0052 failed */
                   CHGJOB     SWS(XXXXXX00)
                   CHGDTAARA  DTAARA(TIDTA (64 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0058) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect TIC0052 successful */
                CHGDTAARA  DTAARA(TIDTA (64 1)) VALUE('C')
 
             ENDDO
 SOD:
/* Decide which phase to start from */
             IF         COND(&SOD *EQ 'C') THEN(DO)
                GOTO       CMDLBL(SODOK)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TI program KAPEQEN */
                CHGDTAARA  DTAARA(TIDTA (65 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&KEYWD) VALUE('*BATCH    ')
                CHGVAR     VAR(&MESGS) VALUE('STRSOD')
                CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
                SNDPGMMSG  MSGID(TIM0060) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect STRSOD failed */
                   SNDPGMMSG  MSGID(TIM0039) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (65 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect STRSOD successful */
                CHGDTAARA  DTAARA(TIDTA (65 1)) VALUE('C')
 
             ENDDO
 
 SODOK:
/* Decide which phase to start from */
             IF         COND(&SODOK *EQ 'C') THEN(DO)
                GOTO       CMDLBL(REL)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TI program KAPENEQ */
                CHGDTAARA  DTAARA(TIDTA (66 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(0)
                CHGVAR     VAR(&SEND) VALUE(' ')
                SNDPGMMSG  MSGID(TIM0061) MSGF(TIUSRMSG)
                CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
 
/* If component times out then end. */
                IF         COND(&LENGTH *EQ 0) THEN(DO)
                      CHGDTAARA  DTAARA(TIDTA (66 1)) VALUE('T')
                      SNDPGMMSG  MSGID(TIM0040) MSGF(TIUSRMSG)
                      GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter shows failure then end */
                IF         COND(%SST(&SEND 11 10) *EQ 'STRSODFAIL') +
                          THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (66 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0041) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter is correct then continue */
                IF         COND(%SST(&SEND 11 10) *EQ 'STRSODOK') +
                             THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (66 1)) VALUE('C')
                   GOTO       CMDLBL(REL)
                ENDDO
             ELSE       CMD(DO)
 
                   SNDPGMMSG  MSGID(TIM0042) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (66 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
 
 REL:
/* Decide which phase to start from */
             IF         COND(&REL *EQ 'C') THEN(DO)
                GOTO       CMDLBL(RELOK)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TI program KAPEQEN */
                CHGDTAARA  DTAARA(TIDTA (67 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&KEYWD) VALUE('*MODE     ')
                CHGVAR     VAR(&MESGS) VALUE('RELEASE')
                CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
                SNDPGMMSG  MSGID(TIM0062) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect RELEASE failed */
                   SNDPGMMSG  MSGID(TIM0043) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (67 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect RELEASE successful */
                CHGDTAARA  DTAARA(TIDTA (67 1)) VALUE('C')
 
             ENDDO
 
RELOK:
/* Decide which phase to start from */
             IF         COND(&RELOK *EQ 'C') THEN(DO)
                GOTO       CMDLBL(SONL)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TI program KAPENEQ */
                CHGDTAARA  DTAARA(TIDTA (68 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(0)
                CHGVAR     VAR(&SEND) VALUE(' ')
                SNDPGMMSG  MSGID(TIM0063) MSGF(TIUSRMSG)
                CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
 
/* If component times out, flag the send of RELEASE as Failed so */
/*  that RELESAE will be re-sent when TIC0501 is restarted.      */
                IF         COND(&LENGTH *EQ 0) THEN(DO)
                      CHGDTAARA  DTAARA(TIDTA (68 1)) VALUE('T')
                      CHGDTAARA  DTAARA(TIDTA (67 1)) VALUE('F')
                      SNDPGMMSG  MSGID(TIM0044) MSGF(TIUSRMSG)
                      GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter is correct then continue */
                IF         COND(%SST(&SEND 11 10) *EQ 'RELEASEOK') +
                             THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (68 1)) VALUE('C')
                   GOTO       CMDLBL(SONL)
                ENDDO
                ELSE       CMD(DO)
 
/* If component fails, flag the send of RELEASE as Failed so     */
/*  that RELEASE will be re-sent when TIC0500 is restarted.      */
                   SNDPGMMSG  MSGID(TIM0045) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (68 1)) VALUE('F')
                   CHGDTAARA  DTAARA(TIDTA (67 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
 
 SONL:
/* Decide which phase to start from */
             IF         COND(&SONL *EQ 'C') THEN(DO)
                GOTO       CMDLBL(SONLOK)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TI program KAPEQEN */
                CHGDTAARA  DTAARA(TIDTA (69 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(20)
                CHGVAR     VAR(&KEYWD) VALUE('*BATCH    ')
                CHGVAR     VAR(&MESGS) VALUE('STRSONL')
                CHGVAR     VAR(&SEND) VALUE(&KEYWD *CAT &MESGS)
                SNDPGMMSG  MSGID(TIM0064) MSGF(TIUSRMSG)
                CALL       PGM(KAPEQEN) PARM(&SEND &LENGTH)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
 
/* Update TIDTA to reflect STREOD failed */
                   CHGDTAARA  DTAARA(TIDTA (69 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0046) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
 
                ENDDO
 
/* Update TIDTA to reflect STRSONL successful */
                CHGDTAARA  DTAARA(TIDTA (69 1)) VALUE('C')
                GOTO       CMDLBL(SONLOK)
 
             ENDDO
SONLOK:
/* Decide which phase to start from */
             IF         COND(&SONLOK *EQ 'C') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
             ELSE       CMD(DO)
 
/* Update TIDTA to show 'Running' status and call TI program KAPENEQ */
                CHGDTAARA  DTAARA(TIDTA (70 1)) VALUE('R')
 
                CHGVAR     VAR(&LENGTH) VALUE(0)
                CHGVAR     VAR(&SEND) VALUE(' ')
                SNDPGMMSG  MSGID(TIM0065) MSGF(TIUSRMSG)
                CALL       PGM(KAPENEQ) PARM(&SEND &LENGTH)
 
/* If component times out then end. */
                IF         COND(&LENGTH *EQ 0) THEN(DO)
                      CHGDTAARA  DTAARA(TIDTA (70 1)) VALUE('T')
                      SNDPGMMSG  MSGID(TIM0047) MSGF(TIUSRMSG)
                      GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter shows failure then end */
                IF         COND(%SST(&SEND 11 10) *EQ 'STRSONLFAIL') +
                          THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (70 1)) VALUE('F')
                   SNDPGMMSG  MSGID(TIM0048) MSGF(TIUSRMSG)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
 /* If the return parameter is correct then continue */
                IF         COND(%SST(&SEND 11 10) *EQ 'STRSONLOK') +
                             THEN(DO)
                   CHGDTAARA  DTAARA(TIDTA (70 1)) VALUE('C')
                   GOTO       CMDLBL(END)
                ENDDO
                ELSE       CMD(DO)
 
                   SNDPGMMSG  MSGID(TIM0049) MSGF(TIUSRMSG)
                   CHGDTAARA  DTAARA(TIDTA (70 1)) VALUE('F')
                   GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
 
/* Abnormal termination  */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&MSG) VALUE('TIC0501 - TI CoB Control +
                          Job ended abnormally')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSG)
             MONMSG     MSGID(CPF0000 MCH0000)
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
