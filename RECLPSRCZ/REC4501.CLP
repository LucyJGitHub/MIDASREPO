/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cashier TCP/IP communications program ctl')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4501 - Midas Cashier TCP/IP Communications Program Ctrl  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 25Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CRT004  *CREATE    Date 13Jun00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK015 - Set authorities for data queues.                   */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SOCKFD &BRCH &USID &UNID)
 
/*/COPY WNCPYSRC,REC4501INT                                          */
 
             DCL        VAR(&SOCKFD) TYPE(*DEC) LEN(10)
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(4)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNID) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&JOBN)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&JBDQ)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)                                 /*CPK015*/
             DCL        VAR(&BRCA)   TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&BAII)   TYPE(*CHAR) LEN(264)
             DCL        VAR(&PROD)   TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,REC4501MPS                                          */
 
/* Main processing */
 
             CHGVAR     VAR(&PRFX) VALUE(%SST(&UNID 1 2))
             CHGVAR     VAR(&BRCA) VALUE(%SST(&BRCH 1 3))
             CHGVAR     VAR(&XLIB) VALUE(&PRFX *CAT 'XLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRFX *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *CAT 'DPLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&PRFX *CAT 'DPLIB')                           /*CPK015*/
 
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(QTEMP/LDA (1 3)) VALUE(&BRCA)
 
 
             RTVJOBA    NBR(&JOBN)
 
             CHGVAR     VAR(&JBDQ) VALUE('CASH' *CAT &JOBN)
/************CRTDTAQ    DTAQ(&XLIB/&JBDQ) MAXLEN(2560) AUT(*ALL)                       */ /*CPK015*/
             CRTDTAQ    DTAQ(&DTAQLIB/&JBDQ) MAXLEN(2560) AUT(*ALL)                       /*CPK015*/
 
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')
             CALL       PGM(AOBAIIR0) PARM(&RTCD &OPTN &BAII)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
               CALL       PGM(REC4411) PARM('REC4501' &JOBN '0000' +
                          &BRCA 'USR0052' ' ')
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&PROD) VALUE(%SST(&BAII 15 10))
 
             IF         COND((&RTCD *EQ '       ') *AND +
                          (&PROD *EQ 'CASHIER   ')) THEN(DO)
             CALL       PGM(RE4501) PARM(&SOCKFD &BRCA &USID &PRFX)
               GOTO     CMDLBL(END)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,REC4501MPE                                          */
 
             GOTO       CMDLBL(END)
 
 STARTED:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Branch Monitor Is Already  +
                          Running') TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC4501ERR                                          */
/************DLTDTAQ    DTAQ(&XLIB/&JBDQ)                                              */ /*CPK015*/
             DLTDTAQ    DTAQ(&JBDQ)                                                       /*CPK015*/
 
             CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4501 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC4501END                                          */
 
 
             ENDPGM
