/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cashier TCP/IP branch monitor control')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Cashier Interface Module                            */
/*                                                                   */
/*       REC4502 - Midas Cashier TCP/IP Branch Monitor Control       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015             Date 25Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 14Nov01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CRT004  *CREATE    Date 13Jun00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       CPK014 - Release 4 packaging:                               */
/*                 - Ensure that the dtaq picks up the system        */
/*                   ownerships.                                     */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SOCKFD &BRCH &USID &UNID)
 
/*/COPY WNCPYSRC,REC4502INT                                          */
 
             DCL        VAR(&SOCKFD) TYPE(*DEC) LEN(10)
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(4)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNID) TYPE(*CHAR) LEN(3)
 
             DCL        VAR(&JOBN)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRFX)   TYPE(*CHAR) LEN(2)
/************DCL        VAR(&XLIB)   TYPE(*CHAR) LEN(10)                               */ /*CPK015*/
/************DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)                               */ /*CPK015*/
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)                                 /*CPK015*/
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)                                   /*CPK014*/
             DCL        VAR(&BMDTAARA)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTFDQ)  TYPE(*CHAR) LEN(10)
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
 
/*/COPY WNCPYSRC,REC4502MPS                                          */
 
/* Main processing */
 
             CHGVAR     VAR(&PRFX) VALUE(%SST(&UNID 1 2))
             CHGVAR     VAR(&BRCA) VALUE(%SST(&BRCH 1 3))
/************CHGVAR     VAR(&XLIB) VALUE(&PRFX *CAT 'XLIB')                            */ /*CPK015*/
/************CHGVAR     VAR(&DMLIB) VALUE(&PRFX *CAT 'DMLIB')                          */ /*CPK015*/
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *CAT 'DPLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&PRFX *CAT 'DPLIB')                           /*CPK015*/
 
 
/* Create local data area */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(QTEMP/LDA (1 3)) VALUE(&BRCA)
 
             RTVJOBA    NBR(&JOBN)
 
             CHGVAR     VAR(&BMDTAARA) VALUE('CASH_' *CAT &BRCA)
             CRTDTAARA  DTAARA(&DPLIB/&BMDTAARA) TYPE(*CHAR) LEN(1) +
                          VALUE(*) TEXT('CI Branch Monitor Data +
                          Area') AUT(*ALL)
             MONMSG     MSGID(CPF1023)
 
/* Attempt to allocate the data area. If it is already locked, then */
/* the branch monitor is already active.                            */
 
             ALCOBJ     OBJ((&DPLIB/&BMDTAARA *DTAARA *EXCL)) +
                          WAIT(1)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(STARTED))
 
 
             CHGVAR     VAR(&BTFDQ) VALUE('CASHTF_' *CAT &BRCA)
/************CRTDTAQ    DTAQ(&XLIB/&BTFDQ) MAXLEN(29) TEXT('CI +                       */ /*CPK015*/
/************             Branch Monitor Trickle Feed Data Queue') +                   */ /*CPK015*/
/************             AUT(*ALL)                                                    */ /*CPK015*/
/************MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                 */ /*CPK015*/
             CHKOBJ     OBJ(&DTAQLIB/&BTFDQ) OBJTYPE(*DTAQ)                               /*CPK015*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CPK015*/
                CRTDTAQ    DTAQ(&DTAQLIB/&BTFDQ) MAXLEN(29) TEXT('CI +
                             Branch Monitor Trickle Feed Data Queue')                     /*CPK015*/
                RTVOBJD    OBJ(&DTAQLIB) OBJTYPE(*LIB) OWNER(&OWNER)                      /*CPK015*/
                CHGOBJOWN  OBJ(&DTAQLIB/BTFDQ) OBJTYPE(*DTAQ) +
                             NEWOWN(&OWNER)                                               /*CPK015*/
             ENDDO                                                                        /*CPK015*/
 
/**Correct*the*ownership*of*the*dtaq**/                                        /*CPK014*/ /*CPK015*/
/************RTVOBJD    OBJ(&XLIB) OBJTYPE(*LIB) OWNER(&OWNER)                            /*CPK014*/
/************CHGOBJOWN  OBJ(&XLIB/&BTFDQ) OBJTYPE(*DTAQ) +                             */ /*CPK015*/
/************             NEWOWN(&OWNER)                                       /*CPK014*/ /*CPK015*/
 
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')
             CALL       PGM(AOBAIIR0) PARM(&RTCD &OPTN &BAII)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
               CALL       PGM(REC4411) PARM('REC4502' &JOBN '0000' +
                          &BRCA 'USR0052' ' ')
               GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&PROD) VALUE(%SST(&BAII 15 10))
 
             IF         COND((&RTCD *EQ '       ') *AND +
                          (&PROD *EQ 'CASHIER   ')) THEN(DO)
             CALL       PGM(RE4502) PARM(&SOCKFD &BRCA &USID &PRFX)
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
 
/*/COPY WNCPYSRC,REC4502MPE                                          */
 
             GOTO       CMDLBL(END)
 
 STARTED:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('CI Branch Monitor Is Already  +
                          Running') TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,REC4502ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4502 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,REC4502END                                          */
 
 
             ENDPGM
