/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Early Redemptions Reference')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC6500 - Early Redemptions Maintenance                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. CSE010             Date 21Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Pref Amend No. S01496             Date 12Oct94              */
/*                      S10978             Date 04Mar93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE010 - SE Transaction Enhancement                         */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
/*********** DCL        VAR(&FEA) TYPE(*CHAR) LEN(1)               */ /*S01496*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE010*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE010*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSE010*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CSE010*/
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1)               /*CSE010*/
/**/                                                                  /*CSE010*/
/**  Check if Transaction Enhancements is installed */                /*CSE010*/
/**/                                                                  /*CSE010*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE010*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE010*/
             CHGVAR     VAR(&SAR) VALUE('CSE010')                     /*CSE010*/
             CHGVAR     VAR(&CSE010) VALUE('N')                       /*CSE010*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CSE010*/
             IF COND(&RTCD *EQ '       ') THEN(DO)                    /*CSE010*/
                CHGVAR     VAR(&CSE010) VALUE('Y')                    /*CSE010*/
                OVRDBF FILE(SECTYX)   TOFILE(SECTY)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(SEDEVX)   TOFILE(SEDEV)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(SECTYZ1)  TOFILE(SECTY)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(SECTYZ2)  TOFILE(SECTY)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(SECTYZ3)  TOFILE(SECTY)    SHARE(*NO)     /*CSE010*/
                OVRDBF FILE(TRADSX1)  TOFILE(TRADS)    SHARE(*NO)     /*CSE010*/
             ENDDO                                                    /*CSE010*/
 
/*/COPY WNCPYSRC,SEC6500001                                          */
             CHGJOB SWS(00000000)
 
/*********** RTVDTAARA  DTAARA(LZSTAT (49 1)) RTNVAR(&FEA)         */ /*S01496*/
/*********** IF         COND(&FEA *NE 'Y') THEN(DO)                */ /*S01496*/
/*********** SNDPGMMSG  MSG('Option not allowed, Early Redemptions +  /*S01496*/
/***********              Feature not installed.') TOPGMQ(*EXT)    */ /*S01496*/
/***********   GOTO       CMDLBL(ENDCLPGM)                         */ /*S01496*/
/*********** ENDDO                                                 */ /*S01496*/
 
/*/COPY WNCPYSRC,SEC6500002                                          */
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CALL       PGM(SE6500) PARM(&PARM)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
 
/* For Database Errors Recover Data from LDA */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
/***********                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6500 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             RCLRSC
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
