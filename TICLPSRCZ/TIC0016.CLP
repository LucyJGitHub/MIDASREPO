/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Check if any TI CoB comps have failed')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0016 - Check if any TI CoB components have failed        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CTI003  *CREATE    Date 02Apr01              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CTI003 - Midas/TI Interface CoB changes                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODULE &REPLY)
 
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CHECK1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CHECK2) TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(CBCOMSL8)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* Read CBCOMSL8 to identify failed CoB components. */
READ:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(REPORT)
             ENDDO
 
             IF         COND(&DHCMOD *EQ &MODULE) THEN(DO)
                CHGVAR     VAR(&CHECK1) VALUE('*YES')
             ENDDO
             IF         COND(&DHCMOD *NE &MODULE) THEN(DO)
                CHGVAR     VAR(&CHECK2) VALUE('*YES')
             ENDDO
 
             GOTO       CMDLBL(READ)
 
REPORT:
             IF         COND(&CHECK1 *EQ '*YES' *AND &CHECK2 *EQ +
                          '*YES') THEN(DO)
                CHGVAR     VAR(&REPLY) VALUE('*BOTH')
             ENDDO
             IF         COND(&CHECK1 *EQ '*YES' *AND &CHECK2 *NE +
                          '*YES') THEN(DO)
                CHGVAR     VAR(&REPLY) VALUE('*ONLY')
             ENDDO
             IF         COND(&CHECK1 *NE '*YES' *AND &CHECK2 *EQ +
                          '*YES') THEN(DO)
                CHGVAR     VAR(&REPLY) VALUE('*NOT ')
             ENDDO
             IF         COND(&CHECK1 *NE '*YES' *AND &CHECK2 *NE +
                          '*YES') THEN(DO)
                CHGVAR     VAR(&REPLY) VALUE('*NONE')
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
