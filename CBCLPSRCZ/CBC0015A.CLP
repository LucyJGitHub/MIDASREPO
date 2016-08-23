/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Call monitor menu from main monitor')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0015A - CALL CLOSE OF BUSINESS MONITOR MENU              */
/*                  FROM MAIN MONITOR MENU                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. 196795             Date 13Aug01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev AMEND NO. 095122             DATE 26OCT95              */
/*                      S01420             DATE 11APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       196795 - Use DTAARA CBRECV instead of DTAQ MAINDTQ to avoid */
/*                object lock at V5R1M0.                             */
/*       095122 - In some circumstances the attention key stops      */
/*                working.  This is caused by job switch number 1    */
/*                being left on after a previous error or screen     */
/*                timeout.  Solution is to switch it off.            */
/*                This program was switching it off if the batch     */
/*                monitor feature was off, but not if it was on.     */
/*       S01420 - CoB Enhancements (Batch Monitor)                   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01420*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01420*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01420*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01420*/
             DCL        VAR(&S01420) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01420*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                /*S01420*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                  /*S01420*/
             DCL        VAR(&NETA) TYPE(*CHAR) LEN(1) VALUE('N')      /*S01420*/
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)                /*S01420*/
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(180)                /*S01420*/
             DCL        VAR(&SYSNAM) TYPE(*CHAR) LEN(8)               /*S01420*/
                                                                      /*S01420*/
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
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
/* ALLOCATE DATA AREA FOR EXCLUSIVE USE */
/**/
             IF         COND(&S01420 *NE 'Y') THEN(DO)                /*S01420*/
             ALCOBJ     OBJ((CB0015 *DTAARA *EXCL)) WAIT(10)
/**/
/* IF DATA AREA IS IN USE SEND MESSAGE TO SCREEN AND END PROGRAM */
/**/
             MONMSG     MSGID(CPF1002) +
                        EXEC(DO)
                                 SNDPGMMSG MSG('Menu already +
                                 displayed at another workstation') +
                                 TOPGMQ(*EXT)
                                 GOTO      CMDLBL(ENDPGM)
                        ENDDO
                        ENDDO                                         /*S01420*/
             ELSE DO
/**/                                                                  /*S01420*/
/* Default system name indicator to Y */                              /*S01420*/
/**/                                                                  /*S01420*/
             CHGVAR     VAR(&NETA) VALUE('Y')                         /*S01420*/
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)               /*S01420*/
/**/                                                                  /*S01420*/
/*/COPY WNCPYSRC,CBC0015AMS                                        */ /*S01420*/
/**/                                                                  /*S01420*/
             ENDDO                                                    /*S01420*/
/**/
/* ELSE CALL PROGRAM TO DISPLAY SCREEN */
/**/
/*CALL:***** CALL       PGM(CB0015) PARM('A')*********/               /*S01420*/
 CALL:       IF         COND(&S01420 *NE 'Y') THEN(CALL PGM(CB0015) +
                          PARM('A'))                                  /*S01420*/
             ELSE       CMD(DO)                                       /*S01420*/
               CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT +
                            '*LIBL     ')                             /*S01420*/
               CHGVAR     VAR(&TXT) VALUE('CoB Menu Request ')        /*S01420*/
               CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                            X'00000180' &TXT '0')                     /*S01420*/
               CALL       PGM(CB0534)                                 /*S01420*/
               OVRDBF     FILE(CBUSERL0) TOFILE(CBUSERL0) SHARE(*YES) /*S01420*/
               CALL       PGM(CB0015A) PARM('A' &JOB &USER &NBR &NETA +
                            &S01420)                                  /*S01420*/
/************  CALL       PGM(QCLRDTAQ) PARM('MAINDTQ' '*LIBL ')      /*S01420*/          /*196795*/
/************  MONMSG     MSGID(CPF0000)                              /*S01420*/          /*196795*/
               DLTOVR     FILE(CBUSERL0)                              /*S01420*/
             ENDDO                                                    /*S01420*/
/**/
/* DEALLOCATE DATA AREA AND RESET TIME OUT */
/* SWITCH FOR NEXT CALL OF MONITOR */
/**/
             IF         COND(&S01420 *NE 'Y') THEN(DO)                /*S01420*/
             DLCOBJ     OBJ((CB0015 *DTAARA *EXCL))
 
/** Move the ENDDO to before the CHGJOB to ensure that switch 1 gets +
    turned off even when batch monitor is on. */                      /*095122*/
             ENDDO                                                    /*095122*/
             CHGJOB     SWS(0XXXXXXX)
/************ENDDO                                         /*S01420*/ /*095122*/
             GOTO       CMDLBL(ENDPGM)
/**/
 ABNOR:      SNDPGMMSG  MSG('CLOSE OF BUSINESS MONITOR MENU PROGRAM +
                          TERMINATED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      ENDPGM
