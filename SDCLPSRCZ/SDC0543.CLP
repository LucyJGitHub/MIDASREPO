/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Lending fields set up')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - STANDING DATA                                   */
/*                                                                   */
/*       SDC0543 - LENDING FILE SET UP FOR S01465                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01465 *CREATE     DATE 22MAR94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM PARM(&RTCDE &PMODE)
 
/**/
/* Declare variables */
/**/
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* Global message monitoring */
/**/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                    CMDLBL(ABNOR))
/**/
/* Call the programs that will initialise the values of the new   */
/* fields depending on the processing mode                        */
/**/
             IF         COND(&PMODE *EQ '1') THEN(DO)
               CALL       PGM(SD0543) PARM(&PMODE)
               IF         COND(%SWITCH(XXXXXX00)) THEN(+
                            GOTO CMDLBL(END))
             ENDDO
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
               CALL       PGM(SD0543) PARM(&PMODE)
               IF         COND(%SWITCH(XXXXXX00)) THEN(+
                            GOTO CMDLBL(END))
             ENDDO
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
               CALL       PGM(SD0544) PARM(&PMODE)
               IF         COND(%SWITCH(XXXXXX00)) THEN(+
                            GOTO CMDLBL(END))
             ENDDO
/**/
/* Abnormal termination */
/**/
 ABNOR:      CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
             CHGJOB     SWS(XXXXXX00)
             SNDMSG     MSG('Program SDC0543 ended abnormally') +
                          TOMSGQ(MOPERQ)
/**/
/* End program */
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
