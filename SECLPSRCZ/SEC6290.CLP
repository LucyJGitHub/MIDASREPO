/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Safe Custody fees Generated Entries')           */
/********************************************************************/
/*                                                                  */
/*       Midas     SECURITIES TRADING MODULE                        */
/*                                                                  */
/*       SEC6290 -  CUSTODY FEE SETTLEMENTS TOTALS REPORT           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01464            DATE 04APR94              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*   S01464 -  Safe Custody Fees                                    */
/*                                                                  */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*S01464*/
             PGM        PARM(&MODE)                                   /*S01464*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ')
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)
             DCL        VAR(&WRK1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WRK2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WRK3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*S01464*/
/* */
/* Check Safe Custody Fees flag on Securities Trading ICD */
/* */
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)
/* */
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)
/* */
             RTVDTAARA  DTAARA(SESTAT (78 1)) RTNVAR(&WRK1)
             RTVDTAARA  DTAARA(SESTAT (79 1)) RTNVAR(&WRK2)
             RTVDTAARA  DTAARA(SESTAT (80 1)) RTNVAR(&WRK3)
/* */
             IF         COND(&WRK1 *EQ 'Y' *OR &WRK2 *EQ 'Y' +
                         *OR &WRK3 *EQ 'Y') THEN(DO)
/* */
/* CREATE LDA IF NOT PRESENT */
/* */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
                                                                      /*S01464*/
/* PERFORM OVERRIDE IF &MODE = 1 */                                   /*S01464*/
             IF         COND(&MODE = '1') THEN(DO)                    /*S01464*/
             OVRDBF     FILE(SEGESCL1) TOFILE(SEGESC1L1)              /*S01464*/
             OVRDBF     FILE(GESCZZ) TOFILE(GESC1ZZ)                  /*S01464*/
             ENDDO                                                    /*S01464*/
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
             CALL       PGM(SE6290)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* */
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/* */
             ENDDO
             ENDDO
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
