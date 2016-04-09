/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Loan Sub-type Amendments Selection')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LEC369  - Loan sub-types amendment selection                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. MOF60              DATE 23MAR92              */
/*       PREV AMEND NO.                    DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
     PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
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
                          Misys International Banking Systems Ltd.')
     ENDPGM
