/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Generate customer reports')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                        */
/*                                                                   */
/*       SDC0750 - Generate Unused Customers & Deleted Customers     */
/*                   still being used Reports.                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO  E26755             DATE 10JAN92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       E26755 - NEW PROGRAM CREATED AS PART OF THE CUSTOMER        */
/*                DELETION CHANGES.                                  */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     Please note that not all files are checked for customer       */
/*     references. The following files are checked :                 */
/*                                                                   */
/*       DEALSDB  - Foreign Exchange Deals                           */
/*       DEALSDC  - Money Market Deals                               */
/*       DEALSDD  - Negotiable Assets Purchased                      */
/*       DEALSDE  - Negotiable Assets Sold                           */
/*       DEALSDG  - Forward rate Agreements/Interest Rate Swaps      */
/*       SDEXSTPD - Extended Settlement Details                      */
/*       SDCLLMPD - Client Limits                                    */
/*       ACCNTAB  - Account Master Details                           */
/*       CLOANCL  - Customer Loans                                   */
/*       FCLTYFN  - Facilities                                       */
/*       GTEESST  - Gaurantees/Security/Collateral                   */
/*       LOAMSDK  - Loan Amendments                                  */
/*                                                                   */
/*     If a customer is referred to on a record that has been        */
/*     logically deleted (ie a deal has been reversed but the        */
/*     record has not been physically dropped from the file) then    */
/*     that customer is still said to be in use.                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* CLEAR THE WORK FILE */
/**/
             CLRPFM     FILE(CLIENTS)
/**/
             OVRDBF FILE(SDCUSTL1) SHARE(*YES)
 
             OPNQRYF FILE(SDCUSTL1) KEYFLD(BBCUST)
 
/* Call the Unused Customers Report Program */
/**/
             CHGJOB     SWS(XXXXXX00)
             CALL       PGM(SD0750) PARM(&RSEQ)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Call the Deleted Customers still in use Report Program */
/**/
             CALL       PGM(SD0751)  PARM(&RSEQ)
 
             CLOF OPNID(SDCUSTL1)
 
             DLTOVR FILE(SDCUSTL1)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('A database error has occurred while +
                          running the deleted customer number +
                          job.') TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
