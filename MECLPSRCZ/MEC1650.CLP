/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME BIC Excluded phrases list')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC1650  - CL component to control ME1650                   */
/*                  BIC repair excluded phrases list                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG3657            Date 16Jul04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT007             Date 02Nov99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       BUG3657 - Delete the execution parameter in COB components  */
/*                 file.  Send message in RUNQ if component is       */
/*                 running during COB. Applied fix 221334.           */
/*       CFT007 - BIC Database Plus Integration                      */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLVL &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                         */ /*BUG3657 CCB020*/
/**/
             CHGJOB     SWS(XXXXXX00)
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                           */ /*BUG3657 CCB020*/
/**********  IF         COND(%SST(&MPHAS 1 1) = 'C') THEN(SNDPGMMSG +
                          MSG('MEC1650 - BIC Excluded phrases +
                          list') TOMSGQ(MRUNQ))                                */ /*BUG3657 CCB020*/
/**/
/** call program **/
/**/
        CALL       PGM(ME1650) PARM(&RSEQ)
/**/
/** check for database errors trapped by program if called in I/C**/
/**/
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
/**/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                   TOMSGQ(MRUNQ MOPERQ)
/**/
        ENDDO
 
/**/
/** check for FOOB errors trapped by program **/
/**/
        IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
/**/
                 SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)
/**/
        ENDDO
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
