/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Restart COB after halt & no signoff')        */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close of Business Processing                       */
/*                                                                   */
/*       CBC0070  RESTART COB AFTER HALT & SIGNOFF HASN'T OCCURED    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 07Nov11              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 18Apr95              */
/*                      S01420             DATE 30MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Release 4 packaging.  Data queues moved from XLIB  */
/*                to DPLIB.                                          */
/*       S01408 - Core hook added CBC0070MP1                         */
/*       S01420 - CoB Enhancements (Batch Processing).               */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&DTQCLEN)  TYPE(*DEC) LEN(5) VALUE(1)
/************DCL        VAR(&PRELIB)  TYPE(*CHAR) LEN(2)                                  /*CPK014*/
/************DCL        VAR(&DTAQLIB)  TYPE(*CHAR) LEN(10) +                              /*CPK014*/
/************           VALUE('  XLIB    ')                                               /*CPK014*/
             DCL        VAR(&MSGC) TYPE(*CHAR) LEN(1) VALUE('R')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)               /*S01420*/
             DCL        VAR(&SEV) TYPE(*DEC) LEN(2 0)                 /*S01420*/
             DCL        VAR(&S01420) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01420*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01420*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01420*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01420*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01420*/
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(10) +
                          VALUE('*ALL      ')                         /*S01420*/
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)                /*S01420*/
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(180)                /*S01420*/
             DCL        VAR(&PRC) TYPE(*CHAR) LEN(7) VALUE('RESTART') /*S01420*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                  /*S01420*/
             DCL        VAR(&MES) TYPE(*CHAR) LEN(40)                 /*S01420*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
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
/**/                                                                  /*S01420*/
/**/
/* RESET JOB SWITCHES BEFORE CALL */
/**/
             CHGJOB SWS(XXXXXX00)
/**/
/* CALL CB0070 */
/**/
             CALL CB0070
/**/
/* SEND RESTART MESSAGE TO DTAQ/CBDTQC */
/**/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRELIB)                              /*CPK014*/
/************CHGVAR     VAR(%SST(&DTAQLIB 1 2))  VALUE(&PRELIB)                           /*CPK014*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBC0070MP1                                          */
                                                                      /*S01408*/
/************CALL QSNDDTAQ PARM('CBDTQC    ' &DTAQLIB &DTQCLEN +                          /*CPK014*/
/************           &MSGC)                                                            /*CPK014*/
             CALL       PGM(QSNDDTAQ) PARM('CBDTQC    ' '*LIBL     ' +
                          &DTQCLEN &MSGC)                                                 /*CPK014*/
/**/
/* UPDATE DATA AREA CBSTAT POS 20 TO 'N' */
/**/
             CHGDTAARA  DTAARA(CBSTAT (20 1)) VALUE('N')
             IF         COND(&S01420 *EQ 'Y') THEN(DO)                /*S01420*/
                RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)             /*S01420*/
                RTVMSG     MSGID(CBM0128) MSGF(CBUSRMSG) MSGDTA(&USR) +
                             MSG(&MES) SEV(&SEV)                      /*S01420*/
                CHGVAR     VAR(%SST(&PARM 1 7)) VALUE(&PRC)           /*S01420*/
                CHGVAR     VAR(%SST(&PARM 8 10)) VALUE(&USR)          /*S01420*/
                CHGVAR     VAR(%SST(&PARM 18 10)) VALUE(&JOB)         /*S01420*/
                CHGVAR     VAR(%SST(&PARM 28 6)) VALUE(&NBR)          /*S01420*/
                CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEV)          /*S01420*/
                CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MES)        /*S01420*/
                CALL       PGM(CBC0525) PARM(&ALL &PARM)              /*S01420*/
                CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT +
                             '*LIBL     ')                            /*S01420*/
                CHGVAR     VAR(&TXT) VALUE('Close of Business +
                             Restarted ')                             /*S01420*/
                CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                             X'00000180' &TXT '0')                    /*S01420*/
                CALL       PGM(CB0534)                                /*S01420*/
             ENDDO                                                    /*S01420*/
/**/
             GOTO ENDPGM
/**/
/* ABNORMAL PROCESSING */
/**/
ABNOR:       SNDPGMMSG  MSG('CBC0070 - RESTART OF COB +
             AFTER HALT TERMINATED ABNORMALLY') +
             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      ENDPGM
