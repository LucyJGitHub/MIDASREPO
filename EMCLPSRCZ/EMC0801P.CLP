/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM LIMITS REPORTING PROMPT')                    */
/********************************************************************/
/*                                                                  */
/*       Midas     EXPOSURE MANAGEMENT MODULE                   */
/*                                                                  */
/*       EMC0801P- LIMITS REPORTING PROMPT PROGRAM                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No.  BUG18886        Date  20May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No.  E38654          Date  23Apr92              */
/*                       LN0593          Date  03Aug90              */
/*                                                                  */
/********************************************************************/
/*       BUG18886 - Non-standard codes exist in Midas Plus core     */
/*                  sources                                         */
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
/*/COPY WNCPYSRC,EMC0801P01                                          */
/**/
             DCLF       FILE(EM0500FM)
/**/
             CHGVAR     VAR(&IN93) VALUE('0')
             CHGVAR     VAR(&IN94) VALUE('0')
             CHGVAR     VAR(&IN95) VALUE('1')
/**/
             RTVJOBA    JOB(&SWSID) USER(&USRID)
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)
/**/
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(CHGVAR VAR(&U1) +
                          VALUE(%SST(&RPARM 1 1)))
/**/
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(CHGVAR VAR(&U2) +
                          VALUE(%SST(&RPARM 2 1)))
/**/
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN05) +
                          VALUE('1'))
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN04) +
                          VALUE('1'))
/*/COPY WNCPYSRC,EMC0801P02                                          */
/**/
 A:          SNDRCVF    RCDFMT(EM0500FM)
/**/
             IF         COND(&RACT *EQ 'I' *OR &RACT *EQ 'A') THEN(DO)
             CHGVAR     VAR(&IN93) VALUE('0')
             CHGVAR     VAR(&IN94) VALUE('0')
             CHGVAR     VAR(&IN95) VALUE('1')
/*/COPY WNCPYSRC,EMC0801P03                                          */
             ENDDO
/**/
             IF         COND(&IN07) THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('E')
             GOTO CMDLBL(END)
             ENDDO
/* IF F12, RETURN TO RCF WITH ACTION CODE = PREVIOUS  */              /*E38654*/
             IF         COND(&IN02 *EQ '1') THEN(DO)                  /*E38654*/
             CHGVAR     VAR(&RCMD) VALUE('F')                         /*E38654*/
             GOTO       CMDLBL(END)                                   /*E38654*/
             ENDDO                                                    /*E38654*/
/**/
/*           IF         COND(&IN02) THEN(DO)                            LN0593*/
/*           CHGVAR     VAR(&RCMD) VALUE('F')                           LN0593*/
/*           GOTO CMDLBL(END)                                           LN0593*/
/*           ENDDO                                                      LN0593*/
/**/
             IF         COND(&IN03) THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('D')
             GOTO CMDLBL(END)
             ENDDO
/**/
/* CHECK VALIDATION ONLY WHEN INSERT OR AMEND */
/**/
             IF         COND(&RACT *EQ 'I' *OR &RACT *EQ 'A') THEN(DO)
/**/
             IF         COND(&U1 *NE ' ' *AND &U1 *NE 'Y') THEN(DO)
                    CHGVAR &IN95 '0'
                    CHGVAR &IN93 '1'
                 ENDDO
/**/
             IF (&U2 *NE 'Y' *AND &U2 *NE ' ') THEN(DO)
                    CHGVAR &IN95 '0'
                    CHGVAR &IN94 '1'
                 ENDDO
/**/
/*           IF (&U1 *EQ 'Y' *AND &U2 *EQ 'Y') THEN(DO)                 LN0593*/
/*                  CHGVAR &IN95 '0'                                    LN0593*/
/*                  CHGVAR &IN94 '1'                                    LN0593*/
/*                  CHGVAR &IN93 '1'                                    LN0593*/
/*               ENDDO                                                  LN0593*/
/**/
             IF (&U1 *EQ ' ' *AND &U2 *EQ ' ') THEN(DO)
                    CHGVAR &IN95 '0'
                    CHGVAR &IN94 '1'
                    CHGVAR &IN93 '1'
                 ENDDO
/*/COPY WNCPYSRC,EMC0801P04                                          */
/**/
             ENDDO
             IF         COND(&IN95 *EQ '0') THEN(GOTO CMDLBL(A))
/*/COPY WNCPYSRC,EMC0801P05                                          */
/*           CHGVAR     VAR(&RPARM) VALUE(&U1 ** &U2) */ /* BUG18886 */
             CHGVAR     VAR(&RPARM) VALUE(&U1 *CAT &U2) /* BUG18886 */
/*/COPY WNCPYSRC,EMC0801P06                                          */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
