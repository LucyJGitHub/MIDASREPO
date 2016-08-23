/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB Add trigger programs for Alerter')           */
/*********************************************************************/
/*                                                                   */
/*        Midas - Private Banking Module                             */
/*                                                                   */
/*       PBCADDTRG - Add trigger program on files defined in         */
/*                   PF/PBALERTPD                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPB009  *CREATE    Date 12Sep02              */
/*                                                                   */
/* ------------------------------------------------------------------*/
/*                                                                   */
/*       CPB009 - PB Operator Message Handling                       */
/*                (PB Alerter - error tracking)                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
             DCL        VAR(&PBPROCESS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
 
             DCLF       FILE(PBALERTPD)
 
/*   INITIAL PROCESSING                                             */
 
 /*          MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR) */
 
             SNDPGMMSG  MSG('Remove trigger program') TOMSGQ(MOPERQ)
 
NEXTREC:     RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
             CHGVAR     VAR(&FILE) VALUE(%SST(&PBPROCESS 1 10))
             IF         COND(&PBTRG *NE *BLANKS ) THEN(DO)
             CHGVAR     VAR(&PGM) VALUE(%SST(&PBTRG 1 10))
             IF         COND(&PBTRGI *EQ 'Y' ) THEN(DO)
             ADDPFTRG   FILE(&FILE) TRGTIME(*AFTER) +
                          TRGEVENT(*INSERT) PGM(&PGM)
             MONMSG     MSGID(CPC3204)
             ENDDO
             IF         COND(&PBTRGU *EQ 'A' ) THEN(DO)
             ADDPFTRG   FILE(&FILE) TRGTIME(*AFTER) +
                          TRGEVENT(*UPDATE) PGM(&PGM) +
                          TRGUPDCND(*ALWAYS)
             MONMSG     MSGID(CPC3204)
             ENDDO
             IF         COND(&PBTRGU *EQ 'C') THEN(DO)
             ADDPFTRG   FILE(&FILE) TRGTIME(*AFTER) +
                          TRGEVENT(*UPDATE) PGM(&PGM) +
                          TRGUPDCND(*CHANGE)
             MONMSG     MSGID(CPC3204)
             ENDDO
             IF         COND(&PBTRGD *EQ 'Y') THEN(DO)
             ADDPFTRG   FILE(&FILE) TRGTIME(*AFTER) +
                          TRGEVENT(*DELETE) PGM(&PGM)
             MONMSG     MSGID(CPC3204)
             ENDDO
             ENDDO
             GOTO       CMDLBL(NEXTREC)
ABNOR:
 
             SNDPGMMSG  MSG('Remove trigger program ended    +
                          abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
