/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Check Leo Phase of Day')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SCC1111 - Check Leo Phase of Day                            */
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
/*       Prev Amend No. 091837             Date 16Aug95              */
/*                      082075             Date 25Jan95              */
/*                       S01408           DATE 19JUN95               */
/*                       S01467           DATE 04AUG94               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       091837 - Reverse out 082075, LPHAS is in the DTALIB.        */
/*       082075 - DTAARA/LPHAS is located in DMLIB, not DTALIB       */
/*       S01408 - Addition of core hook SCC1111MP1                   */
/*              - Addition of core hook SCC1111MP2                   */
/*       S01467 - Midas/Leo Integration - Standing Data              */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LPHA &ACTN &RTRN)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&LPHA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(8)            */ /*082075*/
/************DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8) */  /*082075*/ /*091837*/
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(8)               /*091837*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHAS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USERM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SJOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SJOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
 
 
/* Retrieve the value of LOPREF - the data area containing the Leo +
   system prefix */
             RTVDTAARA  DTAARA(LOPREF *ALL) RTNVAR(&PREF)
 
/* If either position is blank, this is an error */
             IF         COND((%SST(&PREF 1 1) *EQ ' ') *OR +
                          (%SST(&PREF 2 1) *EQ ' ')) THEN(DO)
 
/* Return an error code, and end the program */
             CHGVAR     VAR(&RTRN) VALUE(*ERROR)
             GOTO       CMDLBL(END)
             ENDDO
 
/* Set up the name of the library containing the data area LPHAS, +
   retrieve the data area to a variable, and check position 1 */
/************CHGVAR     VAR(&DTALIB) VALUE(&PREF *CAT 'DTALIB')    */ /*082075*/
/************CHGVAR     VAR(&DMLIB) VALUE(&PREF *CAT 'DMLIB')  /*082075*091837*/
             CHGVAR     VAR(&DTALIB) VALUE(&PREF *CAT 'DTALIB')       /*091837*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1111MP2                                          */
                                                                      /*S01408*/
/************RTVDTAARA  DTAARA(&DTALIB/LPHAS) RTNVAR(&PHAS)        */ /*082075*/
/************RTVDTAARA  DTAARA(&DMLIB/LPHAS) RTNVAR(&PHAS) /*082075*/ /*091837*/
             RTVDTAARA  DTAARA(&DTALIB/LPHAS) RTNVAR(&PHAS)           /*091837*/
             IF         COND(%SST(&PHAS 1 1) *NE 'I') THEN(DO)
             CHGVAR     VAR(&LPHA) VALUE('C')
             ENDDO
             IF         COND(%SST(&PHAS 1 1) *EQ 'I') THEN(DO)
             CHGVAR     VAR(&LPHA) VALUE('I')
             ENDDO
 
/* Check Parameter 2. If this is 'A' we need to place a message on +
   Leo Message Queue LSTATUS to prevent the Leo CoB starting */
             IF         COND(&ACTN *EQ 'A') THEN(DO)
             IF         COND(&LPHA *EQ 'I') THEN(DO)
             CHGVAR     VAR(&XLIB) VALUE(&PREF *CAT 'XLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1111MP1                                          */
                                                                      /*S01408*/
             RTVJOBA    USER(&SUSER)
             SNDMSG     MSG(&SUSER) TOMSGQ(&XLIB/LSTATUS)
             ENDDO
             ELSE CMD(DO)
             CHGVAR     VAR(&MESSAGE) VALUE('Option invalid. Leo +
                          not in Input Cycle.')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('SCC1111' 'ENTER' ' ')
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO
 
/* Check Parameter 2. If this is 'R' we need to remove a message on +
   Leo Message Queue LSTATUS */
             IF         COND(&ACTN *EQ 'R') THEN(DO)
             IF         COND(&LPHA *EQ 'I') THEN(DO)
             CHGVAR     VAR(&XLIB) VALUE(&PREF *CAT 'XLIB')
 
             CHGMSGQ    MSGQ(&XLIB/LSTATUS) RESET(*YES)
             RTVJOBA    JOB(&SJOB) USER(&SUSER) NBR(&SJOBNO)
 
 MESSAGE1:   RCVMSG     MSGQ(&XLIB/LSTATUS) RMV(*NO) KEYVAR(&KEYVAR) +
                          SENDER(&SEND)
/* Particular user message has not been found; send message to +
   the user */
 
             IF         COND(&SEND *EQ ' ') THEN(DO)
             CHGVAR     VAR(&MESSAGE) VALUE('The message for this +
                          job is not on LSTATUS')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('SCC1111' 'ENTER' ' ')
             GOTO       CMDLBL(END)
             ENDDO
 
/* Find out if this particular message was sent from this job;  +
   If not get the next message; +
   If so, remove it and continue processing */
             CHGVAR     VAR(&JOB) VALUE(%SST(&SEND 1 10))
             CHGVAR     VAR(&USERM) VALUE(%SST(&SEND 11 10))
             CHGVAR     VAR(&JOBNO) VALUE(%SST(&SEND 21 6))
 
             IF         COND(&JOBNO *EQ &SJOBNO *AND &JOB *EQ &SJOB +
                          *AND &USERM *EQ &SUSER) THEN(RMVMSG +
                          MSGQ(&XLIB/LSTATUS) MSGKEY(&KEYVAR))
             ELSE       CMD(GOTO CMDLBL(MESSAGE1))
             ENDDO      /* Leo in I/C */
             ELSE       CMD(DO) /* Leo not in I/C */
             CHGVAR     VAR(&MESSAGE) VALUE('Option invalid. Leo +
                          not in Input Cycle.')
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('SCC1111' 'ENTER' ' ')
             GOTO       CMDLBL(END)
             ENDDO
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
