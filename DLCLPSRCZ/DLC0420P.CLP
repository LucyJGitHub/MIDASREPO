/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Fwd Reval by NPV Method Prompt Screen')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0420P - Fwd Revaluation by NPV Method Prompt Screen      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG11277           Date 25Apr06              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CAS001  *CREATE    Date 23Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG11277 - DLC0420 10001 terminated abnormally              */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQN &RLEVL &RENTY &RPARM &RACTN &RFUNC)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RSEQN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENTY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RFUNC) TYPE(*CHAR) LEN(1)
 
             DCLF       FILE(DL0420DF) RCDFMT(DL0420F1)
 
             CHGVAR     VAR(&IN15) VALUE('0')
             IF         COND(&RACTN *EQ 'E' *OR &RACTN *EQ 'D') +
                          THEN(DO)
                            CHGVAR VAR(&IN15) VALUE('1')
             ENDDO
 
             IF         COND(&RACTN *EQ 'A' *OR &RACTN *EQ 'E' *OR +
                          &RACTN *EQ 'D') THEN(CHGVAR +
                            VAR(&#1NPV) VALUE(&RPARM))
             ELSE       CHGVAR VAR(&#1NPV) VALUE(' ')
 
 ERROR:      SNDRCVF    RCDFMT(DL0420F1)
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
 
/* If F3, Return to RCF with action code = 'END' */
             IF         COND(&IN01 *EQ '1') THEN(DO)
               CHGVAR     VAR(&RFUNC) VALUE('E')
               GOTO       CMDLBL(ENDLBL)
             ENDDO
 
/* If F12, Return to RCF with action code = 'PREVIOUS' */
             IF         COND(&IN02 *EQ '1') THEN(DO)
               CHGVAR     VAR(&RFUNC) VALUE('F')
               GOTO       CMDLBL(ENDLBL)
             ENDDO
 
/* Check Inputs */
/**********  IF         COND(&#1NPV *NE ' ') THEN(DO)                */                 /*BUG11277*/
             IF         COND(&#1NPV *NE 'N' & &#1NPV *NE 'F' & &#1NPV *NE +
                          'B' & &#1NPV *NE 'D' & &#1NPV *NE '*') THEN(DO)
               CHGVAR     VAR(&#1MSG) VALUE('     Invalid NPV Method +
                                ')
               CHGVAR     VAR(&IN10) VALUE('1')
               CHGVAR     VAR(&IN12) VALUE('1')
               GOTO       CMDLBL(ERROR)
               ENDDO
/**********  ENDDO                                                   */                 /*BUG11277*/
 
             CHGVAR     VAR(%SUBSTRING(&RPARM 1 1)) VALUE(&#1NPV)
 
 ENDLBL:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2001')
             ENDPGM
