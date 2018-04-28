/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Teller transn entry generation')             */
/*********************************************************************/
/*                                                                   */
/*       Midas Retail Module                                         */
/*                                                                   */
/*       REC4201 - Teller Transacion Entry Generation                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      CEU025             Date 31Aug98              */
/*                      CEU024             Date 14Jul98              */
/*                      CRT001  *CREATE    Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CEU025 - EMU Midas-Cashier Interface                        */
/*       CEU024 - EMU  Retail Teller Support Enhancement             */
/*       CRT001  -  Retail Teller System                             */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&LDA)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                /*CEU024*/
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB') /*CEU024*/
             DCL        VAR(&CEU024) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU024*/
             DCL        VAR(&CEU013) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU024*/
             DCL        VAR(&CEU025) TYPE(*CHAR) LEN(1) VALUE('N')    /*CEU025*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
/**/
/* MONITOR GLOBAL MESSAGES */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('Teller Transaction Entries Generation') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/**/
/* CHANGE JOB SWITCH SETTINGS */
/**/
             CHGJOB SWS(00000000)
/**/
/* INITIALIZE LDA */
/**/
             CHGDTAARA DTAARA(LDA) VALUE(' ')
/**/
/* CLEAR PHYSICAL FILE MEMBER */
/**/
             CLRPFM GETTPH
             CLRPFM GETTPD
             CLRPFM GETTPZ
 
             CLRPFM TTIBPH
             CLRPFM TTIBPD
             CLRPFM TTIBPZ
/**/
/* OVERRIDE LF/TTRANL2 TO MEMBER(*ALL) */
/**/
             OVRDBF     FILE(TTRANL2) MBR(*ALL)
/**/                                                                  /*CEU024*/
/* Check if CEU024 and CEU013 feature is on*/                         /*CEU024*/
/* or if CEU025 and CEU013 feature is on*/                            /*CEU025*/
/**/                                                                  /*CEU024*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU024*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU024*/
             CHGVAR     VAR(&SAR) VALUE('CEU024')                     /*CEU024*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU024*/
             IF         COND(&RTCD *EQ '       ') +
                  THEN(CHGVAR VAR(&CEU024) VALUE('Y'))                /*CEU024*/
             IF         COND(&RTCD *NE '       ' *AND +
                  &RTCD *NE '*NRF   ') THEN(DO)                       /*CEU024*/
                  CHGJOB     SWS(XXXXXX11)                            /*CEU024*/
                  GOTO       CMDLBL(ABNORMAL)                         /*CEU024*/
                  ENDDO                                               /*CEU024*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU024*/
             CHGVAR     VAR(&SAR) VALUE('CEU013')                     /*CEU024*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU024*/
             IF         COND(&RTCD *EQ '       ') +
                  THEN(CHGVAR VAR(&CEU013) VALUE('Y'))                /*CEU024*/
             IF         COND(&RTCD *NE '       ' *AND +
                  &RTCD *NE '*NRF   ') THEN(DO)                       /*CEU024*/
                  CHGJOB     SWS(XXXXXX11)                            /*CEU024*/
                  GOTO       CMDLBL(ABNORMAL)                         /*CEU024*/
                  ENDDO                                               /*CEU024*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU025*/
             CHGVAR     VAR(&SAR) VALUE('CEU025')                     /*CEU025*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CEU025*/
             IF         COND(&RTCD *EQ '       ') +
                  THEN(CHGVAR VAR(&CEU025) VALUE('Y'))                /*CEU025*/
             IF         COND(&RTCD *NE '       ' *AND +
                  &RTCD *NE '*NRF   ') THEN(DO)                       /*CEU025*/
                  CHGJOB     SWS(XXXXXX11)                            /*CEU025*/
                  GOTO       CMDLBL(ABNORMAL)                         /*CEU025*/
                  ENDDO                                               /*CEU025*/
/**/
/* CALL PROGRAM */
/**/
/*********** IF        COND(&CEU024 *EQ 'Y' *AND &CEU013 *EQ 'Y') +
/***********      THEN(DO)                              */ /*CEU024*/ /*CEU025*/
             IF         COND((&CEU024 *EQ 'Y' *AND &CEU013 *EQ 'Y') +
                          *OR (&CEU025 *EQ 'Y' *AND &CEU013 *EQ 'Y')) +
                          THEN(DO)                                    /*CEU025*/
                  CLRPFM     FILE(GETT1APD)                           /*CEU024*/
                  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)      /*CEU024*/
                  CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID) /*CEU024*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                  CRTJRNRCV  JRNRCV(&JLIB/JRREC4201)                  /*CEU024*/
                  CRTJRN     JRN(&JLIB/JREC4201) +
                       JRNRCV(&JLIB/JRREC4201)                        /*CEU024*/
                  STRJRNPF   FILE(GLAPNAPD) JRN(&JLIB/JREC4201) +
                       IMAGES(*BOTH) OMTJRNE(*OPNCLO)                 /*CEU024*/
             ENDDO                                                    /*CCB009*/
/**********       STRCMTCTL  LCKLVL(*CHG)                      /*CEU024 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
                  ENDDO                                               /*CEU024*/
/**/                                                                  /*CEU024*/
             CALL          PGM(RE4201)
/*********** IF         COND(&CEU024 *EQ 'Y' *AND &CEU013 *EQ 'Y') +
/***********      THEN(DO)                              */ /*CEU024*/ /*CEU025*/
             IF         COND((&CEU024 *EQ 'Y' *AND &CEU013 *EQ 'Y') +
                          *OR (&CEU025 *EQ 'Y' *AND &CEU013 *EQ 'Y')) +
                          THEN(DO)                                    /*CEU025*/
                  IF         COND(%SWITCH(XXXXXX11)) THEN(ROLLBACK)   /*CEU024*/
                  ENDCMTCTL                                           /*CEU024*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                  ENDJRNPF   FILE(GLAPNAPD) JRN(&JLIB/JREC4201)       /*CEU024*/
                  DLTJRN     JRN(&JLIB/JREC4201)                      /*CEU024*/
                  CHGJOB     INQMSGRPY(*DFT)                          /*CEU024*/
                  DLTJRNRCV  JRNRCV(&JLIB/JRREC4201)                  /*CEU024*/
                  CHGJOB     INQMSGRPY(*RQD)                          /*CEU024*/
             ENDDO                                                    /*CCB009*/
                  ENDDO                                               /*CEU024*/
/**/
/* DELETE ALL OVERRIDES */
/**/
             DLTOVR        (*ALL)
/**/
/* ABNORMAL TERMINATION */
ABNORMAL:
/**/
/* IF U7 & U8 ON - DATABASE ERRORS */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
/* IF U7 IS   ON - FILE CONTROLS OUT OF BALANCE */
/**/
             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 168 8))
                SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MSGDTA)   +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/**/
/* FOR ANY ERROR */
ERROR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4201 ended abnormally - see job log') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/*********** IF         COND(&CEU024 *EQ 'Y' *AND &CEU013 *EQ 'Y') +
/***********      THEN(DO)                              */ /*CEU024*/ /*CEU025*/
             IF         COND((&CEU024 *EQ 'Y' *AND &CEU013 *EQ 'Y') +
                          *OR (&CEU025 *EQ 'Y' *AND &CEU013 *EQ 'Y')) +
                          THEN(DO)                                    /*CEU025*/
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)         /*CEU024*/
                     ROLLBACK                                         /*CEU024*/
                     MONMSG     MSGID(CPF0000 MCH0000)                /*CEU024*/
                  ENDDO                                               /*CEU024*/
                  ENDCMTCTL                                           /*CEU024*/
                  MONMSG     MSGID(CPF0000 MCH0000)                   /*CEU024*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                  ENDJRNPF   FILE(GLAPNAPD) JRN(&JLIB/JREC4201)       /*CEU024*/
                  MONMSG     MSGID(CPF0000 MCH0000)                   /*CEU024*/
                  DLTJRN     JRN(&JLIB/JREC4201)                      /*CEU024*/
                  MONMSG     MSGID(CPF0000 MCH0000)                   /*CEU024*/
                  CHGJOB     INQMSGRPY(*DFT)                          /*CEU024*/
                  MONMSG     MSGID(CPF0000 MCH0000)                   /*CEU024*/
                  DLTJRNRCV  JRNRCV(&JLIB/JRREC4201)                  /*CEU024*/
                  MONMSG     MSGID(CPF0000 MCH0000)                   /*CEU024*/
                  CHGJOB     INQMSGRPY(*RQD)                          /*CEU024*/
                  MONMSG     MSGID(CPF0000 MCH0000)                   /*CEU024*/
             ENDDO                                                    /*CCB009*/
            ENDDO                                                     /*CEU024*/
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
