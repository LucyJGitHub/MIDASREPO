/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas TI Incoming message processing')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - TI Module                                           */
/*                                                                   */
/*       TIC0210 - Trade Innovation Incoming Message Processing     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. 259977             Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. 174955             Date 11FEB00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      156371             Date 10FEB99              */
/*                      CTI001  *CREATE    Date 14NOV97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       259977 - End if ICIFINISH is running. Applied fix 239542.   */
/*       174955 - Allocation problem in job #xxnSWTFR.               */
/*       156371 - Clear MSTISIPD  - TI SWIFT msg file                */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DS &MFLG &FILE &LIBRARY)
 
/*/COPY WNCPYSRC,TIC0210INT                                          */
 
             DCL        VAR(&DS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ICISTS) TYPE(*CHAR) LEN(1)                                   /*259977*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRARY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&ICISTS) VALUE(' ')                                           /*259977*/
             CALL       PGM(TI0211) PARM(&ICISTS)                                         /*259977*/
 
             IF         COND(&ICISTS = 'R' *OR &ICISTS = 'P') THEN(DO)                    /*259977*/
             CHGVAR     VAR(&MFLG) VALUE('N')                                             /*259977*/
             GOTO       CMDLBL(END2)                                                      /*259977*/
             ENDDO                                                                        /*259977*/
                                                                                          /*259977*/
             OVRMSGF    MSGF(TIUSRMSG) TOMSGF(GBTIUSRMSG)
             OVRMSGF    MSGF(MIDAS) TOMSGF(GBMIDAS)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,TIC0210MPS                                          */
 
/* Start commitment control */
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
 
             CHGVAR     VAR(&FILE) VALUE('MSTISIPD  ')
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&LIBRARY) VALUE(&PREFIX *TCAT 'DMLIB')
             CHGVAR     VAR(&MFLG) VALUE('N')
 
/* Call TI0210 to process messages incoming from SWIFT to TI */
             CLRPFM     FILE(&LIBRARY/&FILE)                                    /*156371*/
 
             CALL       PGM(TI0210) PARM(&DS &MFLG &FILE &LIBRARY)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                RCLRSC                                                          /*174955*/
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,TIC0210MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,TIC0210ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             RCLRSC                                                             /*174955*/
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          TIC0210 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,TIC0210END                                          */
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
 
END2:                                                                                     /*259977*/
             ENDPGM
