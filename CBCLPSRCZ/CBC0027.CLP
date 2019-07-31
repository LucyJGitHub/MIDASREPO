/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Sign off from COB monitor')                  */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close of Business Processing                       */
/*                                                                   */
/*       CBC0027 - SIGN OFF CLOSE OF BUSINESS MONITOR                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01420             Date 21Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  S01420 - CoB Enhancements (Batch Processing)                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SWITCH)
/**/
             DCL        VAR(&SWITCH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DTQALEN) TYPE(*DEC) LEN(5) VALUE(00016)
             DCL        VAR(&MSGA) TYPE(*CHAR) LEN(16) +
                          VALUE('               E')
             DCL        VAR(&DTQCLEN) TYPE(*DEC) LEN(5) VALUE(00001)
             DCL        VAR(&MSGC) TYPE(*CHAR) LEN(1) +
                          VALUE('C')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)               /*S01420*/
             DCL        VAR(&PRC) TYPE(*CHAR) LEN(7) VALUE('SIGNOFF') /*S01420*/
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(10) +
                          VALUE('*ALL      ')                         /*S01420*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                  /*S01420*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(40)                 /*S01420*/
             DCL        VAR(&SEVR) TYPE(*DEC) LEN(2 0)                /*S01420*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01420*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01420*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01420*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01420*/
             DCL        VAR(&S01420) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01420*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,CBC0027001                                          */
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/                                                                  /*S01420*/
/* Determine if SAR S01420 (CoB Enh.) is switched ON */               /*S01420*/
/**/                                                                  /*S01420*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01420*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01420*/
             CHGVAR     VAR(&SAR) VALUE('S01420')                     /*S01420*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01420*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01420) VALUE('Y'))                    /*S01420*/
/**/
/* IF CALLED FROM SECONDARY SCREEN SIGN OFF IMMEDIATELY */
/**/
             IF         COND(&SWITCH *EQ 'B') THEN(GOTO +
                          CMDLBL(SIGNOFF))
/**/
/* ALLOCATE DATA AREA CBSTAT */
/**/
             ALCOBJ     OBJ((CBSTAT *DTAARA *EXCL))
/**/
/* SEND TERMINATE CLOSE OF BUSINESS MESSAGE */
/* TO SCHEDULER AND RESTART DATA QUEUES*/
/**/
             CALL       PGM(QSNDDTAQ) PARM('CBDTQA' '*LIBL' &DTQALEN +
                          &MSGA)
             CALL       PGM(QSNDDTAQ) PARM('CBDTQC' '*LIBL' &DTQCLEN +
                          &MSGC)
/**/
/* UPDATE DATA AREA CBSTAT WITH SIGN OFF VALUES */
/**/
             CHGDTAARA  DTAARA(CBSTAT (17 1)) VALUE('N')
             CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE(&SWITCH)
/*                                                                   */
/* Remove 'EOD' from MQ/MSPECIAL                                     */
 
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(*CLS)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             RCVMSG     MSGQ(MSPECIAL) RMV(*YES)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
/**/
/* SIGN OFF SYSTEM */
/**/
/****SIGNOFF:*****SIGNOFF    LOG(*NOLIST) ***********/                /*S01420*/
SIGNOFF:                                                              /*S01420*/
             IF      COND(&S01420 *EQ 'Y') THEN(DO)                   /*S01420*/
                RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)             /*S01420*/
                RTVMSG     MSGID(CBM0131) MSGF(CBUSRMSG) MSGDTA(&USR) +
                             MSG(&MSG) SEV(&SEVR)                     /*S01420*/
                CHGVAR     VAR(%SST(&PARM 1 7)) VALUE(&PRC)           /*S01420*/
                CHGVAR     VAR(%SST(&PARM 8 10)) VALUE(&USR)          /*S01420*/
                CHGVAR     VAR(%SST(&PARM 18 10)) VALUE(&JOB)         /*S01420*/
                CHGVAR     VAR(%SST(&PARM 28 6)) VALUE(&NBR)          /*S01420*/
                CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEVR)         /*S01420*/
                CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MSG)        /*S01420*/
/* Sends the message */                                               /*S01420*/
                CALL       PGM(CBC0525) PARM(&ALL &PARM)              /*S01420*/
/* Terminate job     */                                               /*S01420*/
                CALL       PGM(CBC0518)                               /*S01420*/
                MONMSG     MSGID(CPF0000)                             /*S01420*/
             ENDDO                                                    /*S01420*/
/*/COPY WNCPYSRC,CBC0027002                                          */
             SIGNOFF         LOG(*NOLIST)                             /*S01420*/
/*/COPY WNCPYSRC,CBC0027003                                          */
/**/
/* DEALLOCATE DATA AREA CBSTAT */
/**/
             DLCOBJ     OBJ((CBSTAT *DTAARA *EXCL))
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/* ABNORNAL TERMINATION PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('SIGN OFF CLOSE OF BUSINESS MONITOR +
                          PROGRAM TERMINATED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     (CPF0000 MCH0000)
/**/
 ENDPGM:     ENDPGM
