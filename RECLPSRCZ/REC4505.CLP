/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cashier TCP/IP branch monitor control sts')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4505 - Midas Cashier TCP/IP Branch Monitor Control Status*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. CRT004  *CREATE    Date 30May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SOCKFD &BRCH &USID &UNID)
 
/*/COPY WNCPYSRC,REC4505INT                                          */
 
             DCL        VAR(&SOCKFD) TYPE(*DEC) LEN(10)
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(4)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNID) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&JOBN)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&BRCA)   TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&BAII)   TYPE(*CHAR) LEN(264)
             DCL        VAR(&PROD)   TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,REC4505MPS                                          */
 
/* Main processing */
 
             CHGVAR     VAR(&PRFX) VALUE(%SST(&UNID 1 2))
             CHGVAR     VAR(&BRCA) VALUE(%SST(&BRCH 1 3))
             CHGVAR     VAR(&XLIB) VALUE(&PRFX *CAT 'XLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PRFX *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *CAT 'DPLIB')
 
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(QTEMP/LDA (1 3)) VALUE(&BRCA)
 
 
             RTVJOBA    NBR(&JOBN)
 
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')
             CALL       PGM(AOBAIIR0) PARM(&RTCD &OPTN &BAII)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
               CALL       PGM(REC4411) PARM('REC4505' &JOBN '0000' +
                          &BRCA 'USR0052' ' ')
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&PROD) VALUE(%SST(&BAII 15 10))
 
             IF         COND((&RTCD *EQ '       ') *AND +
                          (&PROD *EQ 'CASHIER   ')) THEN(DO)
             CALL       PGM(RE4505) PARM(&SOCKFD &BRCA &USID &PRFX)
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
 
/*/COPY WNCPYSRC,REC4505MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC4505ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4505 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,REC4505END                                          */
 
 
             ENDPGM
