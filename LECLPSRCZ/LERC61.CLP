/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Individual facility history report')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC61 - Individual Facility History Report.                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       LAST AMEND NO. 144337             DATE 20OCT99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 000004             DATE 16APR92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       144337 - Report is distributed to default output queue      */
/*                even if Instruction Identifier is changed when     */
/*                report is requested.  Add one parameter (SEQ)      */
/*                when LERC61 calls LER610.  Applied fix of SC       */
/*                120200.                                            */
/*       000004 - New program for Release 10.                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
/*********** CALL       PGM(LER610) PARM(&RPARM)                 ***/ /*144337*/
             CALL       PGM(LER610) PARM(&RPARM &RSEQ)                /*144337*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
