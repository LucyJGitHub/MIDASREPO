/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Load Statement Requests with Priority')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC43T0 - Midas GL Load Statement Requests with Priority    */
/*                                                                   */
/*       (c) Finastra International Limited 2018                     */
/*                                                                   */
/*       Last Amend No. BA5009             Date 06Sep23              */
/*       Prev Amend No. BA5008             Date 06Sep23              */
/*                      CGL188  *Create    Date 19Feb18              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BA5009 - Extra Statement of Accounts for A/c codes          */
/*                "0000002362" to "0000002369" (Non Month End)       */
/*       BA5008 - Extra Statement of Accounts for A/c codes          */
/*                "0000002362" to "0000002369" (Month End)           */
/*       CGL188 - COB Optimisation of GL0420                         */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*BA5008*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*BA5008*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*BA5008*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*BA5008*/
             DCL        VAR(&BA5008) TYPE(*CHAR) LEN(1) VALUE('N')                        /*BA5008*/
             DCL        VAR(&BA5009) TYPE(*CHAR) LEN(1) VALUE('N')                        /*BA5009*/

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GLC43T0 - Midas GL Load Statement Requests with +
                          Priority') TOMSGQ(MRUNQ)
/**/                                                                                      /*BA5008*/
/** Access SAR file to determine if switchable feature BA5008 is switched ON.          */ /*BA5008*/
/**/                                                                                      /*BA5008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*BA5008*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*BA5008*/
             CHGVAR     VAR(&SARD) VALUE('BA5008')                                        /*BA5008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                     /*BA5008*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&BA5008) VALUE('Y'))                                        /*BA5008*/
/**/                                                                                      /*BA5008*/
/** Access SAR file to determine if switchable feature BA5009 is switched ON.          */ /*BA5009*/
/**/                                                                                      /*BA5009*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*BA5009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*BA5009*/
             CHGVAR     VAR(&SARD) VALUE('BA5009')                                        /*BA5009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                     /*BA5009*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&BA5009) VALUE('Y'))                                        /*BA5009*/

             CLRPFM     FILE(GLSTPRPD)

             OVRDBF     FILE(GLSTPRPD) SEQONLY(*YES 500)
             OVRDBF     FILE(STMTS) SEQONLY(*YES 500)

             CALL       PGM(GL43T0)

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

                                                                                          /*BA5008*/
             IF         COND(&BA5008 *EQ 'Y' *OR &BA5009 *EQ 'Y') THEN(DO)         /*BA5008 BA5009*/
             CPYF       FROMFILE(ACCNTAB) TOFILE(A5ACCNPP) +
                          MBROPT(*REPLACE)                                                /*BA5008*/
             ENDDO                                                                        /*BA5008*/
                                                                                          /*BA5008*/
             GOTO       CMDLBL(END)

 ABNOR:      SNDPGMMSG  MSG('Program GLC43T0 ended abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited')
             ENDPGM
