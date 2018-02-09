/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Start interface batch jobs at end of COB')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2014 - START INTERFACE BATCH JOBS AT END OF COB          */
/*                                                                   */
/*       Function: To submit the Loan Manager Interface batch jobs   */
/*                 at the end of the COB (LEC2010xxx and LEC2016)    */
/*                                                                   */
/*       Calls:    None                                              */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 203561 *CREATE     Date 20Jun02              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       203561 - Created as part of 203561.                         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JSEQNO) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&W#LEJNSQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('LEC2014 - Start Loan Manager Interface +
                          Jobs') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
/* Retrieve Journal Entry */
 
                 RTVJRNE    JRN(ICJRN) FROMENT(*LAST) TOENT(*LAST) +
                            SEARCH(*DESCEND) RTNSEQNBR(&JSEQNO)
                 RTVDTAARA  DTAARA(LEJNSQ) RTNVAR(&W#LEJNSQ)
                 CHGVAR     VAR(&W#LEJNSQ) VALUE(&JSEQNO)
 
/* Reset LEJNSQ data area with last journal sequence number */
 
             CHGDTAARA  DTAARA(LEJNSQ) VALUE(&W#LEJNSQ)
 
/* Submit Loan Manager Interface LEC2010xxx jobs) */
 
             CALL       PGM(LEC2010) PARM('ALL' '')
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Submit Loan Manager Drip Feed LEC2016 job) */
 
             CALL       PGM(LEC2012)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('LEC2012 - Start Loan Manager drip +
                          feed job has ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Normal termination */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
