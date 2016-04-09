/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Test Messages for CGPNARMSG')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGTSTMSG - Test Messages for CGPNARMSG                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      184382             Date 29Sep90              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      089745             Date 24May95              */
/*                      S01522             DATE 29DEC94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       184382 - Missing info on message utility                    */
/*       089745 - Add new parameter on call to AOPNARR0              */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGID &MSGDTA)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL      VAR(&CGMSGF) TYPE(*CHAR) LEN(10) VALUE('QCPFMSG')
             DCL        VAR(&CGMSFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CGPGMQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CGMSDT) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CGPGRL) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CGMSGQ) TYPE(*CHAR) LEN(10) VALUE(CGMSG)
             DCL        VAR(&CGMSGT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
/**********  DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(205)                                 /*CGL029*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(211)                                 /*CGL029*/
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CUST_BRCA) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')
 
/*           CALL       PGM(AOPNARR0) PARM(&RTN_CODE &MSGID &MSGDTA +  *089745*/
/*                        &TXT1)                                       *089745*/
             CALL       PGM(AOPNARR0) PARM(&RTN_CODE &MSGID +
                          &CUST_BRCA &MSGDTA &TXT1)                   /*089745*/
 
/*******     CHGVAR     VAR(&CGMSDT) VALUE(&TXT1)                       *184382*/
             CHGVAR     VAR(&CGMSDT) VALUE(&MSGID || ' ' || &TXT1)     /*184382*/
             CALL       PGM(AOCREPT) PARM(CPF9898 &CGMSGF &CGMSFL +
                          &CGMSDT &CGPGRL &CGPGMQ &CGMSGQ &CGMSGT)
             IF         COND(&RTN_CODE *NE ' ') THEN(DO)
             CHGVAR     VAR(&CGMSDT) VALUE(' ')
/*******     CHGVAR     VAR(&CGMSDT) VALUE(&RTN_CODE)                    *184382*/
/**********  CHGVAR     VAR(&CGMSDT) VALUE(&MSGID*** '!'*****&RTN_CODE)  */ /*184382*/ /*BG18886*/
             CHGVAR     VAR(&CGMSDT) VALUE(&MSGID *CAT '!' *CAT  &RTN_CODE) /*184382*/ /*BG18886*/
 
             CALL       PGM(AOCREPT) PARM(CPF9898 &CGMSGF &CGMSFL +
                          &CGMSDT &CGPGRL &CGPGMQ &CGMSGQ &CGMSGT)
             ENDDO
 
ENDCLPGM:    CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDPGM
