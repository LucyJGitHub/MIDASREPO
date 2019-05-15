/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS SWIFT close of business reports')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - SWIFT DIRECT LINK                           */
/*                                                                   */
/*       MSC05 - IC TERMINATION REPORTS                              */
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
/*       Prev Amend No. 086960             Date 20Oct95              */
/*                      E43953             Date 07Oct92              */
/*                      S01310             DATE 06DEC90              */
/*                      X00000             DATE 00XXX00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       086960 - Remove E43953; see change to ms5060.               */
/*       E43953 - Send message if possible array error in MS5060     */
/*       S01310 - Re written for SWIFT rationalisation               */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* DECLARE PARAMETERS */
             DCL        VAR(&MEM2) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,MSC05001                                            */
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Audit message to MRUNQ */
             SNDPGMMSG  MSG('MIDAS/SWIFT Close of Business Reports') +
                          TOMSGQ(MRUNQ)
 
/*/COPY WNCPYSRC,MSC05002                                            */
/* Call Logical Ack's Report */
             CALL       PGM(MS5065) PARM('     ' 'B' 'ALL' +
                          '                      ')
/*/COPY WNCPYSRC,MSC05003                                            */
 
/* If call has ended in error go to appropriate error routine. */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM2)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM2) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ABNOR))
/************                                                 *E43953 086960*/
/************CHGJOB     SWS(XXXX0XXX)                         *E43953 086960*/
/* Call Incoming Messages Report */
             CALL       PGM(MS5060) PARM('     ' 'B' 'ALL' +
                          '                        ')
 
/************IF         COND(%SWITCH(XXXX1X00)) THEN(DO)      *E43953 086960*/
/************     CPYF       FROMFILE(MSTRACPD) TOFILE(*PRINT) +
/************                     OUTFMT(*HEX)                *E43953 086960*/
/************     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)   *E43953 086960*/
/************     SNDPGMMSG  MSG('Possible array index error in +
/************                     MS5060 - Press enter to continue +
/************                     processing.') TOPGMQ(*EXT) +
/************                     TOMSGQ(MOPERQ MRUNQ)        *E43953 086960*/
/************     CHGJOB     SWS(XXXX0XXX)                    *E43953 086960*/
/************ENDDO                                            *E43953 086960*/
/* If call has ended in error go to appropriate error routine. */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM2)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM2) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* If all calls ended normally goto end. */
             GOTO END
 
/* Abnormal error processing. Message to MOPERQ MRUNQ & WORKSTN */
 ABNOR:      SNDPGMMSG  MSG('Midas/Swift Close of Business Reports +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXXX1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
