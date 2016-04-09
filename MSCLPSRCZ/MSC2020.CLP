/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Incoming messages report request')              */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                             */
/*                                                                   */
/*     MSC2020 - INCOMING MESSAGES REPORT REQUEST                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. S01310            DATE  06DEC90                */
/*     PREV AMEND NO. S01259            DATE  20AUG90                */
/*                    BHF538            DATE   03SEP90               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     S01310 - SWIFT RATIONALISATION                                */
/*     S01259 - If SWIFT II on call MS5055 else call MS2020          */
/*     BHF538 - THIS FIX WAS PUT IN AS PART OF S01310                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM******                                                /*S01310*/
             PGM PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)           /*S01310*/
/*                                                                   */
/* Declare Message Detail Field.                                    */
/*                                                                  */
/************DCL******  VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01310*/
             DCL        VAR(&MEM2) TYPE(*CHAR) LEN(50)                /*S01259*/
/************DCL******  VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01310*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01310*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01310*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01310*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01310*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01310*/
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(24)               /*S01310*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                   */
/* Set-off Data Base Error Switches.                                 */
/*                                                                   */
             CHGJOB     SWS(XXXXXX00)
/*                                                                   */
/* Call Input Cycle Report Program.                           */
/*                                                                  */
/************RTVDTAARA  DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
/*********************                                          /*S01259S01310*/
/***If*SWIFT*II*on call MS5055                                  /*S01259S01310*/
/************IF*COND(&SWII *EQ 'Y') THEN(DO)                    /*S01259S01310*/
/***************CALL PGM(MS5055)                                /*S01259S01310*/
    CALL PGM(MS5055) PARM(&RSEQ &RLEV &RENT &PARAM &RACT &RCMD)       /*S01310*/
                                                                      /*S01259*/
/* For Database Errors Recover Data From Local Data Area, Send        /*S01259*/
/* Message to MOPERQ.                                                 /*S01259*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                      /*S01259*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM2)         /*S01259*/
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM2) +
                TOMSGQ(MOPERQ MRUNQ)                                  /*S01259*/
                ENDDO                                                 /*S01259*/
 
             CHGVAR VAR(&RPARM) VALUE(&PARAM)                         /*S01310*/
             CHGVAR VAR(%SST(&RPARM 100 1)) VALUE('X')                /*S01310*/
/************ENDDO****                                          /*S01259S01310*/
/*********************                                          /*S01259S01310*/
/***If*SWIFT*II*off*call MS2020                                 /*S01259S01310*/
/************IF**COND(&SWII *NE 'Y') THEN(DO)                   /*S01259S01310*/
/************CALL*****  PGM(MS2020)                                   /*S01310*/
/*********************                                                /*S01310*/
/**For*Database*Errors Recover Data From Local Data Area, Send        /*S01310*/
/**Message*to*MOPERQ.                                                 /*S01310*/
/*********************                                                /*S01310*/
/************IF*******  COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01310*/
/****************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         /*S01310*/
/****************SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) + /*S01310*/
/*********************    TOMSGQ(MOPERQ MRUNQ)                        /*S01310*/
/************ENDDO****                                                /*S01310*/
/************ENDDO****                                          /*S01259S01310*/
/*                                                                   */
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Incoming Messages Report Request ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
