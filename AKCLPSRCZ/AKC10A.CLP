/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AK Account keys generation set-up (alloc)')     */
/*********************************************************************/
/*                                                                   */
/*   Midas - Account Key Generator                                   */
/*                                                                   */
/*   AKC10A   - Account Keys Generation Set-up (File Allocation)     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. 103747 *CREATE     Date  10APR97                 */
/*   PREV AMEND NO. XXXXXX             Date  DDMMMYY                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*    103747 - Created for GEMS 103747 to allow the allocation and   */
/*             deallocation of the account keys files inside the     */
/*             program AK0010.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OPT &FLAG)
/**/
/** Variable Declaration                                             */
/**/
             DCL        VAR(&OPT) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/** Initial processing                                               */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/** Option 1 : Allocate the files ACKEYAL and ACKEYAK                */
/**/
             IF         COND(&OPT *EQ 1) THEN(DO)
             ALCOBJ     OBJ((ACKEYAL *FILE *EXCL) (ACKEYAK *FILE +
                          *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(CHGVAR +
                          VAR(&FLAG) VALUE('1'))
             ENDDO
/**/
/** Option 2 : Allocate the files SEACKD and XSEACKD                 */
/**/
             IF         COND(&OPT *EQ 2) THEN(DO)
             ALCOBJ     OBJ((SEACKD *FILE *EXCL) (XSEACKD *FILE +
                          *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(CHGVAR +
                          VAR(&FLAG) VALUE('1'))
             ENDDO
/**/
/** Option 3 : Deallocate the files ACKEYAL and ACKEYAK              */
/**/
             IF         COND(&OPT *EQ 3) THEN(DO)
             DLCOBJ     OBJ((ACKEYAL *FILE *EXCL) (ACKEYAK *FILE +
                          *EXCL))
             MONMSG     MSGID(CPF0000)
             ENDDO
/**/
/** Option 4 : Deallocate the files SEACKD and XSEACKD               */
/**/
             IF         COND(&OPT *EQ 4) THEN(DO)
             DLCOBJ     OBJ((SEACKD *FILE *EXCL) (XSEACKD *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
             ENDDO
 
 END:        ENDPGM
