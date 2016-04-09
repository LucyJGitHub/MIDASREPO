/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Branch Groupings Audit Control')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                       */
/*                                                                   */
/*       CFC0015 - BRANCH GROUPINGS AUDIT CONTROL                    */
/*                 CALLED BY EDSAUDIT IN THE END OF DAY AUDIT STREAM */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01184            DATE 15DEC89               */
/*       PREV AMEND NO.                   DATE DDMMMYY               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01184 - CREATED FOR CONFIRMATION MATCHING                  */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
 
             CALL       PGM(*LIBL/CF0015)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERRDTA)
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                GOTO ABNOR
                ENDDO
 
             GOTO (END)
 
 ABNOR:      SNDPGMMSG  MSG('CF0015 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
