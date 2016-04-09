/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE CI Interface Start-Up')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4420 - Cashier Interface Start-Up                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      119592             Date 20JUN97              */
/*                      118737             Date 14JUN97              */
/*                      118513             Date 22MAY97              */
/*                      CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastracture     */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       119592 - Strip fix 119592                                   */
/*       118737 - Make interface start-up crash-proof                */
/*       118513 - Make the cashier interface start up dependent upon */
/*                the BOB SAVE switchable feature (CSC001)           */
/*       CRT003 - Cashier Interface                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&INIT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)  VALUE(' ')
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)  VALUE('*FIRST')
             DCL        VAR(&BAII)   TYPE(*CHAR) LEN(800) VALUE(' ')
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*118513*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*118513*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*118513*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*118513*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*****************************************************************118513119592*/
/**If*CSC001*'ON'*DO*NOT*run*the*start*up*of*background*jobs*NOW**118513119592*/
/**run*the*start*up*of*background*jobs*in*ICIFINISH***************118513119592*/
/*****************************************************************118513119592*/
/************CHGVAR*****VAR(&RTN)*VALUE('*******')****************118513119592*/
/************CHGVAR*****VAR(&OPN)*VALUE('*VERIFY')****************118513119592*/
/************CHGVAR*****VAR(&SARD)*VALUE('CSC001')****************118513119592*/
/************CALL*******PGM(AOSARDR0)*PARM(&RTN*&OPN*&SARD*&SFMT)*118513119592*/
/*****************************************************************118513119592*/
/**************RTVDTAARA**DTAARA(MPHAS**ALL)*RTNVAR(&MPHAS)*******118513119592*/
/*****************************************************************118513119592*/
/**Don't*'START'*go*to*the*'END'*if*start*is*attempted*at*ICINIT**118513119592*/
/************IF*********COND(&RTN**NE*'*******'**OR*&MPHAS**EQ*'A'118513119592*/
/*************************THEN(DO)********************************118513119592*/
 
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
 
             CALL       PGM(AOBAIIR0) PARM(&RTCD &OPTN &BAII)
 
/* Call the pgm */
 
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             ELSE       (DO)
               RTVDTAARA  DTAARA(MPHAS *ALL) RTNVAR(&MPHAS)
               CHGVAR     VAR(&INIT) VALUE(%SST(&BAII 47 1))
 
/**********    IF         COND(&INIT *EQ 'Y' *AND &MPHAS *EQ 'F') THEN(DO)             */ /*CCB020*/
               IF         COND(&INIT *EQ 'Y' *AND &MPHAS *EQ 'C') THEN(DO)                /*CCB020*/
/**********         STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))     /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
                    CALL PGM(RE4420)
                    ENDCMTCTL
               ENDDO
 
/*    Should be possible to restart the interface even if 'Start at   /*118737*/
/*    I/C Init' is Y, in case it has fallen over or shut down via menu/*118737*/
/**************IF         COND(&INIT *EQ 'N' *AND &MPHAS *EQ 'A') +   /*118737*/
/****************THEN(DO)                                             /*118737*/
/**********    IF         COND(&MPHAS *EQ 'A') THEN(DO)                        /*118737*/ /*CCB020*/
               IF         COND((&MPHAS *EQ 'A') *OR +
                          (&MPHAS *EQ 'G')) THEN(DO)                                      /*CCB020*/
 
/*    If the interface is not active, clear the active jobs file      /*118737*/
/*    before starting the interface, in case it fell over before      /*118737*/
                   ALCOBJ     OBJ((REACJBPD *FILE *EXCL)) WAIT(1)     /*118737*/
                   MONMSG MSGID(CPF1002) EXEC(GOTO CALLPGM)           /*118737*/
                   CLRPFM FILE(REACJBPD)                              /*118737*/
                   DLCOBJ     OBJ((REACJBPD *FILE *EXCL))             /*118737*/
 CALLPGM:                                                             /*118737*/
                   CALL   PGM(RE4420)
                 ENDDO
 
/*    Database error processing                                      */
 
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(ABNOR)
               ENDDO
             ENDDO
 
/************ENDDO************************************************118513119594*/
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG('CI Background Task Initiator Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
 END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
