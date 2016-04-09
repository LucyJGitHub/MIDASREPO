/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Send msg to pgm message queue -SNDPGMMSG')      */
/********************************************************************/
/*                                                                  */
/*     Midas Standing Data Module                           */
/*                                                                  */
/*     SNDERMSG - SEND ERROR MESSAGE TO PGM MESSAGE QUEUE           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. EXXXXX             DATE DD/MMM/YY             */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
     PGM PARM(&ZAPGVN &ZAPGRL &ZAMSID &ZAMSGF &ZAMSDA &ZAMSTP)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
     DCL VAR(&ZAPGVN) TYPE(*CHAR) LEN(10)
     DCL VAR(&ZAPGRL) TYPE(*CHAR) LEN(5)
     DCL VAR(&ZAMSID) TYPE(*CHAR) LEN(7)
     DCL VAR(&ZAMSGF) TYPE(*CHAR) LEN(10)
     DCL VAR(&ZAMSDA) TYPE(*CHAR) LEN(132)
     DCL VAR(&ZAMSTP) TYPE(*CHAR) LEN(7)
 
/*/COPY WNCPYSRC,SNDERMSG01                                          */
     IF COND(&ZAMSID = ' ') +
        THEN(CHGVAR VAR(&ZAMSID) VALUE(YYY0101))
 
     IF COND(&ZAPGVN = ' ') THEN(DO)
        CHGVAR VAR(&ZAPGVN) VALUE('*')
        CHGVAR VAR(&ZAPGRL) VALUE('*PRV')
     ENDDO
     ELSE CMD(DO)
        IF COND(&ZAPGRL = ' ') THEN(CHGVAR VAR(&ZAPGRL) VALUE(*SAME))
     ENDDO
 
     IF COND(&ZAMSTP = ' ') +
        THEN(CHGVAR VAR(&ZAMSTP) VALUE(*DIAG))
 
     IF COND((&ZAPGVN = *EXT) *OR (&ZAPGRL = *EXT)) +
        THEN(SNDPGMMSG MSGID(&ZAMSID) MSGF(&ZAMSGF) +
                       MSGDTA(&ZAMSDA) TOPGMQ(*EXT) +
                       MSGTYPE(&ZAMSTP))
        ELSE CMD(SNDPGMMSG MSGID(&ZAMSID) MSGF(&ZAMSGF) +
                       MSGDTA(&ZAMSDA) TOPGMQ(&ZAPGRL &ZAPGVN) +
                       MSGTYPE(&ZAMSTP))
 
     RMVMSG CLEAR(*ALL)
/*/COPY WNCPYSRC,SNDERMSG02                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
     ENDPGM
