/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FF Generate amort. a/c keys (COB)')             */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0650  -  GENERATE AMORTIZATION ACCOUNT KEYS (COB)            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*   Last Amend No. LLN022A            Date 03Jun15                  */
/*   Prev Amend No. LLN022             Date 03Jun15                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                  CCB009             Date 01Jun00                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Prev Amend No. 082461             Date 08Mar95                  */
/*                  S01117             Date 02Apr90                  */
/*                  E15903             DATE  01SEP89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  LLN022A - BOE Upgrade to MidasPlus - incorporate hook FFC0650001 */
/*  LLN022  - BOE Upgrade to MidasPlus.                              */
/*            Inserted hook FFC0650001                               */
/*  CCB009 - Journal files throughout close of business              */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*   E15903  -  AMENDS PROGRAM TO CLR ALL MEMBERS OF FOKEY, SO THAT  */
/*              FFC0670 RECEIVES THE CORRECT DATA.                   */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &MKT          TYPE(*CHAR)  LEN(2)             /*E15903*/
             DCL        &A            TYPE(*DEC)   LEN(2 0) VALUE(1)  /*E15903*/
             DCL        &FFEOC        TYPE(*CHAR)  LEN(256)           /*E15903*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&LLN022) TYPE(*CHAR) LEN(1) VALUE(' ')                       /*LLN022A*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                        /*LLN022A*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*082461*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*082461*/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0650 - Generate +
                          Amortization Account Keys') TOMSGQ(MRUNQ)
/**/
/* CLEAR FOKEY FILES THEN INITIALISE FILE BEFORE RUNNING              */
/**/                                                                  /*E15903*/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                  /*E15903*/
/**/                                                                  /*E15903*/
             CLRPFM     FILE(FOKEYD) MBR(*FIRST)
             CLRPFM     FILE(FOKEYA) MBR(*FIRST)
             INZPFM     FILE(FOKEYA) MBR(*FIRST) TOTRCDS(1)
/**/                                                                  /*E15903*/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC   */  /*E15903*/
/**/                                                                  /*E15903*/
 LOOP:                                                                /*E15903*/
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ')  +
                        *OR (&A *GT 61)) THEN(GOTO CMDLBL(NEXT))      /*E15903*/
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))            /*E15903*/
/**/
/*  CLEAR CORRECT MEMBER FOR MARKET FOR MULTI-MEMBER FILES        */  /*E15903*/
/**/
             CLRPFM     FILE(FOKEYD) MBR(&MKT)                        /*E15903*/
             CLRPFM     FILE(FOKEYA) MBR(&MKT)                        /*E15903*/
             INZPFM     FILE(FOKEYA) MBR(&MKT) TOTRCDS(1)             /*E15903*/
/**/                                                                  /*E15903*/
             CHGVAR     VAR(&A) VALUE(&A + 2)                         /*E15903*/
             GOTO       CMDLBL(LOOP)                                  /*E15903*/
NEXT:
/* START JOURNALLING OF PF/AMORTD                                   */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/AMORTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
                                                                      /*082461*/
             GOTO       CMDLBL(BYPASS)                                /*082461*/
                                                                      /*082461*/
JRNFAIL:                                                              /*082461*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*082461*/
             IF         COND(&COUNT *LE 3) THEN(DO)                   /*082461*/
             DLYJOB     DLY(60)                                       /*082461*/
             GOTO       CMDLBL(RETRY)                                 /*082461*/
             ENDDO                                                    /*082461*/
             ELSE       CMD(DO)                                       /*082461*/
             GOTO       CMDLBL(ABNOR)                                 /*082461*/
             ENDDO                                                    /*082461*/
             ENDDO                                                    /*CCB009*/
BYPASS:                                                               /*082461*/
/**/
/*  CALL START JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN2    FILES(AMORTD)
/**/
/*  OVERRIDE PF/FOKEYD                                              */
/**/
             OVRDBF     FILE(FOKEYD) SEQONLY(*YES 100)
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/*   CALL FF0620 - GENERATE AMORTIZATION ACCOUNT KEYS               */
/**/
             CALL       PGM(FF0620)
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/** Check if BOE processing installed                                                    /*LLN022A*/
 
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'LLN022')                             /*LLN022A*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&LLN022) VALUE('Y'))                           /*LLN022A*/
                                                                                         /*LLN022A*/
             IF    COND(&LLN022 *EQ 'Y')  THEN(DO)                                       /*LLN022A*/
 
             CPYF       FROMFILE(FOKEYD) TOFILE(BYFOKYPP) +
                          FROMMBR(&MKT) TOMBR(*FIRST) MBROPT(*ADD) +
                          CRTFILE(*NO)                                                   /*LLN022A*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                   /*LLN022A*/
 
             ENDDO                                                                       /*LLN022A*/
             GOTO       CMDLBL(END)                                   /*082461*/
ABNOR:                                                                /*082461*/
             SNDPGMMSG  MSG('FFC0650 - Generate Amortisation +
                          Account Keys TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             DMPCLPGM                                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             CHGJOB     SWS(XXXXXX11)                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
                                                                      /*082461*/
END:                                                                  /*082461*/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(FOKEYD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN3    FILES(AMORTD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
