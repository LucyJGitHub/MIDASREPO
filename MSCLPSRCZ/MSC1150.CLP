/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Queries/Answers Input')                         */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                             */
/*                                                                   */
/*     MSC1150 - QUERIES/ANSWERS INPUT                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01310             Date 06Dec90              */
/*                      S01259             Date 20Aug90              */
/*                NO  S01117            DATE  24JAN90                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     S01310 - SWIFT RATIONALISATION                                */
/*     S01259 - If SWIFT II on call MS5020 else call MS1150          */
/*     S01117 - MULTIBRANCH                                          */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QAPARM)
/*                                                                   */
/*     DECLARE PARAMETERS                                            */
/*                                                                   */
/************DCL********VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01310*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&QAPARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM2) TYPE(*CHAR) LEN(50)                /*S01259*/
/************DCL********VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                   */
/* GLOBAL MONITOR MESSAGE                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                   */
/*     SET OFF EXTERNAL SWITCHES                                     */
/*                                                                   */
             CHGJOB     SWS(00000000)
/*                                                                   */
/*     CALL REPORT PROGRAM                                           */
/*                                                                   */
/************RTVDTAARA**DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/****If*SWIFT*II*on*call*MS5010                                 /*S01259S01310*/
/************IF*COND(&SWII**EQ 'Y') THEN(DO)                    /*S01259S01310*/
                                                                      /*S01259*/
             OVRDBF FILE(MGOREFLX) TOFILE(MGOREFL0) SHARE(*NO)        /*S01310*/
                                                                      /*S01259*/
             IF COND(&QAPARM *EQ Q) THEN(DO)                          /*S01259*/
                CALL PGM(MS5020) PARM('Q')                            /*S01259*/
                MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)        /*S01259*/
                ROLLBACK                                              /*S01259*/
                SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                           Enter to continue.') TOPGMQ(*EXT)          /*S01259*/
                ENDDO                                                 /*S01259*/
             ENDDO                                                    /*S01259*/
                                                                      /*S01259*/
             IF COND(&QAPARM *EQ A) THEN(DO)                          /*S01259*/
                CALL PGM(MS5020) PARM('A')                            /*S01259*/
                MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)        /*S01259*/
                ROLLBACK                                              /*S01259*/
                SNDPGMMSG  MSG('Transaction failed. Re-input necessary. +
                           Enter to continue.') TOPGMQ(*EXT)          /*S01259*/
                ENDDO                                                 /*S01259*/
             ENDDO                                                    /*S01259*/
/*                                                                    /*S01259*/
/**  Database error processing. Send message to workstation & MOPERQ  /*S01259*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                      /*S01259*/
                ROLLBACK                                              /*S01259*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM2)         /*S01259*/
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM2) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)                /*S01259*/
                ENDDO                                                 /*S01259*/
/************ENDDO*********                                     /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/************IF*COND(&SWII**NE 'Y') THEN(DO)                    /*S01259S01310*/
/************IF*********COND(&QAPARM *EQ Q) THEN(DO)                  /*S01310*/
/******************CALL****   PGM(MS1150) PARM('Q')                   /*S01310*/
/******************MONMSG**   MSGID(CPF0000 RPG0000 MCH0000) +        /*S01310*/
/**********************EXEC(DO)                                       /*S01310*/
/*************************ROLLBACK                                    /*S01310*/
/*************************SNDPGMMSG MSG('Transaction failed. Re-input /*S01310*/
/*************************necessary. Enter to continue.') TOPGMQ(*EXT)/*S01310*/
/**********************ENDDO                                          /*S01310*/
/*****************ENDDO****                                           /*S01310*/
/************ELSE*******CMD(DO)                                       /*S01310*/
/******************CALL****   PGM(MS1150) PARM('A')                   /*S01310*/
/******************MONMSG**   MSGID(CPF0000 RPG0000 MCH0000) +        /*S01310*/
/**********************EXEC(DO)                                       /*S01310*/
/*************************ROLLBACK                                    /*S01310*/
/*************************SNDPGMMSG MSG('Transaction failed. Re-input /*S01310*/
/*************************necessary. Enter to continue.') TOPGMQ(*EXT)/*S01310*/
/**********************ENDDO                                          /*S01310*/
/******************ENDDO***                                           /*S01310*/
/**************************                                           /*S01310*/
/******DATABASE*ERROR*PROCESSING. SEND MESSAGE TO MOPERQ & WORKSTN    /*S01310*/
/**************************                                           /*S01310*/
/************IF*COND(%SWITCH(XXXXXX11)) +                             /*S01310*/
/***************THEN(DO)***                                           /*S01310*/
/******************ROLLBACK                                           /*S01310*/
/******************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       /*S01310*/
/******************SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) /*S01310*/
/**************************TOMSGQ(MOPERQ)                             /*S01310*/
/******************SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) /*S01310*/
/**************************TOPGMQ(*EXT)                               /*S01310*/
/***************ENDDO******                                           /*S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/*                                                                   */
             GOTO ENDPGM
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Queries/Answers Input ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
/*     RECLAIM RESOURCES                                             */
/*                                                                   */
 ENDPGM:     RCLRSC
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
