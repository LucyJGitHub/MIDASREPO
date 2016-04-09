/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM INDUST LIMIT/EXPOSURE/AVAIL PROMP')          */
/********************************************************************/
/*                                                                  */
/*       Midas     EXPOSURE MANAGEMENT MODULE                   */
/*                                                                  */
/*       EMC0806P- INDUSTRY LIMIT/EXPOSURE/AVAILABILITY PROMPT      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  E38654          DATE  23APR92              */
/*       PREV AMEND NO.  LN0593          DATE  03AUG90              */
/*                                                                  */
/********************************************************************/
/*       E38654 - PROMPT PGM SHOULD ALLOW FOR F12 AND F10           */
/*       LN0593 - REMOVING F12 FROM THE PROGRAMME AND CORRECT       */
/*                PROCESSING OF REQUEST                             */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('Limits Reporting')
             DCLF       EM0640FM
/**/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)
             RTVJOBA    JOB(&SWSID) USER(&USRID)
/**/
             SNDPGMMSG  MSG('Industry Exposure/Limit/Availability +
                        Report') TOMSGQ(MRUNQ)
/**/
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(CHGVAR VAR(&FULLRE) +
                          VALUE(%SST(&RPARM 1 1)))
/**/
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN05) +
                          VALUE('1'))
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN03) +
                          VALUE('1'))
/**/
             CHGVAR &IN92 '1'
/**/
ERROR:       SNDRCVF RCDFMT(EM0640FM)
/* IF F3, RETURN TO RCF WITH ACTION CODE = END  */
             IF         COND(&IN07 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('E')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/* IF F12, RETURN TO RCF WITH ACTION CODE = FIRST SCREEN */
/*           IF         COND(&IN02 *EQ '1') THEN(DO)                    LN0593*/
/*           CHGVAR     VAR(&RCMD) VALUE('F')                           LN0593*/
/*           GOTO       CMDLBL(ENDLBL)                                  LN0593*/
/*           ENDDO                                                      LN0593*/
/**/
/* IF F12, RETURN TO RCF WITH ACTION CODE = PREVIOUS  */              /*E38654*/
             IF         COND(&IN02 *EQ '1') THEN(DO)                  /*E38654*/
             CHGVAR     VAR(&RCMD) VALUE('F')                         /*E38654*/
             GOTO       CMDLBL(ENDLBL)                                /*E38654*/
             ENDDO                                                    /*E38654*/
/**/
/* IF F10, RETURN TO RCF WITH ACTION CODE = DELETE */
             IF         COND(&IN04 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('D')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/**/
/* CHECK VALIDATION ONLY WHEN NOT ENQUIRY OR DELETE */
             IF         COND(&IN03 *EQ '0' *AND &IN05 *EQ '0') THEN(DO)
/* FULLRE FIELD ENTRY MANDATORY */
             IF         COND(&FULLRE *NE 'E' *AND &FULLRE *NE 'F') +
                          THEN(DO)
             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR VAR(&IN92) VALUE('0')
             GOTO       CMDLBL(ERROR)
             ENDDO
/**/
                 CHGVAR     VAR(&RPARM) VALUE(&FULLRE)
/**/
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDLBL:    ENDPGM
