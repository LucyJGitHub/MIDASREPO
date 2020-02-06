/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Loan Sub-type Amendments Selection')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LEC369  - Loan sub-types amendment selection                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. MOF60              Date 23Mar92              */
/*                                         Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
     PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
     MONMSG MSGID(CPF0000 RPG0000) EXEC(GOTO CMDLBL(ABNORMAL))
     CHGJOB SWS(XXXXXX00)
     OVRDBF FILE(LOAMSDK) SHARE(*YES)
     OPNQRYF FILE((LOAMSDK)) QRYSLT('RECI *EQ "D" *AND AMTP *EQ -
"LS"') KEYFLD((BRCA) (LNRF)) OPNID(LE0369SEL)
     CALL PGM(LE0369)
     CLOF OPNID(LE0369SEL)
     DLTOVR FILE(*ALL)
     GOTO CMDLBL(END)
ABNORMAL:
     CHGJOB SWS(XXXXXX11)
     DMPCLPGM
     CLOF OPNID(LE0369SEL)
     MONMSG MSGID(CPF0000)
     DLTOVR FILE(*ALL)
     MONMSG MSGID(CPF0000)
END: +
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
     ENDPGM
