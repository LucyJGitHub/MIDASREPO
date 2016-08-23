/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Corporate actions maintenance')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7502  - Corporate Actions Maintenance                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CSE020             Date 21Mar00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE007             Date 01Aug97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE020 - Corporate Actions Domino Effect Processing         */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSE020*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSE020*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSE020*/
             DCL        VAR(&CSE020) TYPE(*CHAR) LEN(1)               /*CSE020*/
             DCL        VAR(&WJOB) TYPE(*CHAR) LEN(10)                /*CSE020*/
             DCL        VAR(&WNBR) TYPE(*CHAR) LEN(6)                 /*CSE020*/
             DCL        VAR(&WMBR) TYPE(*CHAR) LEN(10)                /*CSE020*/
             DCL        VAR(&WCRT) TYPE(*CHAR) LEN(1)                 /*CSE020*/
/*/COPY WNCPYSRC,SEC7502001                                          */
 
             CHGJOB SWS(00000000)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)
             ENDDO
 
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SE7502')
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
/**/                                                                  /*CSE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE020*/
             CHGVAR     VAR(&SAR) VALUE('CSE020')                     /*CSE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE020*/
             CHGVAR     VAR(&CSE020) VALUE('N')                       /*CSE020*/
             CHGVAR     VAR(&WCRT) VALUE('N')                         /*CSE020*/
/**/                                                                  /*CSE020*/
/**  Check if Corporate Action is installed */                        /*CSE020*/
/**/                                                                  /*CSE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR)          /*CSE020*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSE020*/
                CHGVAR     VAR(&CSE020) VALUE('Y')                    /*CSE020*/
             ENDDO                                                    /*CSE020*/
/**/                                                                  /*CSE020*/
 
             OVRDBF FILE(SECTYX)   TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(SEDEVX)   TOFILE(SEDEV)    SHARE(*NO)
             OVRDBF FILE(SECTYZ1)  TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(SECTYZ2)  TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(SECTYZ3)  TOFILE(SECTY)    SHARE(*NO)
             OVRDBF FILE(TRADSX1)  TOFILE(TRADS)    SHARE(*NO)
             IF         COND(&CSE020 *EQ 'Y') THEN(DO)                /*CSE020*/
             IF         COND(&WCRT *EQ 'N') THEN(DO)                  /*CSE020*/
             RTVJOBA    JOB(&WJOB) NBR(&WNBR)                         /*CSE020*/
             CHGVAR     VAR(&WMBR) VALUE(%SST(&WJOB 1 3) *CAT &WNBR)  /*CSE020*/
             ADDPFM     FILE(SECORFPM) MBR(&WMBR)                     /*CSE020*/
             MONMSG     MSGID(CPF7306) EXEC(DO)                       /*CSE020*/
             CLRPFM     FILE(SECORFPM) MBR(&WMBR)                     /*CSE020*/
             ENDDO                                                    /*CSE020*/
             CHGVAR     VAR(&WCRT) VALUE('Y')                         /*CSE020*/
             ENDDO                                                    /*CSE020*/
             OVRDBF     FILE(SECORFPM) MBR(&WMBR) +
                          RCDFMTLCK((SECORFM0 *SHRUPD))               /*CSE020*/
             OVRDBF     FILE(SECORFLA1) TOFILE(SECORFLA) SHARE(*NO)   /*CSE020*/
             ENDDO                                                    /*CSE020*/
/**/                                                                  /*CSE020*/
 
/*/COPY WNCPYSRC,SEC7502002                                          */
/*********** CALL       PGM(SE7502) PARM(&PARM)                  ***/ /*CSE020*/
             CALL       PGM(SE7502) PARM(&PARM &WMBR)                 /*CSE020*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
/**/                                                                  /*CSE020*/
             IF         COND(&CSE020 *EQ 'Y') THEN(DO)                /*CSE020*/
             RMVM       FILE(SECORFPM) MBR(&WMBR)                     /*CSE020*/
             ENDDO                                                    /*CSE020*/
/**/                                                                  /*CSE020*/
/*/COPY WNCPYSRC,SEC7502003                                          */
 
/* For Database Errors Recover Data from LDA */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR VAR(&MEM) VALUE('SEC7502 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             RCLRSC
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
